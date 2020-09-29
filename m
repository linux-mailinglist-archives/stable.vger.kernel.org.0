Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C427B97F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgI2BbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727485AbgI2BbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2015821734;
        Tue, 29 Sep 2020 01:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343061;
        bh=VwviBkeFQfpZQfvwJnmD7Z816gFKDnEJN6hT9796Wzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO0ESZY15Zr0SeeyPgs5DGUMFFNzgJMpg1us61fnjoodZ/JB55kAWfMy4cni2vb7z
         z6LnkTt9K+2kKxWZwjeATkVO21hUV7/iJevjbT3AhRAbRKTKebjU9cMDXz1QABiI3p
         kNiz69kD01dqhMPzaK+HguV3l8zVpDz5XgVGzcdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 27/29] nvme-fc: fail new connections to a deleted host or remote port
Date:   Mon, 28 Sep 2020 21:30:24 -0400
Message-Id: <20200929013027.2406344-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
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
index 92c966ac34c20..43c1745ecd45b 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3668,12 +3668,14 @@ nvme_fc_create_ctrl(struct device *dev, struct nvmf_ctrl_options *opts)
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

