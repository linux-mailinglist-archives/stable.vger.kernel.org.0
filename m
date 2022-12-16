Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DE864EBB2
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiLPM5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiLPM53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:57:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A05C5214F;
        Fri, 16 Dec 2022 04:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07543620C5;
        Fri, 16 Dec 2022 12:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157C4C433D2;
        Fri, 16 Dec 2022 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195447;
        bh=csW2W9SFxaOE8F0yKYno6HgtlBrAHGYlpIAGGRUS0rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do4K45e88kXpFfBbgyij+n5Z70ag12kVRCZYFCeinIGWth/qp03EChTZH3oVdbyBs
         QYK7QfrBwDe6HNfsLf0XckLwpLCiSYlDopT1qmsPkIlwqDMhNuSlMrgqO94AhUEvpX
         W3BXZxzSrtuJm0pPbkQJmoq9a4RyHO+6yrpKAYLZDBWDbgV9WmAkLDNFbsbaFcvLxI
         QsJx6RehMneWEIA7JJ9QqsrXklC9+JhZYneJrrtv+IGRqW3M9ezmSjiyMpPrdAmgQ/
         x0918YlvCJDUgKdKd4MNegHgmdkm6bxKrZjW1tiWpjJ/s6FJ4Yr7WTFB8vBM9jrUPB
         +W4pGfHx5jauw==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 6/8] selftests/bpf: Add bpf_testmod_fentry_* functions
Date:   Fri, 16 Dec 2022 13:56:26 +0100
Message-Id: <20221216125628.1622505-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216125628.1622505-1-jolsa@kernel.org>
References: <20221216125628.1622505-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fee356ede980b6c2c8db612e18b25738356d6744 upstream.

Adding 3 bpf_testmod_fentry_* functions to have a way to test
kprobe multi link on kernel module. They follow bpf_fentry_test*
functions prototypes/code.

Adding equivalent functions to all bpf_fentry_test* does not
seems necessary at the moment, could be added later.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-7-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 792cb15bac40..ac5d7c1396fb 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -88,6 +88,23 @@ __weak noinline struct file *bpf_testmod_return_ptr(int arg)
 	}
 }
 
+noinline int bpf_testmod_fentry_test1(int a)
+{
+	return a + 1;
+}
+
+noinline int bpf_testmod_fentry_test2(int a, u64 b)
+{
+	return a + b;
+}
+
+noinline int bpf_testmod_fentry_test3(char a, int b, u64 c)
+{
+	return a + b + c;
+}
+
+int bpf_testmod_fentry_ok;
+
 noinline ssize_t
 bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		      struct bin_attribute *bin_attr,
@@ -119,6 +136,13 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 			return snprintf(buf, len, "%d\n", writable.val);
 	}
 
+	if (bpf_testmod_fentry_test1(1) != 2 ||
+	    bpf_testmod_fentry_test2(2, 3) != 5 ||
+	    bpf_testmod_fentry_test3(4, 5, 6) != 15)
+		goto out;
+
+	bpf_testmod_fentry_ok = 1;
+out:
 	return -EIO; /* always fail */
 }
 EXPORT_SYMBOL(bpf_testmod_test_read);
-- 
2.38.1

