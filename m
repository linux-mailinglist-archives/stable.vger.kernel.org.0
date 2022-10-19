Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C362604139
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiJSKkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiJSKjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:39:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D8E15745E;
        Wed, 19 Oct 2022 03:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 354FAB823B2;
        Wed, 19 Oct 2022 08:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81200C433C1;
        Wed, 19 Oct 2022 08:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169549;
        bh=LoFmpQ3886X+NWnu6AizYWHdAbOt4zyiwxpdLya/P7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3ddpY/wQ+mwcN54Lvk0gfa+CEaQu6qV2pokV8j1sRAfVDa9n1Ey3oBeD8k96tOHI
         /kGeqAG54j6LOqtPGGfc5oVyTKfEn8qsWjJl8cbQzpwg5J4n/WzF3CSB9ogw+uTNNo
         RRy2UAom/LwwgZOzCwXqcnthdC2CPYIgOLQGhl+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 319/862] libbpf: Dont require full struct enum64 in UAPI headers
Date:   Wed, 19 Oct 2022 10:26:46 +0200
Message-Id: <20221019083304.107157180@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 87dbdc230d162bf9ee1ac77c8ade178b6b1e199e ]

Drop the requirement for system-wide kernel UAPI headers to provide full
struct btf_enum64 definition. This is an unexpected requirement that
slipped in libbpf 1.0 and put unnecessary pressure ([0]) on users to have
a bleeding-edge kernel UAPI header from unreleased Linux 6.0.

To achieve this, we forward declare struct btf_enum64. But that's not
enough as there is btf_enum64_value() helper that expects to know the
layout of struct btf_enum64. So we get a bit creative with
reinterpreting memory layout as array of __u32 and accesing lo32/hi32
fields as array elements. Alternative way would be to have a local
pointer variable for anonymous struct with exactly the same layout as
struct btf_enum64, but that gets us into C++ compiler errors complaining
about invalid type casts. So play it safe, if ugly.

  [0] Closes: https://github.com/libbpf/libbpf/issues/562

Fixes: d90ec262b35b ("libbpf: Add enum64 support for btf_dump")
Reported-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://lore.kernel.org/bpf/20220927042940.147185-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 583760df83b4..d421d656a076 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -487,6 +487,8 @@ static inline struct btf_enum *btf_enum(const struct btf_type *t)
 	return (struct btf_enum *)(t + 1);
 }
 
+struct btf_enum64;
+
 static inline struct btf_enum64 *btf_enum64(const struct btf_type *t)
 {
 	return (struct btf_enum64 *)(t + 1);
@@ -494,7 +496,28 @@ static inline struct btf_enum64 *btf_enum64(const struct btf_type *t)
 
 static inline __u64 btf_enum64_value(const struct btf_enum64 *e)
 {
-	return ((__u64)e->val_hi32 << 32) | e->val_lo32;
+	/* struct btf_enum64 is introduced in Linux 6.0, which is very
+	 * bleeding-edge. Here we are avoiding relying on struct btf_enum64
+	 * definition coming from kernel UAPI headers to support wider range
+	 * of system-wide kernel headers.
+	 *
+	 * Given this header can be also included from C++ applications, that
+	 * further restricts C tricks we can use (like using compatible
+	 * anonymous struct). So just treat struct btf_enum64 as
+	 * a three-element array of u32 and access second (lo32) and third
+	 * (hi32) elements directly.
+	 *
+	 * For reference, here is a struct btf_enum64 definition:
+	 *
+	 * const struct btf_enum64 {
+	 *	__u32	name_off;
+	 *	__u32	val_lo32;
+	 *	__u32	val_hi32;
+	 * };
+	 */
+	const __u32 *e64 = (const __u32 *)e;
+
+	return ((__u64)e64[2] << 32) | e64[1];
 }
 
 static inline struct btf_member *btf_members(const struct btf_type *t)
-- 
2.35.1



