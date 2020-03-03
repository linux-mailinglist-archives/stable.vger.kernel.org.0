Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366FA17809E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733157AbgCCR5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:57:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733138AbgCCR5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:57:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AA220870;
        Tue,  3 Mar 2020 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258268;
        bh=oYsBVkWhjO1Ft4lbRAgaWtSyXy9bZf8lJSwTPVyvDJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCPt7QT6EsPcqkz+SXPpcrtacCAJur2EYrQj4PLProUbLE2Ze8CzZkhLXJ3buv0eS
         P0mXblHls7YgARynQ0u37QubazpJDLAadQBKToGS6CotxEf2CXTQUbe/7ZXaalbZj7
         17l4Jw+jA1Ujes+AcDNYsycObvOxNdTHfkj6Jc2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4b1fe8105f8044a26162@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 088/152] net/smc: transfer fasync_list in case of fallback
Date:   Tue,  3 Mar 2020 18:43:06 +0100
Message-Id: <20200303174312.576825417@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

commit 67f562e3e147750a02b2a91d21a163fc44a1d13e upstream.

SMC does not work together with FASTOPEN. If sendmsg() is called with
flag MSG_FASTOPEN in SMC_INIT state, the SMC-socket switches to
fallback mode. To handle the previous ioctl FIOASYNC call correctly
in this case, it is necessary to transfer the socket wait queue
fasync_list to the internal TCP socket.

Reported-by: syzbot+4b1fe8105f8044a26162@syzkaller.appspotmail.com
Fixes: ee9dfbef02d18 ("net/smc: handle sockopts forcing fallback")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/smc/af_smc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -467,6 +467,8 @@ static void smc_switch_to_fallback(struc
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
 		smc->clcsock->file->private_data = smc->clcsock;
+		smc->clcsock->wq.fasync_list =
+			smc->sk.sk_socket->wq.fasync_list;
 	}
 }
 


