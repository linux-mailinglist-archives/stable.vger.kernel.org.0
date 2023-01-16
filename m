Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D180366CBDB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjAPRTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbjAPRTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAB053FBD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36728B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90217C433EF;
        Mon, 16 Jan 2023 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888284;
        bh=TS1SiHI61BdoJj455kyEoQji7eZO0vqk7zEug9Vdo5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUS1HIwUdMoMbACL3DCz/qcIHgLJE8fr77q88aj9BkRH5aWwRlOIuizqpH6CJ+wYE
         e+O2JEuYfk5nf9P8Lne7jvj7y7PVBz9OY3j6WLbOUGh2KUVBuTjaJfoL4ZYPKLah/o
         c0qBsS0VsTVs1Yvd2ubb6oorgomxZ2gxrfJ4+pE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Zeng <zengyhkyle@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 471/521] ipv6: raw: Deduct extension header length in rawv6_push_pending_frames
Date:   Mon, 16 Jan 2023 16:52:13 +0100
Message-Id: <20230116154908.248778881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -544,6 +544,7 @@ csum_copy_err:
 static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 				     struct raw6_sock *rp)
 {
+	struct ipv6_txoptions *opt;
 	struct sk_buff *skb;
 	int err = 0;
 	int offset;
@@ -561,6 +562,9 @@ static int rawv6_push_pending_frames(str
 
 	offset = rp->offset;
 	total_len = inet_sk(sk)->cork.base.length;
+	opt = inet6_sk(sk)->cork.opt;
+	total_len -= opt ? opt->opt_flen : 0;
+
 	if (offset >= total_len - 1) {
 		err = -EINVAL;
 		ip6_flush_pending_frames(sk);


