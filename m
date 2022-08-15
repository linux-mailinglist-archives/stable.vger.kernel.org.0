Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D8D594118
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbiHOVTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347024AbiHOVSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E33ACC5;
        Mon, 15 Aug 2022 12:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC6CE60EF0;
        Mon, 15 Aug 2022 19:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DA5C4315D;
        Mon, 15 Aug 2022 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591306;
        bh=7HKHyqcvmrU1BBYjyvlutRcXUP3YLfWBNtPAvCpOBb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1nrQguorhrAiTSNB9HbQiOhsSkEnp6oCT1xBHEA8k1SIU1EkS0MNZUKiKh0MjgiS
         81KrJfcDZgXsUA/ZSFJ/wq/VLycAxQ/570OhjVA97s4henDem277jG7K+IeB1Rwe9H
         TsecEe5PPtPqnw4646Gogcb90sh1mV9U0q53pHPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0503/1095] bpf: Fix bpf_xdp_pointer return pointer
Date:   Mon, 15 Aug 2022 19:58:22 +0200
Message-Id: <20220815180450.337220358@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit bbd52178e249fe893ef4a9b87cde5b6c473b0a7c ]

For the case where offset + len == size, bpf_xdp_pointer should return a
valid pointer to the addr because that access is permitted. We should
only return NULL in the case where offset + len exceeds size.

Fixes: 3f364222d032 ("net: xdp: introduce bpf_xdp_pointer utility routine")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/bpf/20220722220105.2065466-1-joannelkoong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5db4fae23925..a98f34cb5aee 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3917,7 +3917,7 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 		offset -= frag_size;
 	}
 out:
-	return offset + len < size ? addr + offset : NULL;
+	return offset + len <= size ? addr + offset : NULL;
 }
 
 BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
-- 
2.35.1



