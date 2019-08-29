Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A5CA235A
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfH2SPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbfH2SPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FFD23407;
        Thu, 29 Aug 2019 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102507;
        bh=ZuIUC6IsQVsuToBGxQ468oPKs3JC4O7eQPHO/n+rARg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjK1dCNizTWs/64teXanEf5d3U66QOeWyHKanaMuTYMH/eAYI9r71o9W2QxD8bn54
         kTuzA7oUkb9rTE+wK8S7d/o6YRupLiUeL1HC/7d30hwoXPHvoGeW+n8mymy9RIjfzL
         9px4wZtTlfxMq7QS8Imxr95aGJf4YIo3icTjiizU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 57/76] nvme: Fix cntlid validation when not using NVMEoF
Date:   Thu, 29 Aug 2019 14:12:52 -0400
Message-Id: <20190829181311.7562-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>

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
index 5deb4deb38209..c40b807c667ed 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2543,6 +2543,9 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 			goto out_free;
 	}
 
+	if (!(ctrl->ops->flags & NVME_F_FABRICS))
+		ctrl->cntlid = le16_to_cpu(id->cntlid);
+
 	if (!ctrl->identified) {
 		int i;
 
@@ -2643,7 +2646,6 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 			goto out_free;
 		}
 	} else {
-		ctrl->cntlid = le16_to_cpu(id->cntlid);
 		ctrl->hmpre = le32_to_cpu(id->hmpre);
 		ctrl->hmmin = le32_to_cpu(id->hmmin);
 		ctrl->hmminds = le32_to_cpu(id->hmminds);
-- 
2.20.1

