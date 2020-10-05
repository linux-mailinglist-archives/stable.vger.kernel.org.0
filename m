Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D1283A40
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgJEPcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgJEPco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE6F206DD;
        Mon,  5 Oct 2020 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911962;
        bh=VwviBkeFQfpZQfvwJnmD7Z816gFKDnEJN6hT9796Wzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJluZKxntxiALPYeXx47SuRsLvziezabYBacgXITS2H6pa2ubDI0oJptFCU5u5iKM
         DhP9qQGFlxC6WKPgDqelixLk5gYa3d094fZNynSw0ItjVfp3aFm0m22wiMRw/8qgSF
         BhKHXeyaNN7WSm5q3nw2wBu2kn8JIS4OK1BhGXJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 48/85] nvme-fc: fail new connections to a deleted host or remote port
Date:   Mon,  5 Oct 2020 17:26:44 +0200
Message-Id: <20201005142117.043082074@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



