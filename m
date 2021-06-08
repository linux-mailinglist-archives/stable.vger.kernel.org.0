Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3633A0030
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhFHSkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234950AbhFHSh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AC5F6140C;
        Tue,  8 Jun 2021 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177191;
        bh=9b4TT9IQSDNwMwIJyDMC05NcS5dkRU56xlqceDCnJVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z72rvcuoyR1PkhMnybwntlsEZqx/l5JCdTHDv+zwAthid1TRNjVdGXR8YCwsBTN5Q
         Lamy8PlzJRxUxD/+dXxINCAKpRMn/1jwg3BwTIHYnkNsker5LXdRtGSwWfoZOjeGvg
         kV7Wej24iN3tIg9hq1M6jyLB3zbNrZX7QMfDoOQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 20/58] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Tue,  8 Jun 2021 20:27:01 +0200
Message-Id: <20210608175932.948149634@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit e305509e678b3a4af2b3cfd410f409f7cdaabb52 upstream.

The hci_sock_dev_event() function will cleanup the hdev object for
sockets even if this object may still be in used within the
hci_sock_bound_ioctl() function, result in UAF vulnerability.

This patch replace the BH context lock to serialize these affairs
and prevent the race condition.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -755,7 +755,7 @@ void hci_sock_dev_event(struct hci_dev *
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			bh_lock_sock_nested(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -764,7 +764,7 @@ void hci_sock_dev_event(struct hci_dev *
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}


