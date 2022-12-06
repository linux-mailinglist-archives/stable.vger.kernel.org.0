Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CC7644078
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiLFJw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiLFJv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:51:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE50022BCE;
        Tue,  6 Dec 2022 01:50:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B62B818E4;
        Tue,  6 Dec 2022 09:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4403C433D7;
        Tue,  6 Dec 2022 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320238;
        bh=2BuHfM250BIV9oKXyCjXTvp0gtEGdBGY4IMkhrgOoVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWXAs7/emOt5PyHblIPtlFyL+adGqMadlk/2RUgJbeDn+53zygvuwAa+CPUdAfaYx
         6XV86j5ikUjXoyUztnynbL5sJVE+UyyEKL56OhZR6SppkB+1rVpH6I7ZsFEAt0a5lM
         H4AJKqsxkJ2a1jl8Z11afVaZpG+ndTIJkKsHKF4jJKGlI1PiuFDUGrYzuHE4WwLyqY
         Lm9zD0I+AHPO8DOaU8VEGUhErc4/MiIV47/HgtkVF2T0GzwP0wF8AMMjURjMCv9rI/
         rHosybQ3L5mG79Cqq4gQt9L7OJep75ENvzZmTujeMBCHtpBlhxFYW2sEGlEozxIVfa
         zDg5+3LN1mX6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>, Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/10] libbpf: Use page size as max_entries when probing ring buffer map
Date:   Tue,  6 Dec 2022 04:50:21 -0500
Message-Id: <20221206095027.987587-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095027.987587-1-sashal@kernel.org>
References: <20221206095027.987587-1-sashal@kernel.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 689eb2f1ba46b4b02195ac2a71c55b96d619ebf8 ]

Using page size as max_entries when probing ring buffer map, else the
probe may fail on host with 64KB page size (e.g., an ARM64 host).

After the fix, the output of "bpftool feature" on above host will be
correct.

Before :
    eBPF map_type ringbuf is NOT available
    eBPF map_type user_ringbuf is NOT available

After :
    eBPF map_type ringbuf is available
    eBPF map_type user_ringbuf is available

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221116072351.1168938-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_probes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index d38284a3aaf0..13393f0eab25 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -244,7 +244,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_UNSPEC:
 	case BPF_MAP_TYPE_HASH:
-- 
2.35.1

