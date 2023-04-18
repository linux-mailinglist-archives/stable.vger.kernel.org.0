Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10D6E6499
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjDRMud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjDRMuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EF716DEC
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA69C63417
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F19C433D2;
        Tue, 18 Apr 2023 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822230;
        bh=Id7GFtZh4hW4W0Drte2YouIRbhqjeE2dYh5azugHUDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKgMJ5UHVoIDm6qh/E+MUD7M3dbwgVl33sQAxlFXDAH4FWaTK8uCXzY1WyerqJqeM
         E5oPA7SpeOxddHHc2WMVPJn4JVLLRmiRPTGttzrek5JNosgDXK3oSIrPHv5ZNX3Qwv
         kVdjfJzBAK204X6rLmH3/bpW/aG53JYkgcDHvGlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin KaFai Lau <martin.lau@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 042/139] bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp
Date:   Tue, 18 Apr 2023 14:21:47 +0200
Message-Id: <20230418120315.230258902@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 580031ff9952b7dbf48dedba6b56a100ae002bef ]

While reviewing the udp-iter batching patches, noticed the bpf_iter_tcp
calling sock_put() is incorrect. It should call sock_gen_put instead
because bpf_iter_tcp is iterating the ehash table which has the req sk
and tw sk. This patch replaces all sock_put with sock_gen_put in the
bpf_iter_tcp codepath.

Fixes: 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230328004232.2134233-1-martin.lau@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8320d0ecb13ae..339a9cea90473 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2779,7 +2779,7 @@ static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
 static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
 {
 	while (iter->cur_sk < iter->end_sk)
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 }
 
 static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
@@ -2940,7 +2940,7 @@ static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		 * st->bucket.  See tcp_seek_last_pos().
 		 */
 		st->offset++;
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 	}
 
 	if (iter->cur_sk < iter->end_sk)
-- 
2.39.2



