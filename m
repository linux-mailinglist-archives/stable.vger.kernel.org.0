Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C9134C801
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhC2ITB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233200AbhC2ISa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E0C86196F;
        Mon, 29 Mar 2021 08:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005909;
        bh=RtfMfFdXbSM5Jog0bLkmqFSpPWEsmx/kkedCJDwYaaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vlomh38RRut+pmiCBtvcQLRyGm4VyG1i3lPNhFYReLVzKrnqIzSFP+DDdBeZfKjAX
         9I41BOtrgsrTgVjFRQP13MVXkD8yhyKrDy7xMMdH25ZnY1/c9AG8Iut3yB9UwX6okD
         lXuuVkY3CAHtfcaIJeaSh3Qkx2c3KrON2k58ZkVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/221] nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted
Date:   Mon, 29 Mar 2021 09:56:19 +0200
Message-Id: <20210329075630.785025386@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit ae3afe6308b43bbf49953101d4ba2c1c481133a8 ]

When a command has been aborted we should return NVME_SC_HOST_ABORTED_CMD
to be consistent with the other transports.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index d221a98a677b..41257daf7464 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1956,7 +1956,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 				sizeof(op->rsp_iu), DMA_FROM_DEVICE);
 
 	if (opstate == FCPOP_STATE_ABORTED)
-		status = cpu_to_le16(NVME_SC_HOST_PATH_ERROR << 1);
+		status = cpu_to_le16(NVME_SC_HOST_ABORTED_CMD << 1);
 	else if (freq->status) {
 		status = cpu_to_le16(NVME_SC_HOST_PATH_ERROR << 1);
 		dev_info(ctrl->ctrl.device,
-- 
2.30.1



