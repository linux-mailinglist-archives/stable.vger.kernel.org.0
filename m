Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45117549601
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346189AbiFMMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358038AbiFMMkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:40:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06745EBCD;
        Mon, 13 Jun 2022 04:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 126A9B80EB4;
        Mon, 13 Jun 2022 11:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F60C34114;
        Mon, 13 Jun 2022 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118615;
        bh=arevvUO6TDs1XZqB0gk0HZtXTixvkAi4HuNOxI5L6VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebJCvkoKtrnl36seW3952EUtZEUI4c4I/sw+ed+o+g69IVHm1oVsv70vrgjtdtgvs
         W5sg0kWHTXBvc99oF8h6/yo0nFXmzDBKCMV19SnQ7tS1DoiKYwzA97j2/ga/4MUQP4
         2Yu35CdKnGYPodnZkJ9mgpgKYxbxMaTwv6g6rtGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/172] modpost: fix undefined behavior of is_arm_mapping_symbol()
Date:   Mon, 13 Jun 2022 12:11:40 +0200
Message-Id: <20220613094921.956896824@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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
index a21aa74b4948..79aef50ede17 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1271,7 +1271,8 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("axtd", str[1])
+	return str[0] == '$' &&
+	       (str[1] == 'a' || str[1] == 'd' || str[1] == 't' || str[1] == 'x')
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
-- 
2.35.1



