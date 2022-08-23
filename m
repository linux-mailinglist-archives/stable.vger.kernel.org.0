Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C239F59D788
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348468AbiHWJM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348541AbiHWJKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:10:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3322A86B50;
        Tue, 23 Aug 2022 01:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A2461360;
        Tue, 23 Aug 2022 08:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA772C433D6;
        Tue, 23 Aug 2022 08:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243370;
        bh=1BYEHRjVREcdMBhA1wsIgbziwPW+7xcj9xwgN5GfgxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yh2VrytR7Rzph++QiFko1yOytd48rk6zxHoA2xATrelJZ4qg/ARrFsXEHSPym9PVX
         tcVdBd5UUH8G57DPRpYgvMTAKWoePrxBuFlbBkoDNZ92EFA/IMrSE2oUj6AEtsINKD
         yOCAxjcLdSsJhBr/Hgv2YcJbJeSrpfk3mJlnjEP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 255/365] x86/ibt, objtool: Add IBT_NOSEAL()
Date:   Tue, 23 Aug 2022 10:02:36 +0200
Message-Id: <20220823080128.867380224@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e27e5bea956ce4d3eb15112de5fa5a3b77c2f488 ]

Add a macro which prevents a function from getting sealed if there are
no compile-time references to it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Message-Id: <20220818213927.e44fmxkoq4yj6ybn@treble>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ibt.h | 11 +++++++++++
 tools/objtool/check.c      |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
index 689880eca9ba..9b08082a5d9f 100644
--- a/arch/x86/include/asm/ibt.h
+++ b/arch/x86/include/asm/ibt.h
@@ -31,6 +31,16 @@
 
 #define __noendbr	__attribute__((nocf_check))
 
+/*
+ * Create a dummy function pointer reference to prevent objtool from marking
+ * the function as needing to be "sealed" (i.e. ENDBR converted to NOP by
+ * apply_ibt_endbr()).
+ */
+#define IBT_NOSEAL(fname)				\
+	".pushsection .discard.ibt_endbr_noseal\n\t"	\
+	_ASM_PTR fname "\n\t"				\
+	".popsection\n\t"
+
 static inline __attribute_const__ u32 gen_endbr(void)
 {
 	u32 endbr;
@@ -84,6 +94,7 @@ extern __noendbr void ibt_restore(u64 save);
 #ifndef __ASSEMBLY__
 
 #define ASM_ENDBR
+#define IBT_NOSEAL(name)
 
 #define __noendbr
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b341f8a8c7c5..31c719f99f66 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4096,7 +4096,8 @@ static int validate_ibt(struct objtool_file *file)
 		 * These sections can reference text addresses, but not with
 		 * the intent to indirect branch to them.
 		 */
-		if (!strncmp(sec->name, ".discard", 8)			||
+		if ((!strncmp(sec->name, ".discard", 8) &&
+		     strcmp(sec->name, ".discard.ibt_endbr_noseal"))	||
 		    !strncmp(sec->name, ".debug", 6)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
-- 
2.35.1



