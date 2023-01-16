Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B30D66C4BD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjAPP56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjAPP5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F2322DED
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEFA1B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A773C433D2;
        Mon, 16 Jan 2023 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884654;
        bh=JEE2X1uW1c0hu/JNEICMQRHE5RO2ntKZC7PV2IvJrQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJUqY6z+WmDfNsvFCME66xXmcgkwCb26z8Pzmv9Y7EIBzauTLM+pUwpnKcXrfiSUJ
         nMlV8pXkZVlxJSz5tSzb9vBDgu2ovl0bybur34cwN6N4HiPkdLYsvCPxduCuGwhWxt
         Nym5QbmigTtpC0bnD430y0m6IikG4pzuouYNGiEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Zeng <zengyhkyle@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 071/183] ipv6: raw: Deduct extension header length in rawv6_push_pending_frames
Date:   Mon, 16 Jan 2023 16:49:54 +0100
Message-Id: <20230116154806.372895612@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit cb3e9864cdbe35ff6378966660edbcbac955fe17 upstream.

The total cork length created by ip6_append_data includes extension
headers, so we must exclude them when comparing them against the
IPV6_CHECKSUM offset which does not include extension headers.

Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Fixes: 357b40a18b04 ("[IPV6]: IPV6_CHECKSUM socket option can corrupt kernel memory")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -505,6 +505,7 @@ csum_copy_err:
 static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 				     struct raw6_sock *rp)
 {
+	struct ipv6_txoptions *opt;
 	struct sk_buff *skb;
 	int err = 0;
 	int offset;
@@ -522,6 +523,9 @@ static int rawv6_push_pending_frames(str
 
 	offset = rp->offset;
 	total_len = inet_sk(sk)->cork.base.length;
+	opt = inet6_sk(sk)->cork.opt;
+	total_len -= opt ? opt->opt_flen : 0;
+
 	if (offset >= total_len - 1) {
 		err = -EINVAL;
 		ip6_flush_pending_frames(sk);


