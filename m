Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC7145C529
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343684AbhKXNzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354424AbhKXNuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62EF06335C;
        Wed, 24 Nov 2021 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759016;
        bh=o04WJ7AXV5Dn+QuaJnA7FXI4N3S3Y0taWdf30+x3jwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpHYbceSW6gmhdURPuElhnt/gaK6kC3IeK10Niw2lpVpg46wbvW0DvTlv+ItWqlv6
         5aV9didT3Kdjg+4zTqgbj7CwaDkLsm+aNiM9iYzNnWTa8RM3AwqJeOh0rpjWZMeTUv
         RnOyq0EXd/nfmax4oLlqc8NyIy7nZ3W9j1s0L4Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/279] bpf: Fix inner map state pruning regression.
Date:   Wed, 24 Nov 2021 12:56:32 +0100
Message-Id: <20211124115722.404261058@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 34d11a440c6167133201b7374065b59f259730d7 ]

Introduction of map_uid made two lookups from outer map to be distinct.
That distinction is only necessary when inner map has an embedded timer.
Otherwise it will make the verifier state pruning to be conservative
which will cause complex programs to hit 1M insn_processed limit.
Tighten map_uid logic to apply to inner maps with timers only.

Fixes: 3e8ce29850f1 ("bpf: Prevent pointer mismatch in bpf_timer_init.")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Lorenz Bauer <lmb@cloudflare.com>
Link: https://lore.kernel.org/bpf/CACAyw99hVEJFoiBH_ZGyy=+oO-jyydoz6v1DeKPKs2HVsUH28w@mail.gmail.com
Link: https://lore.kernel.org/bpf/20211110172556.20754-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ddba80554fef3..cba37d83451eb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1143,7 +1143,8 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 			/* transfer reg's id which is unique for every map_lookup_elem
 			 * as UID of the inner map.
 			 */
-			reg->map_uid = reg->id;
+			if (map_value_has_timer(map->inner_map_meta))
+				reg->map_uid = reg->id;
 		} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
 			reg->type = PTR_TO_XDP_SOCK;
 		} else if (map->map_type == BPF_MAP_TYPE_SOCKMAP ||
-- 
2.33.0



