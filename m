Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF263177F4D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgCCRtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbgCCRtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1573F2146E;
        Tue,  3 Mar 2020 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257791;
        bh=sDe29Kms8jsQ3jHa8tH7w8NuRA3O70rxNN7v9CocQ20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcYkxkCbOqtZyVe/gu8ZdfV+omy8+p2zJfchG9as1a7XTf+wVziynxgYhJDB1uW0G
         sWjKi51bJMaQ43Q6Hl0UwOUh4pVTfBgsTa8nrrXm+gv6JOzKuh276GAgBLMlhwc8RF
         IhnlrOIoZDhI+LW80Lac57vB63qxM1+4FBcab6+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4b1fe8105f8044a26162@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 103/176] net/smc: transfer fasync_list in case of fallback
Date:   Tue,  3 Mar 2020 18:42:47 +0100
Message-Id: <20200303174316.760064048@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
@@ -470,6 +470,8 @@ static void smc_switch_to_fallback(struc
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
 		smc->clcsock->file->private_data = smc->clcsock;
+		smc->clcsock->wq.fasync_list =
+			smc->sk.sk_socket->wq.fasync_list;
 	}
 }
 


