Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C83C4F09
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbhGLHWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240785AbhGLHTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 575386144A;
        Mon, 12 Jul 2021 07:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074176;
        bh=BZg1ZmptamxlKGDCux2iZ+5DEortB9FdmYQHKVSzNrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eakU5Q5I3PSlQzMFIzOukgX1SIF1kwaaOsClsJgqnjPzRjufCJW5YOuqObwI9F54f
         GRQY3W5UdBIV+GRCPznJzmS9778eBD4wuRcore7UAT4nRxP5VTPRhEpnm+g3KAsLfj
         w3mfYVLhaAUFbQVZcQV1d90Z5TV7UGTxXm1MZp8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 448/700] tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
Date:   Mon, 12 Jul 2021 08:08:51 +0200
Message-Id: <20210712061024.193653185@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d452d48b9f8b1a7f8152d33ef52cfd7fe1735b0a ]

We got multiple reports that multi_chunk_sendfile test
case from tls selftest fails. This was sort of expected,
as the original fix was never applied (see it in the first
Link:). The test in question uses sendfile() with count
larger than the size of the underlying file. This will
make splice set MSG_MORE on all sendpage calls, meaning
TLS will never close and flush the last partial record.

Eric seem to have addressed a similar problem in
commit 35f9c09fe9c7 ("tcp: tcp_sendpages() should call tcp_push() once")
by introducing MSG_SENDPAGE_NOTLAST. Unlike MSG_MORE
MSG_SENDPAGE_NOTLAST is not set on the last call
of a "pipefull" of data (PIPE_DEF_BUFFERS == 16,
so every 16 pages or whenever we run out of data).

Having a break every 16 pages should be fine, TLS
can pack exactly 4 pages into a record, so for
aligned reads there should be no difference,
unaligned may see one extra record per sendpage().

Sticking to TCP semantics seems preferable to modifying
splice, but we can revisit it if real life scenarios
show a regression.

Reported-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reported-by: Seth Forshee <seth.forshee@canonical.com>
Link: https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/
Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6086cf4f10a7..60d2ff13fa9e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1153,7 +1153,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	int ret = 0;
 	bool eor;
 
-	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));
+	eor = !(flags & MSG_SENDPAGE_NOTLAST);
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
 	/* Call the sk_stream functions to manage the sndbuf mem. */
-- 
2.30.2



