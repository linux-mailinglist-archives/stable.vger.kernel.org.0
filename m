Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089E04FD3E6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352260AbiDLH2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354374AbiDLHRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:17:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28234AE04;
        Mon, 11 Apr 2022 23:59:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E0B5B81B4F;
        Tue, 12 Apr 2022 06:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60BDC385A8;
        Tue, 12 Apr 2022 06:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746742;
        bh=0o03kzCxA2FzdbHm9jf0Ja7nQwzJQdUEsHNBzdG6oH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKQxo9GIifWr8qU6363DHHVUnWGELQJHxOiD5TwS5vsTfxCwSRceMlR8Bb01+4Edf
         7Pm8dW7Oke+sB49cBadN0lfuVu6Qr01idKP45fP1gcMO+ajyp8Nk6BXqbvE+khS/ML
         ZwzVIKtEoZMjhEAAp9PuT1KujAYuZ9mNWj8Wln1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 112/285] init/main.c: return 1 from handled __setup() functions
Date:   Tue, 12 Apr 2022 08:29:29 +0200
Message-Id: <20220412062946.898927011@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f9a40b0890658330c83c95511f9d6b396610defc ]

initcall_blacklist() should return 1 to indicate that it handled its
cmdline arguments.

set_debug_rodata() should return 1 to indicate that it handled its
cmdline arguments.  Print a warning if the option string is invalid.

This prevents these strings from being added to the 'init' program's
environment as they are not init arguments/parameters.

Link: https://lkml.kernel.org/r/20220221050901.23985-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index cb68bc48a682..792a8d9cc560 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1189,7 +1189,7 @@ static int __init initcall_blacklist(char *str)
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -1451,7 +1451,9 @@ static noinline void __init kernel_init_freeable(void);
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
-	return strtobool(str, &rodata_enabled);
+	if (strtobool(str, &rodata_enabled))
+		pr_warn("Invalid option string for rodata: '%s'\n", str);
+	return 1;
 }
 __setup("rodata=", set_debug_rodata);
 #endif
-- 
2.35.1



