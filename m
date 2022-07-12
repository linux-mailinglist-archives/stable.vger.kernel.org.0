Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CF65722FC
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiGLSl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiGLSlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55277D516D;
        Tue, 12 Jul 2022 11:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7B0CB81BAC;
        Tue, 12 Jul 2022 18:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03545C3411C;
        Tue, 12 Jul 2022 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651245;
        bh=BG/lLgX4NwTF3EnPyMMuoXxPZhMhojq+mHhCZtZ5XxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxFvlgyuG5ZT2zfa1q9/JSRhIQNw/cbXC9Vx7kP6YyFYmp3qc9jiCVTiyKiyWMJeC
         cG7BvVlYCyYkFB3A4SYWOqkrWdDOLp1hXmTGHFfOUt2qTFe4sMg61IEjHy1xp3xf/v
         9LThRrG1GSG2OjovBWJAIkzrvwmKoe1q6QDh5qf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 018/130] x86/insn-eval: Handle return values from the decoder
Date:   Tue, 12 Jul 2022 20:37:44 +0200
Message-Id: <20220712183247.241740660@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit 6e8c83d2a3afbfd5ee019ec720b75a42df515caa upstream.

Now that the different instruction-inspecting functions return a value,
test that and return early from callers if error has been encountered.

While at it, do not call insn_get_modrm() when calling
insn_get_displacement() because latter will make sure to call
insn_get_modrm() if ModRM hasn't been parsed yet.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210304174237.31945-6-bp@alien8.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/insn-eval.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -928,10 +928,11 @@ static int get_seg_base_limit(struct ins
 static int get_eff_addr_reg(struct insn *insn, struct pt_regs *regs,
 			    int *regoff, long *eff_addr)
 {
-	insn_get_modrm(insn);
+	int ret;
 
-	if (!insn->modrm.nbytes)
-		return -EINVAL;
+	ret = insn_get_modrm(insn);
+	if (ret)
+		return ret;
 
 	if (X86_MODRM_MOD(insn->modrm.value) != 3)
 		return -EINVAL;
@@ -977,14 +978,14 @@ static int get_eff_addr_modrm(struct ins
 			      int *regoff, long *eff_addr)
 {
 	long tmp;
+	int ret;
 
 	if (insn->addr_bytes != 8 && insn->addr_bytes != 4)
 		return -EINVAL;
 
-	insn_get_modrm(insn);
-
-	if (!insn->modrm.nbytes)
-		return -EINVAL;
+	ret = insn_get_modrm(insn);
+	if (ret)
+		return ret;
 
 	if (X86_MODRM_MOD(insn->modrm.value) > 2)
 		return -EINVAL;
@@ -1106,18 +1107,21 @@ static int get_eff_addr_modrm_16(struct
  * @base_offset will have a register, as an offset from the base of pt_regs,
  * that can be used to resolve the associated segment.
  *
- * -EINVAL on error.
+ * Negative value on error.
  */
 static int get_eff_addr_sib(struct insn *insn, struct pt_regs *regs,
 			    int *base_offset, long *eff_addr)
 {
 	long base, indx;
 	int indx_offset;
+	int ret;
 
 	if (insn->addr_bytes != 8 && insn->addr_bytes != 4)
 		return -EINVAL;
 
-	insn_get_modrm(insn);
+	ret = insn_get_modrm(insn);
+	if (ret)
+		return ret;
 
 	if (!insn->modrm.nbytes)
 		return -EINVAL;
@@ -1125,7 +1129,9 @@ static int get_eff_addr_sib(struct insn
 	if (X86_MODRM_MOD(insn->modrm.value) > 2)
 		return -EINVAL;
 
-	insn_get_sib(insn);
+	ret = insn_get_sib(insn);
+	if (ret)
+		return ret;
 
 	if (!insn->sib.nbytes)
 		return -EINVAL;
@@ -1194,8 +1200,8 @@ static void __user *get_addr_ref_16(stru
 	short eff_addr;
 	long tmp;
 
-	insn_get_modrm(insn);
-	insn_get_displacement(insn);
+	if (insn_get_displacement(insn))
+		goto out;
 
 	if (insn->addr_bytes != 2)
 		goto out;
@@ -1529,7 +1535,9 @@ bool insn_decode_from_regs(struct insn *
 	insn->addr_bytes = INSN_CODE_SEG_ADDR_SZ(seg_defs);
 	insn->opnd_bytes = INSN_CODE_SEG_OPND_SZ(seg_defs);
 
-	insn_get_length(insn);
+	if (insn_get_length(insn))
+		return false;
+
 	if (buf_size < insn->length)
 		return false;
 


