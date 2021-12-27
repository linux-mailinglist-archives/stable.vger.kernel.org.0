Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA45247FF03
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhL0PeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:34:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34766 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbhL0Pdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61F18610A2;
        Mon, 27 Dec 2021 15:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46107C36AE7;
        Mon, 27 Dec 2021 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619232;
        bh=bUfs0Gedj1gdrIRjzY4iKOkNhyUcxve9C18EUAQv898=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnt7dItiYbndVA9ipiakdZ/ug3UtH8/6prrNd6BZ2/5BRCVLjMQ/rCgP9e0MJkf1q
         /+qms/726zGCCmOr+w06YIxqfLxK/fEwePjHuvbLv0DBD1ALs/itWKG3nQk2uZFMeg
         pNWyUbP9aXRVAfk7lg4enpk1INmvyvQ+WAHYAZr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com,
        =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 38/38] phonet/pep: refuse to enable an unbound pipe
Date:   Mon, 27 Dec 2021 16:31:15 +0100
Message-Id: <20211227151320.658744769@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rémi Denis-Courmont <remi@remlab.net>

commit 75a2f31520095600f650597c0ac41f48b5ba0068 upstream.

This ioctl() implicitly assumed that the socket was already bound to
a valid local socket name, i.e. Phonet object. If the socket was not
bound, two separate problems would occur:

1) We'd send an pipe enablement request with an invalid source object.
2) Later socket calls could BUG on the socket unexpectedly being
   connected yet not bound to a valid object.

Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com
Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -959,6 +959,8 @@ static int pep_ioctl(struct sock *sk, in
 			ret =  -EBUSY;
 		else if (sk->sk_state == TCP_ESTABLISHED)
 			ret = -EISCONN;
+		else if (!pn->pn_sk.sobject)
+			ret = -EADDRNOTAVAIL;
 		else
 			ret = pep_sock_enable(sk, NULL, 0);
 		release_sock(sk);


