Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97245A48DB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiH2LQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiH2LOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:14:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF6472B75;
        Mon, 29 Aug 2022 04:10:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1BF86119C;
        Mon, 29 Aug 2022 11:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5167C433C1;
        Mon, 29 Aug 2022 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771323;
        bh=VA5pbYSxgeywqyxib2YTEtxEPOdpdXM6dct4Diz46Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKggqe1SNZrAwiY0KQD5QGt3qJRh/begl8qdfnblbFF4YAwVXFWLNx90bZ9taRbjf
         36pR/c1vQLUsBT7af+558ww6qkdh5NfuyBhuFTrALBjRljUyeyh3Z8Y+TyjggJFpnU
         06UutScM6NiXFEe+J/xX4j4gUkis2pYlcbleCNaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/86] bpf: Folding omem_charge() into sk_storage_charge()
Date:   Mon, 29 Aug 2022 12:59:17 +0200
Message-Id: <20220829105758.618733724@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 9e838b02b0bb795793f12049307a354e28b5749c ]

sk_storage_charge() is the only user of omem_charge().
This patch simplifies it by folding omem_charge() into
sk_storage_charge().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: KP Singh <kpsingh@google.com>
Link: https://lore.kernel.org/bpf/20201112211301.2586255-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 5f773624948ff..39c5a059d1c2b 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -15,18 +15,6 @@
 
 DEFINE_BPF_STORAGE_CACHE(sk_cache);
 
-static int omem_charge(struct sock *sk, unsigned int size)
-{
-	/* same check as in sock_kmalloc() */
-	if (size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
-		atomic_add(size, &sk->sk_omem_alloc);
-		return 0;
-	}
-
-	return -ENOMEM;
-}
-
 static struct bpf_local_storage_data *
 sk_storage_lookup(struct sock *sk, struct bpf_map *map, bool cacheit_lockit)
 {
@@ -316,7 +304,16 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, sk)
 static int sk_storage_charge(struct bpf_local_storage_map *smap,
 			     void *owner, u32 size)
 {
-	return omem_charge(owner, size);
+	struct sock *sk = (struct sock *)owner;
+
+	/* same check as in sock_kmalloc() */
+	if (size <= sysctl_optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+		atomic_add(size, &sk->sk_omem_alloc);
+		return 0;
+	}
+
+	return -ENOMEM;
 }
 
 static void sk_storage_uncharge(struct bpf_local_storage_map *smap,
-- 
2.35.1



