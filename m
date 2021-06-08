Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F443A0147
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhFHSuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235186AbhFHSsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:48:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5FC161416;
        Tue,  8 Jun 2021 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177498;
        bh=9b4TT9IQSDNwMwIJyDMC05NcS5dkRU56xlqceDCnJVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwGpHr4rLb2K7IXu1FVZ0EFmkI9VlNbZmUi3T2ISdyMrCHTVSce4FExe9s880eiGK
         5dEhDvFbr4k3h9EytM1L760Y0X9LRv70zRlkqtWNUgRw0QTbDp4hNCbDN/lTeVwU9d
         K3ETEXPbSfQCZ2edIZL3fFFyVo9G3YKNSjDtEao8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Tue,  8 Jun 2021 20:27:08 +0200
Message-Id: <20210608175936.584233292@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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


