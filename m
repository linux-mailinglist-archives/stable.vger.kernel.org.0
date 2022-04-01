Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4F4EF24A
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352834AbiDAPIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350520AbiDAPAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4D5AEFB;
        Fri,  1 Apr 2022 07:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02B06B82504;
        Fri,  1 Apr 2022 14:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE5CC340F2;
        Fri,  1 Apr 2022 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824444;
        bh=0gOMWNOy9/oxZeinjzgUHCpJQMO4vsdQSSvDC4yWQbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcP2E1kMSSi0X2FOrav6BvzSXkKBEXpa0AY+X6dxTFibIPLf87Q+Qbeo26CLh9RKw
         2VBsPxrYVt5mRF9soWLnk8ENASlBwgrFeFZl15DpJ7c0TQKXww1l8tdo0ILB9CsM1x
         JKsR1xX2lOELcf5Wtxct9k/HnECyfxAw6LKG5FH1R+0KoX0ta8NE6akN7b2CqkWIdJ
         1DXRH3/g8Os182uzQ04i4PswIMFYCvxGNKs2ZvtkyFg40biFoGGwkZc+/A3uXvk7fJ
         QdiBGwy5PV/WQuyQT9RvbRcs5SMymzpDItT89q4j2DUDj/J93qyIKf2cm5D1bw45yf
         Ia0J2mFWcGxww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, mhiramat@kernel.org,
        rostedt@goodmis.org, ahalaney@redhat.com, vbabka@suse.cz,
        wangkefeng.wang@huawei.com, linux@rasmusvillemoes.dk,
        keescook@chromium.org, mark-pk.tsai@mediatek.com,
        valentin.schneider@arm.com, peterz@infradead.org
Subject: [PATCH AUTOSEL 4.19 28/29] init/main.c: return 1 from handled __setup() functions
Date:   Fri,  1 Apr 2022 10:46:11 -0400
Message-Id: <20220401144612.1955177-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7baad67c2e93..272ec131211c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -774,7 +774,7 @@ static int __init initcall_blacklist(char *str)
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -1027,7 +1027,9 @@ static noinline void __init kernel_init_freeable(void);
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
2.34.1

