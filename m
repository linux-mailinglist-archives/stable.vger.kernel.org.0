Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA614EF4F4
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350670AbiDAPG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350065AbiDAO6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD98181B3A;
        Fri,  1 Apr 2022 07:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C6B7B82500;
        Fri,  1 Apr 2022 14:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A79C2BBE4;
        Fri,  1 Apr 2022 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824368;
        bh=Uq8IKRYb1CKI8oteRhFM1NknKrwKvla0xctmkVgqtB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQElCcmGyWAl/Z/VCCJs9cL+zzHa1sMjV4cepY0s9pwFNR0mSR7vKZUfkY8zlaaQQ
         v9LIEJEmlwK5Fp6x9VQpTSYPU++bsQiFaasDGHrJxfr8JniMsRL7oM8pRnF7vM2L1X
         pxorw/G1Fjf8LWYuSDEvvd4wwI6Xqz6B4frUxZzDToGDIgPgUMUwPTuVh9aMDFr+e1
         5JHeSPjyVciPwxNhhD9ekJgk0jinb1cWqxJlVCN0V/0znrzYgA6bVryDVFerkR+8sK
         m3res4cTG/ovV1Hz3fUB9oQxC0xWWWNXL/32luhMyl3F525lkBJrbK5/QkY+svdAMH
         7Lr3+MBzd93eQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mhiramat@kernel.org, ahalaney@redhat.com, vbabka@suse.cz,
        wangkefeng.wang@huawei.com, linux@rasmusvillemoes.dk,
        keescook@chromium.org, mark-pk.tsai@mediatek.com,
        peterz@infradead.org, valentin.schneider@arm.com
Subject: [PATCH AUTOSEL 5.4 36/37] init/main.c: return 1 from handled __setup() functions
Date:   Fri,  1 Apr 2022 10:44:45 -0400
Message-Id: <20220401144446.1954694-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
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
index e6a1fb14f308..d292daabd9a2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -831,7 +831,7 @@ static int __init initcall_blacklist(char *str)
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -1072,7 +1072,9 @@ static noinline void __init kernel_init_freeable(void);
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

