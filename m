Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BE929C51D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824199AbgJ0SEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757318AbgJ0OSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:18:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A763206F7;
        Tue, 27 Oct 2020 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808320;
        bh=Ce5G3aT6s0R3Dn6U49AQ5sEQzHQ1jywGS2Wow75T/qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBg2dGX1m0tYCXyG5J+BcWRaigmtnxDRuCpqvNXx48XCR9tD8vZXUPzj88Pt/jhzb
         qKufNSa308U+uOQXH+k3YEembEQw5nIEzdr7GDE5qfUV1zMfCydT2I0aIWLT0LgZZp
         OHMOM6gKjtQduZUq1RgEASVW8WVI2rv9NMMzdX/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 016/264] chelsio/chtls: fix socket lock
Date:   Tue, 27 Oct 2020 14:51:14 +0100
Message-Id: <20201027135431.431629116@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
@@ -1217,6 +1217,7 @@ int chtls_sendpage(struct sock *sk, stru
 	copied = 0;
 	csk = rcu_dereference_sk_user_data(sk);
 	cdev = csk->cdev;
+	lock_sock(sk);
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 
 	err = sk_stream_wait_connect(sk, &timeo);


