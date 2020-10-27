Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7926629B159
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901938AbgJ0O3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901936AbgJ0O3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A67620780;
        Tue, 27 Oct 2020 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808961;
        bh=2jbltcVQyOMs0m+1duzE8LSh09kYH4ejNkuaYfXlfEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrOpN2G69sWinjfKxRkONMc0tFlcvzRqiwymTBMb9HEBnn4iXgQzTwoFIYinpeWbb
         toOgN8qEfzbcD2BO4pUlFF2Zc0Hrq3Nm6+68jU+81bovd4+5q8NO10X5nbrBjuIda1
         OYFHoQrflPZ6iARNspQfY+Nsy87MBl86hY5l4n5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 025/408] chelsio/chtls: fix socket lock
Date:   Tue, 27 Oct 2020 14:49:23 +0100
Message-Id: <20201027135456.233512294@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 0fb5f0160a36d7acaa8e84ce873af99f94b60484 ]

In chtls_sendpage() socket lock is released but not acquired,
fix it by taking lock.

Fixes: 36bedb3f2e5b ("crypto: chtls - Inline TLS record Tx")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1210,6 +1210,7 @@ int chtls_sendpage(struct sock *sk, stru
 	copied = 0;
 	csk = rcu_dereference_sk_user_data(sk);
 	cdev = csk->cdev;
+	lock_sock(sk);
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 
 	err = sk_stream_wait_connect(sk, &timeo);


