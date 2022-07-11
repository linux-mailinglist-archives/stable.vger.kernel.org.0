Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0556FB39
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiGKJ1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiGKJZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190AC3C16B;
        Mon, 11 Jul 2022 02:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E72B61226;
        Mon, 11 Jul 2022 09:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB432C36AE2;
        Mon, 11 Jul 2022 09:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530922;
        bh=VPZKuoyCmG6wEttXmpKkWoqkMqKHAQupFqKBA0qKEA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOj5P1uzD/2dzj8ii78QzFVk37JHVaPjSjltRFwkgizPqVg4P+uYoPPs8/kEFV6W/
         TUMICy2xUhLbsT5C37azwGo0g5bZFCQIFhIWSXHV04KGpfVUfXM4VSG7bnl+2PMHyR
         j/q+eGs7KI0Zgy1C4bov/K8XQwB+F/oPtOrQIhwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 5.18 031/112] cxl/mbox: Use __le32 in get,set_lsa mailbox structures
Date:   Mon, 11 Jul 2022 11:06:31 +0200
Message-Id: <20220711090550.450548703@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

commit 8a66487506161dbc1d22fd154d2de0244e232040 upstream.

CXL specification defines these as little endian.

Fixes: 60b8f17215de ("cxl/pmem: Translate NVDIMM label commands to CXL label commands")
Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/r/20220225221456.1025635-1-alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/cxlmem.h |    8 ++++----
 drivers/cxl/pmem.c   |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -252,13 +252,13 @@ struct cxl_mbox_identify {
 } __packed;
 
 struct cxl_mbox_get_lsa {
-	u32 offset;
-	u32 length;
+	__le32 offset;
+	__le32 length;
 } __packed;
 
 struct cxl_mbox_set_lsa {
-	u32 offset;
-	u32 reserved;
+	__le32 offset;
+	__le32 reserved;
 	u8 data[];
 } __packed;
 
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -108,8 +108,8 @@ static int cxl_pmem_get_config_data(stru
 		return -EINVAL;
 
 	get_lsa = (struct cxl_mbox_get_lsa) {
-		.offset = cmd->in_offset,
-		.length = cmd->in_length,
+		.offset = cpu_to_le32(cmd->in_offset),
+		.length = cpu_to_le32(cmd->in_length),
 	};
 
 	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_LSA, &get_lsa,
@@ -139,7 +139,7 @@ static int cxl_pmem_set_config_data(stru
 		return -ENOMEM;
 
 	*set_lsa = (struct cxl_mbox_set_lsa) {
-		.offset = cmd->in_offset,
+		.offset = cpu_to_le32(cmd->in_offset),
 	};
 	memcpy(set_lsa->data, cmd->in_buf, cmd->in_length);
 


