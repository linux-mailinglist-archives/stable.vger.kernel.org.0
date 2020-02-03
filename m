Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB614150BA2
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgBCQ3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgBCQ3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:29:21 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D1552080C;
        Mon,  3 Feb 2020 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747360;
        bh=+9v1YmqM5cGr9f0t/YOS9oSKpM+ddnVM0YUWm6ru+bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEvEZAQE8P5M295Ly/yCa/gSN7bWVf9+Ca9JWgUUp9gdt82q9nIHJgq6gxsP10pwO
         sA9ePTLK+y8MUUs2S7DmpgH1ddEBfz8Y0eBFbvsa16kYLcw/xQ7k1CvAryY0v8lLUV
         AY/ditWg8OYU+4keEcPx7eOOkzhRtFFovCi0Ob6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 4.14 50/89] Bluetooth: Fix race condition in hci_release_sock()
Date:   Mon,  3 Feb 2020 16:19:35 +0000
Message-Id: <20200203161923.609945033@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 11eb85ec42dc8c7a7ec519b90ccf2eeae9409de8 upstream.

Syzbot managed to trigger a use after free "KASAN: use-after-free Write
in hci_sock_bind".  I have reviewed the code manually and one possibly
cause I have found is that we are not holding lock_sock(sk) when we do
the hci_dev_put(hdev) in hci_sock_release().  My theory is that the bind
and the release are racing against each other which results in this use
after free.

Reported-by: syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -826,6 +826,8 @@ static int hci_sock_release(struct socke
 	if (!sk)
 		return 0;
 
+	lock_sock(sk);
+
 	switch (hci_pi(sk)->channel) {
 	case HCI_CHANNEL_MONITOR:
 		atomic_dec(&monitor_promisc);
@@ -873,6 +875,7 @@ static int hci_sock_release(struct socke
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
 
+	release_sock(sk);
 	sock_put(sk);
 	return 0;
 }


