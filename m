Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B865EA497
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbiIZLsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbiIZLqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9D956BB1;
        Mon, 26 Sep 2022 03:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A51F060B09;
        Mon, 26 Sep 2022 10:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A69C433D7;
        Mon, 26 Sep 2022 10:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189257;
        bh=IunPrrzid9QOnXr7JnjCZRuqeGfIwxmYQEzJi10qmdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W80HoYtYzzmBgRUUkilyblBJmsC2+KdX705+xJ2Twxy8nU02F1CaoADkm+cb+5N2J
         X2Dy1X58ANZoJssbyA7cVhPoQS4t7mS1tnbrTE76hbTEArW9o1jG7tTYngdcAIE4P8
         XITZGgcKS3ga8SfK+hg92LVsGIEX+s+4BOYtlKIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 125/207] net: ipa: properly limit modem routing table use
Date:   Mon, 26 Sep 2022 12:11:54 +0200
Message-Id: <20220926100812.151888224@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit cf412ec333250cb82bafe57169204e14a9f1c2ac ]

IPA can route packets between IPA-connected entities.  The AP and
modem are currently the only such entities supported, and no routing
is required to transfer packets between them.

The number of entries in each routing table is fixed, and defined at
initialization time.  Some of these entries are designated for use
by the modem, and the rest are available for the AP to use.  The AP
sends a QMI message to the modem which describes (among other
things) information about routing table memory available for the
modem to use.

Currently the QMI initialization packet gives wrong information in
its description of routing tables.  What *should* be supplied is the
maximum index that the modem can use for the routing table memory
located at a given location.  The current code instead supplies the
total *number* of routing table entries.  Furthermore, the modem is
granted the entire table, not just the subset it's supposed to use.

This patch fixes this.  First, the ipa_mem_bounds structure is
generalized so its "end" field can be interpreted either as a final
byte offset, or a final array index.  Second, the IPv4 and IPv6
(non-hashed and hashed) table information fields in the QMI
ipa_init_modem_driver_req structure are changed to be ipa_mem_bounds
rather than ipa_mem_array structures.  Third, we set the "end" value
for each routing table to be the last index, rather than setting the
"count" to be the number of indices.  Finally, instead of allowing
the modem to use all of a routing table's memory, it is limited to
just the portion meant to be used by the modem.  In all versions of
IPA currently supported, that is IPA_ROUTE_MODEM_COUNT (8) entries.

Update a few comments for clarity.

Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20220913204602.1803004-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_qmi.c     |  8 ++++----
 drivers/net/ipa/ipa_qmi_msg.c |  8 ++++----
 drivers/net/ipa/ipa_qmi_msg.h | 37 ++++++++++++++++++++---------------
 drivers/net/ipa/ipa_table.c   |  2 --
 drivers/net/ipa/ipa_table.h   |  3 +++
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index ec010cf2e816..6f874f99b910 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v4_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v6_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,7 +352,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v4_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
@@ -360,7 +360,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v6_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index 6838e8065072..75d3fc0092e9 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -311,7 +311,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x12,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v4_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -332,7 +332,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x13,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v6_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -496,7 +496,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x1b,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v4_hash_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -517,7 +517,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x1c,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v6_hash_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 495e85abe50b..9651aa59b596 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -86,9 +86,11 @@ enum ipa_platform_type {
 	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 0x5,	/* QNX MSM */
 };
 
-/* This defines the start and end offset of a range of memory.  Both
- * fields are offsets relative to the start of IPA shared memory.
- * The end value is the last addressable byte *within* the range.
+/* This defines the start and end offset of a range of memory.  The start
+ * value is a byte offset relative to the start of IPA shared memory.  The
+ * end value is the last addressable unit *within* the range.  Typically
+ * the end value is in units of bytes, however it can also be a maximum
+ * array index value.
  */
 struct ipa_mem_bounds {
 	u32 start;
@@ -129,18 +131,19 @@ struct ipa_init_modem_driver_req {
 	u8			hdr_tbl_info_valid;
 	struct ipa_mem_bounds	hdr_tbl_info;
 
-	/* Routing table information.  These define the location and size of
-	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of non-hashable IPv4 and
+	 * IPv6 routing tables.  The start values are byte offsets relative
+	 * to the start of IPA shared memory.
 	 */
 	u8			v4_route_tbl_info_valid;
-	struct ipa_mem_array	v4_route_tbl_info;
+	struct ipa_mem_bounds	v4_route_tbl_info;
 	u8			v6_route_tbl_info_valid;
-	struct ipa_mem_array	v6_route_tbl_info;
+	struct ipa_mem_bounds	v6_route_tbl_info;
 
 	/* Filter table information.  These define the location of the
 	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_filter_tbl_start_valid;
 	u32			v4_filter_tbl_start;
@@ -181,18 +184,20 @@ struct ipa_init_modem_driver_req {
 	u8			zip_tbl_info_valid;
 	struct ipa_mem_bounds	zip_tbl_info;
 
-	/* Routing table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of hashable IPv4 and IPv6
+	 * routing tables (if supported by hardware).  The start values are
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v4_hash_route_tbl_info;
+	struct ipa_mem_bounds	v4_hash_route_tbl_info;
 	u8			v6_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v6_hash_route_tbl_info;
+	struct ipa_mem_bounds	v6_hash_route_tbl_info;
 
 	/* Filter table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * of hashable IPv4 and IPv6 filter tables (if supported by hardware).
+	 * The start values are byte offsets relative to the start of IPA
+	 * shared memory.
 	 */
 	u8			v4_hash_filter_tbl_start_valid;
 	u32			v4_hash_filter_tbl_start;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 2f5a58bfc529..69efe672ca52 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -108,8 +108,6 @@
 
 /* Assignment of route table entries to the modem and AP */
 #define IPA_ROUTE_MODEM_MIN		0
-#define IPA_ROUTE_MODEM_COUNT		8
-
 #define IPA_ROUTE_AP_MIN		IPA_ROUTE_MODEM_COUNT
 #define IPA_ROUTE_AP_COUNT \
 		(IPA_ROUTE_COUNT_MAX - IPA_ROUTE_MODEM_COUNT)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index b6a9a0d79d68..1538e2e1732f 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -13,6 +13,9 @@ struct ipa;
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
+/* The number of route table entries allotted to the modem */
+#define IPA_ROUTE_MODEM_COUNT	8
+
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-- 
2.35.1



