Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22955949AC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354984AbiHOXzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356247AbiHOXyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:54:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BDEC6B60;
        Mon, 15 Aug 2022 13:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49FB1B81183;
        Mon, 15 Aug 2022 20:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE74C43470;
        Mon, 15 Aug 2022 20:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594724;
        bh=0FbSLWD+h5j9QQmrAuoZsBgelezyJQ90AnloIDebRaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfOCCOvinwDy1+fJDICzlicMOZji+RSieUAAVS2QCI11j0xE3U3L6c6dRZsQQRdq8
         VMIwdkBBYRELyDAUebhxTe0TCR0snlHWfxxuj7mYtWdD/bt4zVYaH/I54iJsr1JwuJ
         NEgZkikPy8r8aZdpPEuS370LcwPzMkOhmZ1D8Wro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0538/1157] bpf: Fix bpf_xdp_pointer return pointer
Date:   Mon, 15 Aug 2022 19:58:14 +0200
Message-Id: <20220815180501.185772727@linuxfoundation.org>
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
index 5978984b752f..74f05ed6aff2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3918,7 +3918,7 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 		offset -= frag_size;
 	}
 out:
-	return offset + len < size ? addr + offset : NULL;
+	return offset + len <= size ? addr + offset : NULL;
 }
 
 BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
-- 
2.35.1



