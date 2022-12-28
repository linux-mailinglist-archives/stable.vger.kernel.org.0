Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFB658204
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiL1Qcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiL1QcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CE318B01
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1ECF6157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF79FC433D2;
        Wed, 28 Dec 2022 16:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244946;
        bh=5p6TI3kPoDHFbjPnSlmWdnvOS3eVSq8WPBH3ZjkpxTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qisDDIS0fNrVfngVqOpxOp6M2xuAK6W5IK460CRSDAg9sDyjLr7TVvYzgHUO/n9c6
         t8cN0/2Z/v35KNeUrIBUsz2fcXy1GGnRwzzTSsCyAP4kYcTnqRorgfKFZMGSgaKihv
         kZ/IQ9Fo7w4MZsuW0J3S8fKp8SaxqNsrA5s8zivI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nayna Jain <nayna@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0804/1073] powerpc/pseries: fix plpks_read_var() code for different consumers
Date:   Wed, 28 Dec 2022 15:39:52 +0100
Message-Id: <20221228144349.847685191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 1f622f3f80cbf8999ff5955a2fcfbd801a1f32e0 ]

Even though plpks_read_var() is currently called to read variables
owned by different consumers, it internally supports only OS consumer.

Fix plpks_read_var() to handle different consumers correctly.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-7-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 28 +++++++++++++++++---------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index cbea447122ca..63a1e1fe0185 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -366,22 +366,24 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE] = { 0 };
 	struct plpks_auth *auth;
-	struct label *label;
+	struct label *label = NULL;
 	u8 *output;
 	int rc;
 
 	if (var->namelen > MAX_NAME_SIZE)
 		return -EINVAL;
 
-	auth = construct_auth(PKS_OS_OWNER);
+	auth = construct_auth(consumer);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	label = construct_label(var->component, var->os, var->name,
-				var->namelen);
-	if (IS_ERR(label)) {
-		rc = PTR_ERR(label);
-		goto out_free_auth;
+	if (consumer == PKS_OS_OWNER) {
+		label = construct_label(var->component, var->os, var->name,
+					var->namelen);
+		if (IS_ERR(label)) {
+			rc = PTR_ERR(label);
+			goto out_free_auth;
+		}
 	}
 
 	output = kzalloc(maxobjsize, GFP_KERNEL);
@@ -390,9 +392,15 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 		goto out_free_label;
 	}
 
-	rc = plpar_hcall(H_PKS_READ_OBJECT, retbuf, virt_to_phys(auth),
-			 virt_to_phys(label), label->size, virt_to_phys(output),
-			 maxobjsize);
+	if (consumer == PKS_OS_OWNER)
+		rc = plpar_hcall(H_PKS_READ_OBJECT, retbuf, virt_to_phys(auth),
+				 virt_to_phys(label), label->size, virt_to_phys(output),
+				 maxobjsize);
+	else
+		rc = plpar_hcall(H_PKS_READ_OBJECT, retbuf, virt_to_phys(auth),
+				 virt_to_phys(var->name), var->namelen, virt_to_phys(output),
+				 maxobjsize);
+
 
 	if (rc != H_SUCCESS) {
 		pr_err("Failed to read variable %s for component %s with error %d\n",
-- 
2.35.1



