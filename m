Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E5A3D61C9
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhGZPdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhGZPam (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB4960EB2;
        Mon, 26 Jul 2021 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315871;
        bh=8E3Rc7rFUQ5OaxE3eMrTi5B4onEmxDLWmhyKSAIGx+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=docywLHDrc+ZEaU5Lc8WE5fQbzPRMEFcv3g/dDEcKGe1XExy2Ed1jCNyvb6IpIta7
         UJEUHBenGef1Bty+Em92koro01tzmTdxIokCKOtMnCk7VHnfmcQhD4MPFNK8x797xq
         INuzkyCTvroqWzUoDVZoiPqqVNKwMM2lt+V66W20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 098/223] scsi: iscsi: Fix iface sysfs attr detection
Date:   Mon, 26 Jul 2021 17:38:10 +0200
Message-Id: <20210726153849.468892895@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit e746f3451ec7f91dcc9fd67a631239c715850a34 ]

A ISCSI_IFACE_PARAM can have the same value as a ISCSI_NET_PARAM so when
iscsi_iface_attr_is_visible tries to figure out the type by just checking
the value, we can collide and return the wrong type. When we call into the
driver we might not match and return that we don't want attr visible in
sysfs. The patch fixes this by setting the type when we figure out what the
param is.

Link: https://lore.kernel.org/r/20210701002559.89533-1-michael.christie@oracle.com
Fixes: 3e0f65b34cc9 ("[SCSI] iscsi_transport: Additional parameters for network settings")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 90 +++++++++++------------------
 1 file changed, 34 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b07105ae7c91..d8b05d8b5470 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -439,39 +439,10 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
-	int param;
-	int param_type;
+	int param = -1;
 
 	if (attr == &dev_attr_iface_enabled.attr)
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_vlan_id.attr)
-		param = ISCSI_NET_PARAM_VLAN_ID;
-	else if (attr == &dev_attr_iface_vlan_priority.attr)
-		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
-	else if (attr == &dev_attr_iface_vlan_enabled.attr)
-		param = ISCSI_NET_PARAM_VLAN_ENABLED;
-	else if (attr == &dev_attr_iface_mtu.attr)
-		param = ISCSI_NET_PARAM_MTU;
-	else if (attr == &dev_attr_iface_port.attr)
-		param = ISCSI_NET_PARAM_PORT;
-	else if (attr == &dev_attr_iface_ipaddress_state.attr)
-		param = ISCSI_NET_PARAM_IPADDR_STATE;
-	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
-		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
-	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF;
-	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
-	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
-	else if (attr == &dev_attr_iface_cache_id.attr)
-		param = ISCSI_NET_PARAM_CACHE_ID;
-	else if (attr == &dev_attr_iface_redirect_en.attr)
-		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
@@ -508,6 +479,38 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN;
 	else if (attr == &dev_attr_iface_initiator_name.attr)
 		param = ISCSI_IFACE_PARAM_INITIATOR_NAME;
+
+	if (param != -1)
+		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
+
+	if (attr == &dev_attr_iface_vlan_id.attr)
+		param = ISCSI_NET_PARAM_VLAN_ID;
+	else if (attr == &dev_attr_iface_vlan_priority.attr)
+		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
+	else if (attr == &dev_attr_iface_vlan_enabled.attr)
+		param = ISCSI_NET_PARAM_VLAN_ENABLED;
+	else if (attr == &dev_attr_iface_mtu.attr)
+		param = ISCSI_NET_PARAM_MTU;
+	else if (attr == &dev_attr_iface_port.attr)
+		param = ISCSI_NET_PARAM_PORT;
+	else if (attr == &dev_attr_iface_ipaddress_state.attr)
+		param = ISCSI_NET_PARAM_IPADDR_STATE;
+	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
+		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
+	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF;
+	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_iface_cache_id.attr)
+		param = ISCSI_NET_PARAM_CACHE_ID;
+	else if (attr == &dev_attr_iface_redirect_en.attr)
+		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -598,32 +601,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		return 0;
 	}
 
-	switch (param) {
-	case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
-	case ISCSI_IFACE_PARAM_HDRDGST_EN:
-	case ISCSI_IFACE_PARAM_DATADGST_EN:
-	case ISCSI_IFACE_PARAM_IMM_DATA_EN:
-	case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
-	case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
-	case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
-	case ISCSI_IFACE_PARAM_ERL:
-	case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
-	case ISCSI_IFACE_PARAM_FIRST_BURST:
-	case ISCSI_IFACE_PARAM_MAX_R2T:
-	case ISCSI_IFACE_PARAM_MAX_BURST:
-	case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
-	case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
-	case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
-	case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
-	case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
-	case ISCSI_IFACE_PARAM_INITIATOR_NAME:
-		param_type = ISCSI_IFACE_PARAM;
-		break;
-	default:
-		param_type = ISCSI_NET_PARAM;
-	}
-
-	return t->attr_is_visible(param_type, param);
+	return t->attr_is_visible(ISCSI_NET_PARAM, param);
 }
 
 static struct attribute *iscsi_iface_attrs[] = {
-- 
2.30.2



