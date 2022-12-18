Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF976500C1
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiLRQSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiLRQRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB6EBC9E;
        Sun, 18 Dec 2022 08:07:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B2BD60DDA;
        Sun, 18 Dec 2022 16:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2CC433D2;
        Sun, 18 Dec 2022 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379634;
        bh=X9QyHZW0/Q7y1ozPfSbuoElW40mP7FohwywJd74HR88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdH0uq3j0C0cpRh74GkE+EwCScOWgROiggG6zRwq59adWD7HMRAK161j/YjWgNFGz
         4SkpXyOg0KbOmrcrZiZYLmzcdMlL9ijqP5bnlq++Xu7XzbNAW4bTv97SlJ11ikRvOy
         5/EyGuSZST0EQrZ+1o73MgcaGtNCzaJUozOLKNtBP8MGsuOpM1NsQ2ZUPpRqFCsUtz
         6AFbfTKrVdrAhNa8Mw1StD0Iq2oEk091UCBn+Nqr77YuhkB7bIverfgfzWyWN3gw3p
         JxL+dgwJaQY3nyyMXLQy6CtTo6J2Y1AaTHEjk0s3wy4owqcUZDuUMTzooV/A3KJ1dE
         dT6sgBvtv0G0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        shuah@kernel.org, alan.maguire@oracle.com, yhs@fb.com,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 73/85] selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym
Date:   Sun, 18 Dec 2022 11:01:30 -0500
Message-Id: <20221218160142.925394-73-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit ab0350c743d5c93fd88742f02b3dff12168ab435 ]

Both tolower and toupper are built in c functions, we should not
redefine them as this can result in a build error.

Fixes the following errors:
progs/bpf_iter_ksym.c:10:20: error: conflicting types for built-in function 'tolower'; expected 'int(int)' [-Werror=builtin-declaration-mismatch]
   10 | static inline char tolower(char c)
      |                    ^~~~~~~
progs/bpf_iter_ksym.c:5:1: note: 'tolower' is declared in header '<ctype.h>'
    4 | #include <bpf/bpf_helpers.h>
  +++ |+#include <ctype.h>
    5 |
progs/bpf_iter_ksym.c:17:20: error: conflicting types for built-in function 'toupper'; expected 'int(int)' [-Werror=builtin-declaration-mismatch]
   17 | static inline char toupper(char c)
      |                    ^~~~~~~
progs/bpf_iter_ksym.c:17:20: note: 'toupper' is declared in header '<ctype.h>'

See background on this sort of issue:
https://stackoverflow.com/a/20582607
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=12213

(C99, 7.1.3p1) "All identifiers with external linkage in any of the
following subclauses (including the future library directions) are
always reserved for use as identifiers with external linkage."

This is documented behavior in GCC:
https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html#index-std-2

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221203010847.2191265-1-james.hilliard1@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c b/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
index 285c008cbf9c..9ba14c37bbcc 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
@@ -7,14 +7,14 @@ char _license[] SEC("license") = "GPL";
 
 unsigned long last_sym_value = 0;
 
-static inline char tolower(char c)
+static inline char to_lower(char c)
 {
 	if (c >= 'A' && c <= 'Z')
 		c += ('a' - 'A');
 	return c;
 }
 
-static inline char toupper(char c)
+static inline char to_upper(char c)
 {
 	if (c >= 'a' && c <= 'z')
 		c -= ('a' - 'A');
@@ -54,7 +54,7 @@ int dump_ksym(struct bpf_iter__ksym *ctx)
 	type = iter->type;
 
 	if (iter->module_name[0]) {
-		type = iter->exported ? toupper(type) : tolower(type);
+		type = iter->exported ? to_upper(type) : to_lower(type);
 		BPF_SEQ_PRINTF(seq, "0x%llx %c %s [ %s ] ",
 			       value, type, iter->name, iter->module_name);
 	} else {
-- 
2.35.1

