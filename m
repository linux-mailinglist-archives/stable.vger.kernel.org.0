Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92813961D8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhEaOrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234235AbhEaOpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E072D61C85;
        Mon, 31 May 2021 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469305;
        bh=AIb1ypQvJEXd7UNZ+e+2vszULBi7y+iz7/mtflgTJWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA1plq2my7e6pmjf3Z56Y2bh8mMpWRwfEUE72HYjpwuYZ5wz1f6WDvs0MBcyJkdAd
         AhjIuBnXJyYCSQ7dhux81qABPky/xQ2kOyN6so9wttrUUHhcLeWirmilSRdpxMIDC1
         tPOqj9GxJMq/E0PbEVgRarQiDELQupekr/0ntNm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 148/296] net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S
Date:   Mon, 31 May 2021 15:13:23 +0200
Message-Id: <20210531130708.844653601@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit ba61cf167cb77e54c1ec5adb7aa49a22ab3c9b28 upstream.

At the beginning of the sja1105_dynamic_config.c file there is a diagram
of the dynamic config interface layout:

 packed_buf

 |
 V
 +-----------------------------------------+------------------+
 |              ENTRY BUFFER               |  COMMAND BUFFER  |
 +-----------------------------------------+------------------+

 <----------------------- packed_size ------------------------>

So in order to pack/unpack the command bits into the buffer,
sja1105_vl_lookup_cmd_packing must first advance the buffer pointer by
the length of the entry. This is similar to what the other *cmd_packing
functions do.

This bug exists because the command packing function for P/Q/R/S was
copied from the E/T generation, and on E/T, the command was actually
embedded within the entry buffer itself.

Fixes: 94f94d4acfb2 ("net: dsa: sja1105: add static tables for virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -167,9 +167,10 @@ enum sja1105_hostcmd {
 	SJA1105_HOSTCMD_INVALIDATE = 4,
 };
 
+/* Command and entry overlap */
 static void
-sja1105_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
-			      enum packing_op op)
+sja1105et_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				enum packing_op op)
 {
 	const int size = SJA1105_SIZE_DYN_CMD;
 
@@ -179,6 +180,20 @@ sja1105_vl_lookup_cmd_packing(void *buf,
 	sja1105_packing(buf, &cmd->index,    9,  0, size, op);
 }
 
+/* Command and entry are separate */
+static void
+sja1105pqrs_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				  enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_VL_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->errors,  30, 30, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    9,  0, size, op);
+}
+
 static size_t sja1105et_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
@@ -641,7 +656,7 @@ static size_t sja1105pqrs_cbs_entry_pack
 const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105et_vl_lookup_entry_packing,
-		.cmd_packing = sja1105_vl_lookup_cmd_packing,
+		.cmd_packing = sja1105et_vl_lookup_cmd_packing,
 		.access = OP_WRITE,
 		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
 		.packed_size = SJA1105ET_SIZE_VL_LOOKUP_DYN_CMD,
@@ -725,7 +740,7 @@ const struct sja1105_dynamic_table_ops s
 const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105_vl_lookup_entry_packing,
-		.cmd_packing = sja1105_vl_lookup_cmd_packing,
+		.cmd_packing = sja1105pqrs_vl_lookup_cmd_packing,
 		.access = (OP_READ | OP_WRITE),
 		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
 		.packed_size = SJA1105PQRS_SIZE_VL_LOOKUP_DYN_CMD,


