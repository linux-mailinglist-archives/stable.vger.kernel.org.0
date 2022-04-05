Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A2F4F2A3F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241862AbiDEIfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239299AbiDEIT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A3C81644;
        Tue,  5 Apr 2022 01:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F127B81B18;
        Tue,  5 Apr 2022 08:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C3EC385A0;
        Tue,  5 Apr 2022 08:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146255;
        bh=rYFP1BJ4Qw1ivdKhFqqmw2gOqzma9KK70jJAP0HaOdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbqLZaG4/FLady0jFeP4RvvokjNuaI1V8xKY78PX/J7RVApm8Cc0ortWn/GtDC52y
         muCAVkxOL1qzEli3vB9nRKwIR/nIv86O0NFK+FoYSeQe+Zzf1yeWutFHWVfsB+2Jej
         yED+MtFCdZFRR9peizCNtHGoJ/WtBYJpH/x0lDp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0698/1126] bpftool: Fix print error when show bpf map
Date:   Tue,  5 Apr 2022 09:24:05 +0200
Message-Id: <20220405070428.096755911@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 1824d8ea75f275a5e69e5f6bc0ffe122ea9b938c ]

If there is no btf_id or frozen, it will not show the pids, but the pids don't
depend on any one of them.

Below is the result after this change:

  $ ./bpftool map show
  2: lpm_trie  flags 0x1
	key 8B  value 8B  max_entries 1  memlock 4096B
	pids systemd(1)
  3: lpm_trie  flags 0x1
	key 20B  value 8B  max_entries 1  memlock 4096B
	pids systemd(1)

While before this change, the 'pids systemd(1)' can't be displayed.

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220320060815.7716-1-laoar.shao@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index e746642de292..0bba33729c7f 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -620,17 +620,14 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 					    u32_as_hash_field(info->id))
 			printf("\n\tpinned %s", (char *)entry->value);
 	}
-	printf("\n");
 
 	if (frozen_str) {
 		frozen = atoi(frozen_str);
 		free(frozen_str);
 	}
 
-	if (!info->btf_id && !frozen)
-		return 0;
-
-	printf("\t");
+	if (info->btf_id || frozen)
+		printf("\n\t");
 
 	if (info->btf_id)
 		printf("btf_id %d", info->btf_id);
-- 
2.34.1



