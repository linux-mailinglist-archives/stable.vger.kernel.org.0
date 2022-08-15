Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB06594940
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiHOXWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343749AbiHOXTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:19:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08CF7D787;
        Mon, 15 Aug 2022 13:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20794612B9;
        Mon, 15 Aug 2022 20:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283F7C433D6;
        Mon, 15 Aug 2022 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593831;
        bh=uMjdYRG3+VDQk8IKRHWN1MhbaHv9EFFvW0HrKc874qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1UiYf/cImZ7QYP3S7ngqpxpbNfJwJeTkgZ697HCzQ2543qlevw0XGoMM/Oeep2wA
         Y3S6tzeIiP0ONDnwC0FCTPuLYxYm/BMtUjiI/lLPR9OWiPTzAD3QhLuUeMbacdkAte
         EthCUzhCPIy+0v71XxHFxA/ZAWg291MvMjh31iQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuze Chi <chiyuze@google.com>,
        Ian Rogers <irogers@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0332/1157] libbpf: Fix is_pow_of_2
Date:   Mon, 15 Aug 2022 19:54:48 +0200
Message-Id: <20220815180452.942992530@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Yuze Chi <chiyuze@google.com>

[ Upstream commit 611edf1bacc51355ccb497915695db7f869cb382 ]

Move the correct definition from linker.c into libbpf_internal.h.

Fixes: 0087a681fa8c ("libbpf: Automatically fix up BPF_MAP_TYPE_RINGBUF size, if necessary")
Reported-by: Yuze Chi <chiyuze@google.com>
Signed-off-by: Yuze Chi <chiyuze@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220603055156.2830463-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 5 -----
 tools/lib/bpf/libbpf_internal.h | 5 +++++
 tools/lib/bpf/linker.c          | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e89cc9c885b3..526bd6cd84a0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4943,11 +4943,6 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 
 static void bpf_map__destroy(struct bpf_map *map);
 
-static bool is_pow_of_2(size_t x)
-{
-	return x && (x & (x - 1));
-}
-
 static size_t adjust_ringbuf_sz(size_t sz)
 {
 	__u32 page_sz = sysconf(_SC_PAGE_SIZE);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 4abdbe2fea9d..ef5d975078e5 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -580,4 +580,9 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
 					   const char *usdt_provider, const char *usdt_name,
 					   __u64 usdt_cookie);
 
+static inline bool is_pow_of_2(size_t x)
+{
+	return x && (x & (x - 1)) == 0;
+}
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 9aa016fb55aa..85c0fddf55d1 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -697,11 +697,6 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 	return err;
 }
 
-static bool is_pow_of_2(size_t x)
-{
-	return x && (x & (x - 1)) == 0;
-}
-
 static int linker_sanity_check_elf(struct src_obj *obj)
 {
 	struct src_sec *sec;
-- 
2.35.1



