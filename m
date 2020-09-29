Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC66327B9B9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgI2Bc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727764AbgI2BcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:32:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2678922262;
        Tue, 29 Sep 2020 01:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343116;
        bh=DxmXQ0Tdp39gX86Jbi3MkEGmk5C1zYx5p0z3mnIsGPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNP4JzzwiUhRsajLCmo+uqgcnV5tSyeWg4Ez8dGLxFIzj0fa9+x12cTdZ2NyTQFP2
         LY/n/Pd6DPopT8Fp8QxhPnhv8V9Q93pWiGc1+m6HqereTFa6jUD8gU/Swv1vRD0VdC
         Jh0huIg82yItOGfoSLszVKoegDjKSvrn7y+jZsnw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 9/9] nvme-fc: fail new connections to a deleted host or remote port
Date:   Mon, 28 Sep 2020 21:31:44 -0400
Message-Id: <20200929013144.2406985-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013144.2406985-1-sashal@kernel.org>
References: <20200929013144.2406985-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

[ Upstream commit 9e0e8dac985d4bd07d9e62922b9d189d3ca2fccf ]

The lldd may have made calls to delete a remote port or local port and
the delete is in progress when the cli then attempts to create a new
controller. Currently, this proceeds without error although it can't be
very successful.

Fix this by validating that both the host port and remote port are
present when a new controller is to be created.

Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index e95d2f75713e1..7e3f3055a6777 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3012,12 +3012,14 @@ nvme_fc_create_ctrl(struct device *dev, struct nvmf_ctrl_options *opts)
 	spin_lock_irqsave(&nvme_fc_lock, flags);
 	list_for_each_entry(lport, &nvme_fc_lport_list, port_list) {
 		if (lport->localport.node_name != laddr.nn ||
-		    lport->localport.port_name != laddr.pn)
+		    lport->localport.port_name != laddr.pn ||
+		    lport->localport.port_state != FC_OBJSTATE_ONLINE)
 			continue;
 
 		list_for_each_entry(rport, &lport->endp_list, endp_list) {
 			if (rport->remoteport.node_name != raddr.nn ||
-			    rport->remoteport.port_name != raddr.pn)
+			    rport->remoteport.port_name != raddr.pn ||
+			    rport->remoteport.port_state != FC_OBJSTATE_ONLINE)
 				continue;
 
 			/* if fail to get reference fall through. Will error */
-- 
2.25.1

