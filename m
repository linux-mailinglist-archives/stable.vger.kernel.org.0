Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89C66C578
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjAPQGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjAPQGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D6423C6E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF3A4B81076
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40629C433D2;
        Mon, 16 Jan 2023 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885060;
        bh=zT/8qlT9FyzFgYWpv5pEOB/i56YQUsR38/sScnLD/H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/WI0yBZd3p1EUPuGs7fpqQNoDnljajxulsqVWOnbkn2UHAtXBo689c31vwq+21TM
         qK8KRVuLOv79aQ80W+3WqmrFvwFgIYc/DN3MpkMf8R0AYWdwfFZMTo8sU9Rs24hpun
         NSK9XV0du9+EkOfQsNjOO0CsZxQOEhZJlIsCf8uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 58/86] tools/nolibc: x86-64: Use `mov $60,%eax` instead of `mov $60,%rax`
Date:   Mon, 16 Jan 2023 16:51:32 +0100
Message-Id: <20230116154749.464183328@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Ammar Faizi <ammar.faizi@students.amikom.ac.id>

[ Upstream commit 7bdc0e7a390511cd3df8194003b908f15a6170a5 ]

Note that mov to 32-bit register will zero extend to 64-bit register.
Thus `mov $60,%eax` has the same effect with `mov $60,%rax`. Use the
shorter opcode to achieve the same thing.
```
  b8 3c 00 00 00       	mov    $60,%eax (5 bytes) [1]
  48 c7 c0 3c 00 00 00 	mov    $60,%rax (7 bytes) [2]
```
Currently, we use [2]. Change it to [1] for shorter code.

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/nolibc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index ece7a70d8b39..676fe5d92875 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -420,7 +420,7 @@ asm(".section .text\n"
     "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
     "call main\n"               // main() returns the status code, we'll exit with it.
     "mov %eax, %edi\n"          // retrieve exit code (32 bit)
-    "mov $60, %rax\n"           // NR_exit == 60
+    "mov $60, %eax\n"           // NR_exit == 60
     "syscall\n"                 // really exit
     "hlt\n"                     // ensure it does not return
     "");
-- 
2.35.1



