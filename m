Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844C54F31E9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354096AbiDEKLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343970AbiDEJQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E36D64C3;
        Tue,  5 Apr 2022 02:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9850B81C19;
        Tue,  5 Apr 2022 09:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A94DC385A1;
        Tue,  5 Apr 2022 09:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149330;
        bh=VqwssBKFB7BIuRryYFttzTjepDcNzvs/enI6/vnlK6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx8+R5IEkj1fDM7FV7E9VeSO8zE1B0pm1hxzIE15oqblUjpTw5JGuzo1nt1aGOL+K
         oDW6eHVroQYJJ1jBX5/j3U9YngPutOy2C/KIhU+FPZBtZipNEYafAnkGRiDu6OXRmB
         rdfUnhYBgIxLj8u/JAw72lndP7j3OKI0TmzIz4ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0629/1017] bpftool: Fix print error when show bpf map
Date:   Tue,  5 Apr 2022 09:25:42 +0200
Message-Id: <20220405070412.954688301@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 285fb2cbaef6..59d8e72851da 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -619,17 +619,14 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
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



