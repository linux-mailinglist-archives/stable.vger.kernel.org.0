Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89353419AE9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhI0ROi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhI0RMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6838F60F70;
        Mon, 27 Sep 2021 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762519;
        bh=8wPVXSPkG6s7AN3bPPwaEgbJkvChjxgMYw4SfIaLlac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wkv/HIYh+HgEJ2O0F40ZOF1ejm4tCdGt2h8pV5Ci7lKToelriZaq03fTuk3aa9s+o
         +ghwpVmu6o3b4+o686FXXMzzqRPICBYu2Z2U+KHUSYZDUI3ysts2IKtfjFm9Tu6bCy
         IN7wkYshyaYPfQJnOFvS62eYFO5u+XKSHlrRgqp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Baokun Li <libaokun1@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/103] scsi: iscsi: Adjust iface sysfs attr detection
Date:   Mon, 27 Sep 2021 19:02:25 +0200
Message-Id: <20210927170227.596035099@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4e28550829258f7dab97383acaa477bd724c0ff4 ]

ISCSI_NET_PARAM_IFACE_ENABLE belongs to enum iscsi_net_param instead of
iscsi_iface_param so move it to ISCSI_NET_PARAM. Otherwise, when we call
into the driver, we might not match and return that we don't want attr
visible in sysfs. Found in code review.

Link: https://lore.kernel.org/r/20210901085336.2264295-1-libaokun1@huawei.com
Fixes: e746f3451ec7 ("scsi: iscsi: Fix iface sysfs attr detection")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ac07a9ef3578..41772b88610a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -442,9 +442,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct iscsi_transport *t = iface->transport;
 	int param = -1;
 
-	if (attr == &dev_attr_iface_enabled.attr)
-		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
+	if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
 		param = ISCSI_IFACE_PARAM_HDRDGST_EN;
@@ -484,7 +482,9 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	if (param != -1)
 		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
 
-	if (attr == &dev_attr_iface_vlan_id.attr)
+	if (attr == &dev_attr_iface_enabled.attr)
+		param = ISCSI_NET_PARAM_IFACE_ENABLE;
+	else if (attr == &dev_attr_iface_vlan_id.attr)
 		param = ISCSI_NET_PARAM_VLAN_ID;
 	else if (attr == &dev_attr_iface_vlan_priority.attr)
 		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
-- 
2.33.0



