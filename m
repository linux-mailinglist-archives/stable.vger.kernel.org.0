Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB6DACE2B
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfIHMyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732907AbfIHMwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:09 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CBF321479;
        Sun,  8 Sep 2019 12:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947128;
        bh=qPuD7XW3lQqhbO102freFUAxgN1elJih8aQ+EltLze8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/+zkIv8w9obxRmxp48DkGDAhijzXyAVP6duEVPqxAcn9ClWHZVyZSZRKvNrR3Mob
         I9RMbEPIRy2oLUYmPRrCR4CHHPcTRaK6kAczc/cgDyGUimyKlLXpzVhEEhVUVg2d4b
         9sjhya6iJXACD+1QBgOfzhkHbWe/oAh27mXa6D/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 72/94] nvme: Fix cntlid validation when not using NVMEoF
Date:   Sun,  8 Sep 2019 13:42:08 +0100
Message-Id: <20190908121152.495117701@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a89fcca8185633993018dc081d6b021d005e6d0b ]

Commit 1b1031ca63b2 ("nvme: validate cntlid during controller initialisation")
introduced a validation for controllers with duplicate cntlid that runs
on nvme_init_subsystem(). The problem is that the validation relies on
ctrl->cntlid, and this value is assigned (from id_ctrl value) after the
call for nvme_init_subsystem() in nvme_init_identify() for non-fabrics
scenario. That leads to ctrl->cntlid always being 0 in case we have a
physical set of controllers in the same subsystem.

This patch fixes that by loading the discovered cntlid id_ctrl value into
ctrl->cntlid before the subsystem initialization, only for the non-fabrics
case. The patch was tested with emulated nvme devices (qemu) having two
controllers in a single subsystem. Without the patch, we couldn't make
it work failing in the duplicate check; when running with the patch, we
could see the subsystem holding both controllers.

For the fabrics case we see ctrl->cntlid has a more intricate relation
with the admin connect, so we didn't change that.

Fixes: 1b1031ca63b2 ("nvme: validate cntlid during controller initialisation")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 601509b3251ae..963b4c6309b9c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2549,6 +2549,9 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 			goto out_free;
 	}
 
+	if (!(ctrl->ops->flags & NVME_F_FABRICS))
+		ctrl->cntlid = le16_to_cpu(id->cntlid);
+
 	if (!ctrl->identified) {
 		int i;
 
@@ -2649,7 +2652,6 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 			goto out_free;
 		}
 	} else {
-		ctrl->cntlid = le16_to_cpu(id->cntlid);
 		ctrl->hmpre = le32_to_cpu(id->hmpre);
 		ctrl->hmmin = le32_to_cpu(id->hmmin);
 		ctrl->hmminds = le32_to_cpu(id->hmminds);
-- 
2.20.1



