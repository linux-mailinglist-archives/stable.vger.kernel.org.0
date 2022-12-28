Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C166582EA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiL1QnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbiL1Qmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C3D193C3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03EA16157C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14532C433D2;
        Wed, 28 Dec 2022 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245409;
        bh=5p6TI3kPoDHFbjPnSlmWdnvOS3eVSq8WPBH3ZjkpxTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMWkLtQswW25Jn4DouSD9Y0qwGZR7JGD5d8DCx3L7VCB/hrnpUPVVccFHE9If7jaT
         gwI9anGP/ZJObRivjFkgwjzluDrp4Dt1BIbaJSe9QIm4xnCxOXg0wQ3aDfXykEd1MP
         Le2j45j/A4KpVxjal9Ny8bnJkX/Ah23R+7Wy8CHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nayna Jain <nayna@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0854/1146] powerpc/pseries: fix plpks_read_var() code for different consumers
Date:   Wed, 28 Dec 2022 15:39:53 +0100
Message-Id: <20221228144353.351974528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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



