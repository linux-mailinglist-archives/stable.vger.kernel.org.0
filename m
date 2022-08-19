Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF7359A21D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353004AbiHSQcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353045AbiHSQa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F61C11CF02;
        Fri, 19 Aug 2022 09:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BBEB614DA;
        Fri, 19 Aug 2022 16:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763C9C433D7;
        Fri, 19 Aug 2022 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925087;
        bh=r70nKsL/8zfp2nKwdnuul6ARJ8xpvktdkih8ho7I+ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKRbuvJHCX8fPMWF2+tlYsQU/540W2g5PF41r6Ysg9g7EAfOC2ouzIxHZsIk1tnLe
         zqMx+IAvE5aex36d7xgHkQ+Tj5wmiF1W07oZWP5q24t3WQJ2j5npPLEiFaC1tPUgs1
         NSxtgSHC9cPZPhoKG9NxXzkeNpndxjL8Pvp+xXI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/545] RDMA/srpt: Duplicate port name members
Date:   Fri, 19 Aug 2022 17:42:00 +0200
Message-Id: <20220819153845.046738423@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b03b1ae2a3125d4475452e4f19f5d3a6e910ff6e ]

Prepare for decoupling the lifetimes of struct srpt_port and struct
srpt_port_id by duplicating the port name into struct srpt_port.

Link: https://lore.kernel.org/r/20220727193415.1583860-2-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |  9 ++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 10 +++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 07ecc7dc1822..4cecdcee606a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -566,14 +566,17 @@ static int srpt_refresh_port(struct srpt_port *sport)
 		return ret;
 
 	sport->port_guid_id.wwn.priv = sport;
-	srpt_format_guid(sport->port_guid_id.name,
-			 sizeof(sport->port_guid_id.name),
+	srpt_format_guid(sport->guid_name, ARRAY_SIZE(sport->guid_name),
 			 &sport->gid.global.interface_id);
+	memcpy(sport->port_guid_id.name, sport->guid_name,
+	       ARRAY_SIZE(sport->guid_name));
 	sport->port_gid_id.wwn.priv = sport;
-	snprintf(sport->port_gid_id.name, sizeof(sport->port_gid_id.name),
+	snprintf(sport->gid_name, ARRAY_SIZE(sport->gid_name),
 		 "0x%016llx%016llx",
 		 be64_to_cpu(sport->gid.global.subnet_prefix),
 		 be64_to_cpu(sport->gid.global.interface_id));
+	memcpy(sport->port_gid_id.name, sport->gid_name,
+	       ARRAY_SIZE(sport->gid_name));
 
 	if (rdma_protocol_iwarp(sport->sdev->device, sport->port))
 		return 0;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index bdeb010efee6..1d28f13196c9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -376,7 +376,7 @@ struct srpt_tpg {
 };
 
 /**
- * struct srpt_port_id - information about an RDMA port name
+ * struct srpt_port_id - LIO RDMA port information
  * @mutex:	Protects @tpg_list changes.
  * @tpg_list:	TPGs associated with the RDMA port name.
  * @wwn:	WWN associated with the RDMA port name.
@@ -402,8 +402,10 @@ struct srpt_port_id {
  * @lid:       cached value of the port's lid.
  * @gid:       cached value of the port's gid.
  * @work:      work structure for refreshing the aforementioned cached values.
- * @port_guid_id: target port GUID
- * @port_gid_id: target port GID
+ * @guid_name: port name in GUID format.
+ * @port_guid_id: LIO target port information for the port name in GUID format.
+ * @gid_name:  port name in GID format.
+ * @port_gid_id: LIO target port information for the port name in GID format.
  * @port_attrib:   Port attributes that can be accessed through configfs.
  * @refcount:	   Number of objects associated with this port.
  * @freed_channels: Completion that will be signaled once @refcount becomes 0.
@@ -419,7 +421,9 @@ struct srpt_port {
 	u32			lid;
 	union ib_gid		gid;
 	struct work_struct	work;
+	char			guid_name[64];
 	struct srpt_port_id	port_guid_id;
+	char			gid_name[64];
 	struct srpt_port_id	port_gid_id;
 	struct srpt_port_attrib port_attrib;
 	atomic_t		refcount;
-- 
2.35.1



