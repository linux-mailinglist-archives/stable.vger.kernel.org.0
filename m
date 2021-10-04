Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA65420EDA
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbhJDN3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237230AbhJDN1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A80CD61B7E;
        Mon,  4 Oct 2021 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353136;
        bh=m/5ddGXSfdhPtFJXUzaC7za8uPkkfSuEvLxm9cwUvtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03OPsZiSW9M6izkDJe2Enb/Cg3sGtFC8nqWGFAjDH6cIz2qXfHyQaCp4Kldvh5fzm
         zxHp7NGarxv5RrjCr3oZ9HZXC4EIZsRij/ocEFCbskavhzcsK8TKlIgLhW1sYejf2G
         ZCzfKsm2pacch0pwwIsMk+kazFCYbEWxm8wnH1KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 010/172] scsi: elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology
Date:   Mon,  4 Oct 2021 14:51:00 +0200
Message-Id: <20211004125045.299762913@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 96fafe7c6523886308605d30ec92c7936abe7c2c ]

The kernel test robot flagged an warning for ".../efc_device.c:932:6:
warning: cast to smaller integer type 'enum efc_nport_topology' from 'void
*'"

For the topology events, the "arg" field is generically defined as a void *
and is used to pass different arguments. Most of the arguments are pointers
to data structures. But for the EFC_EVT_NPORT_TOPOLOGY_NOTIFY event, the
argument is an enum value, and the code is typecasting the void * to an
enum generating the warning.

Fix by converting the EFC_EVT_NPORT_TOPOLOGY_NOTIFY event to pass a pointer
to the enum, thus it's a straight-forward pointer dereference in the event
handler.

Link: https://lore.kernel.org/r/20210830231050.5951-1-jsmart2021@gmail.com
Fixes: 202bfdffae27 ("scsi: elx: libefc: FC node ELS and state handling")
Reported-by: kernel test robot <lkp@intel.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efc_device.c | 7 +++----
 drivers/scsi/elx/libefc/efc_fabric.c | 3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
index 725ca2a23fb2..52be01333c6e 100644
--- a/drivers/scsi/elx/libefc/efc_device.c
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -928,22 +928,21 @@ __efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
 		break;
 
 	case EFC_EVT_NPORT_TOPOLOGY_NOTIFY: {
-		enum efc_nport_topology topology =
-					(enum efc_nport_topology)arg;
+		enum efc_nport_topology *topology = arg;
 
 		WARN_ON(node->nport->domain->attached);
 
 		WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
 
 		node_printf(node, "topology notification, topology=%d\n",
-			    topology);
+			    *topology);
 
 		/* At the time the PLOGI was received, the topology was unknown,
 		 * so we didn't know which node would perform the domain attach:
 		 * 1. The node from which the PLOGI was sent (p2p) or
 		 * 2. The node to which the FLOGI was sent (fabric).
 		 */
-		if (topology == EFC_NPORT_TOPO_P2P) {
+		if (*topology == EFC_NPORT_TOPO_P2P) {
 			/* if this is p2p, need to attach to the domain using
 			 * the d_id from the PLOGI received
 			 */
diff --git a/drivers/scsi/elx/libefc/efc_fabric.c b/drivers/scsi/elx/libefc/efc_fabric.c
index d397220d9e54..3270ce40196c 100644
--- a/drivers/scsi/elx/libefc/efc_fabric.c
+++ b/drivers/scsi/elx/libefc/efc_fabric.c
@@ -107,7 +107,6 @@ void
 efc_fabric_notify_topology(struct efc_node *node)
 {
 	struct efc_node *tmp_node;
-	enum efc_nport_topology topology = node->nport->topology;
 	unsigned long index;
 
 	/*
@@ -118,7 +117,7 @@ efc_fabric_notify_topology(struct efc_node *node)
 		if (tmp_node != node) {
 			efc_node_post_event(tmp_node,
 					    EFC_EVT_NPORT_TOPOLOGY_NOTIFY,
-					    (void *)topology);
+					    &node->nport->topology);
 		}
 	}
 }
-- 
2.33.0



