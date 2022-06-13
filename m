Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD25497A3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiFMKcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346238AbiFMKaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562F42613D;
        Mon, 13 Jun 2022 03:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2076B80E95;
        Mon, 13 Jun 2022 10:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1168CC3411E;
        Mon, 13 Jun 2022 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115668;
        bh=qv2e8v9qxvapwMTs0CSTWcRl0c/ndwnLPccw4mOuQ6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4Z47WSXg98adBhpkNpqLWNEtHNeQhg00bIbnTQ7v4fu/I5Gndnr0IAodWiZ6ZvY5
         gWytNKoA6kxyWGbD93LpwmO9KxZ72AT+h3GeEyBlhswV/Z5s3Dk+8353nrcf1CoT2H
         /GVQKUtF5vlpff8DGIwvkARAxpn6Pksm+et0wXPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 155/167] modpost: fix undefined behavior of is_arm_mapping_symbol()
Date:   Mon, 13 Jun 2022 12:10:29 +0200
Message-Id: <20220613094917.233617508@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 29c3e4d6fc06..c5f3267aa08a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1212,7 +1212,8 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("axtd", str[1])
+	return str[0] == '$' &&
+	       (str[1] == 'a' || str[1] == 'd' || str[1] == 't' || str[1] == 'x')
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
-- 
2.35.1



