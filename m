Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD43CB5CE8
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfIRGaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729918AbfIRGYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EFF21925;
        Wed, 18 Sep 2019 06:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787890;
        bh=qT6LTeB0Y8DjWsOQHhfaBy5k5TFm7jjY4GU5576E+2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhoR1MDKRyowUUBVgfiPVssDit9vsVED6KUEPeIAqCIYXbTxF6tOcy/tWMPs/9/8H
         VWlzyPRapKBoTVgZpiHHCva8mNWkroHhyoVaTwYOmQ6OAlJXmirxxjH+MqhzLXNWXU
         trjsXLc4XdSC6SC4/PDJciatEvJvsat2Sj/DAcYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 21/85] net: sock_map, fix missing ulp check in sock hash case
Date:   Wed, 18 Sep 2019 08:18:39 +0200
Message-Id: <20190918061234.827446278@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 44580a0118d3ede95fec4dce32df5f75f73cd663 ]

sock_map and ULP only work together when ULP is loaded after the sock
map is loaded. In the sock_map case we added a check for this to fail
the load if ULP is already set. However, we missed the check on the
sock_hash side.

Add a ULP check to the sock_hash update path.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_map.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -661,6 +661,7 @@ static int sock_hash_update_common(struc
 				   struct sock *sk, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 key_size = map->key_size, hash;
 	struct bpf_htab_elem *elem, *elem_new;
 	struct bpf_htab_bucket *bucket;
@@ -671,6 +672,8 @@ static int sock_hash_update_common(struc
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (unlikely(flags > BPF_EXIST))
 		return -EINVAL;
+	if (unlikely(icsk->icsk_ulp_data))
+		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)


