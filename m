Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F3A540CA4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbiFGSi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350954AbiFGSiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABADE183176;
        Tue,  7 Jun 2022 10:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC5D618CD;
        Tue,  7 Jun 2022 17:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AD4C34119;
        Tue,  7 Jun 2022 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624686;
        bh=x/szn956biCs8rxJSg0OvhcdbZVlNR2quQLfZYpdRmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5wYCbdjCPny6uXfzd6JPGSyCcRTPLypEqLiuRlZOwL1LjvY708JLPK1SFL1Ix7SV
         Bi+F3oVQu3clYShdRudzYXS4MBdzwpZitkmDKYewgUJurQJDyNEqaPPkVADLO6cqB7
         05mCSJmGGAHq3W3gTlRUCyM45KUN0k0k2dW2r5LbQbvI3KuUHZzVWdH+n455h93Uel
         1ViiBXa/VL6y8y3V1yUmuqS0W4uyHTlcnHjCGULpr5H92CU1dblM+hVwgPKS8+LHjB
         +hTLvkW8qgX3Xxvjw1PADgmjb/hNRAriYfDJaqekjKqhH+J5Dg7vM3wIhrXy8qr/37
         3Fhj4F+YkblsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>, michal.lkml@markovi.net,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 41/51] modpost: fix undefined behavior of is_arm_mapping_symbol()
Date:   Tue,  7 Jun 2022 13:55:40 -0400
Message-Id: <20220607175552.479948-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit d6b732666a1bae0df3c3ae06925043bba34502b1 ]

The return value of is_arm_mapping_symbol() is unpredictable when "$"
is passed in.

strchr(3) says:
  The strchr() and strrchr() functions return a pointer to the matched
  character or NULL if the character is not found. The terminating null
  byte is considered part of the string, so that if c is specified as
  '\0', these functions return a pointer to the terminator.

When str[1] is '\0', strchr("axtd", str[1]) is not NULL, and str[2] is
referenced (i.e. buffer overrun).

Test code
---------

  char str1[] = "abc";
  char str2[] = "ab";

  strcpy(str1, "$");
  strcpy(str2, "$");

  printf("test1: %d\n", is_arm_mapping_symbol(str1));
  printf("test2: %d\n", is_arm_mapping_symbol(str2));

Result
------

  test1: 0
  test2: 1

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ca491aa2b376..78c67fee33cb 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1260,7 +1260,8 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("axtd", str[1])
+	return str[0] == '$' &&
+	       (str[1] == 'a' || str[1] == 'd' || str[1] == 't' || str[1] == 'x')
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
-- 
2.35.1

