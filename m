Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DB550568A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbiDRNjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244228AbiDRNjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:39:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD302E092;
        Mon, 18 Apr 2022 05:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4440AB80E44;
        Mon, 18 Apr 2022 12:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CB2C385A1;
        Mon, 18 Apr 2022 12:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286728;
        bh=n2/APxxVu8SnrvgFyt22ReHAqukgxGf2AMpAYMKm5Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxGv3QM4jV4F53/ZgJZ4S2p5EnY/EEEyfc5/2yCd4irp9zDx/rPxobgIHEZs5qybL
         as06ppvw8AS0p3F7rr5eOgGPQgrRP09VgbIHht4Ds8KGZ2brlTX650twzbhWYJmvsU
         OuZaS8+fxXv2WzL8VAPaXpFVzvy/DEEaD35Vz0bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 227/284] init/main.c: return 1 from handled __setup() functions
Date:   Mon, 18 Apr 2022 14:13:28 +0200
Message-Id: <20220418121218.166038374@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
index f0b2411a5fbf..621cedd9173a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -749,7 +749,7 @@ static int __init initcall_blacklist(char *str)
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -965,7 +965,9 @@ static noinline void __init kernel_init_freeable(void);
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



