Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D171D8373
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732852AbgERSEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732850AbgERSEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C26E4208B6;
        Mon, 18 May 2020 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825090;
        bh=apGMZq366a0oOF8+eEi0umUJZjbbxo91gheL+SKekas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBVs4hOgG2DkT2xTV3D1pfoaGEOwXn2vxUYC+ZNCas9zwf9O0VX3zsJBwcs8OBidF
         ++fjh8yRuo/3EnyCNi74TiZA711mf+Jq93PkrcyrqfHjNLgQWrqK5Wn1bNPrBr8Oq1
         gdXPAo/JgBhjmEBwAVueASaxgLLEvR2WzOrPE9wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 086/194] bpf, sockmap: msg_pop_data can incorrecty set an sge length
Date:   Mon, 18 May 2020 19:36:16 +0200
Message-Id: <20200518173538.855990598@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 3e104c23816220919ea1b3fd93fabe363c67c484 ]

When sk_msg_pop() is called where the pop operation is working on
the end of a sge element and there is no additional trailing data
and there _is_ data in front of pop, like the following case,

   |____________a_____________|__pop__|

We have out of order operations where we incorrectly set the pop
variable so that instead of zero'ing pop we incorrectly leave it
untouched, effectively. This can cause later logic to shift the
buffers around believing it should pop extra space. The result is
we have 'popped' more data then we expected potentially breaking
program logic.

It took us a while to hit this case because typically we pop headers
which seem to rarely be at the end of a scatterlist elements but
we can't rely on this.

Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/158861288359.14306.7654891716919968144.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index c180871e606d8..083fbe92662ec 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2590,8 +2590,8 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 			}
 			pop = 0;
 		} else if (pop >= sge->length - a) {
-			sge->length = a;
 			pop -= (sge->length - a);
+			sge->length = a;
 		}
 	}
 
-- 
2.20.1



