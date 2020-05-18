Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2CA1D8553
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgERR4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731600AbgERR4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995B320674;
        Mon, 18 May 2020 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824570;
        bh=SUj2naAkwmQKm48N3wkhavOBfjGOL4aAvxca/OACGLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4rnuiE1+WQhDz+aAHqHxMob5QW9RMV9w+QRLuGMWcY4Ll2tduZhke27MQTq0hxS9
         fTuLnGgd741a+U3enpK+Vix6aJPhiMbum2gvCaKvN/gaZ7IrbGFFYHp+ffN9fLBW2X
         PtdNEFup7WSEUHEGSKkq9M2HW7iGOhE0C1j61t78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/147] bpf, sockmap: msg_pop_data can incorrecty set an sge length
Date:   Mon, 18 May 2020 19:36:27 +0200
Message-Id: <20200518173522.043577325@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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
index d59dbc88fef5d..f1f2304822e3b 100644
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



