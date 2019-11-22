Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175C4106E66
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKVLIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:08:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbfKVLEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38F8520870;
        Fri, 22 Nov 2019 11:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420661;
        bh=RgYw0oBSLwQBhdw3WvYdr72j1tYCT0JVBwh8M+A/DAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwjybFPNRxSDCKv87xU1Wpj2O70Gw91YA6lGLytkduuMJApVR568t+eolqEIm6HgA
         4MzmgtiWX+qpC8KERgzw8Vx9egyctc/5DW8C/fJ3S1m7Hq7R/BKj/TzvqI8pAsgjj6
         Y/zmJgBZLKsZW8qHkFgLGtijAn/7EP5cl6IzwoRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/220] lightnvm: do no update csecs and sos on 1.2
Date:   Fri, 22 Nov 2019 11:29:09 +0100
Message-Id: <20191122100927.483665470@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier González <javier@javigon.com>

[ Upstream commit 6fd05cad5ee1290b276dd8ed90a1e019b1fa577a ]

1.2 devices exposes their data and metadata size through the separate
identify command. Make sure that the NVMe LBA format does not override
these values.

Signed-off-by: Javier González <javier@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/lightnvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index 6fe5923c95d4a..a69553e75f38e 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -968,6 +968,9 @@ void nvme_nvm_update_nvm_info(struct nvme_ns *ns)
 	struct nvm_dev *ndev = ns->ndev;
 	struct nvm_geo *geo = &ndev->geo;
 
+	if (geo->version == NVM_OCSSD_SPEC_12)
+		return;
+
 	geo->csecs = 1 << ns->lba_shift;
 	geo->sos = ns->ms;
 }
-- 
2.20.1



