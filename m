Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53B13FFEC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgAPXqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390905AbgAPXWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11D3C2073A;
        Thu, 16 Jan 2020 23:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216932;
        bh=tSTT7czsVqE67MSHd+OyLSOcwk2po/pfGgxNVwE0rG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHYzm8UNtl16EINndx6QYrZms6VX6R1sCpJgbhRPUiCT7q2KFzMECmlVQ59JaQD2e
         PN48xhELSsBDgBVvFF0z/cPYohnA9aQcQItCqcsQ5favOj5jA8EGZfi0ONe9aIHyqM
         +R84ruSgTs2EcN2WythxYxMjKibIEPdDAYqdOTwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 079/203] bpf: skmsg, fix potential psock NULL pointer dereference
Date:   Fri, 17 Jan 2020 00:16:36 +0100
Message-Id: <20200116231751.508994827@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 8163999db445021f2651a8a47b5632483e8722ea upstream.

Report from Dan Carpenter,

 net/core/skmsg.c:792 sk_psock_write_space()
 error: we previously assumed 'psock' could be null (see line 790)

 net/core/skmsg.c
   789 psock = sk_psock(sk);
   790 if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
 Check for NULL
   791 schedule_work(&psock->work);
   792 write_space = psock->saved_write_space;
                     ^^^^^^^^^^^^^^^^^^^^^^^^
   793          rcu_read_unlock();
   794          write_space(sk);

Ensure psock dereference on line 792 only occurs if psock is not null.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skmsg.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -793,15 +793,18 @@ static void sk_psock_strp_data_ready(str
 static void sk_psock_write_space(struct sock *sk)
 {
 	struct sk_psock *psock;
-	void (*write_space)(struct sock *sk);
+	void (*write_space)(struct sock *sk) = NULL;
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
-	if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
-		schedule_work(&psock->work);
-	write_space = psock->saved_write_space;
+	if (likely(psock)) {
+		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+			schedule_work(&psock->work);
+		write_space = psock->saved_write_space;
+	}
 	rcu_read_unlock();
-	write_space(sk);
+	if (write_space)
+		write_space(sk);
 }
 
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)


