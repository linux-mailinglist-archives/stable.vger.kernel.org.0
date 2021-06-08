Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1382E39FFCC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhFHSgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhFHSex (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8EBA613D2;
        Tue,  8 Jun 2021 18:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177123;
        bh=EHZJLvG/aunoeWaZiHpji8erF1KoKgD/dmIWqn/lG2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpXH2DyyAs5vPPo2aro3gtTyCx0+8PKqZKnr6DjWWjou2GtaA5Al5SnGo+B8hPusx
         14BjwB+aLfiFH6GwBUgJ02rnKNXw+XKwssWzIfFNQtwG90Dl81UQ4Mum94U2a4OLSE
         bbZ69uDYIC1YADNHM9HY0tpfmKwB+wohCce63bpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.14 14/47] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Tue,  8 Jun 2021 20:26:57 +0200
Message-Id: <20210608175930.951544948@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
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
@@ -750,7 +750,7 @@ void hci_sock_dev_event(struct hci_dev *
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			bh_lock_sock_nested(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -759,7 +759,7 @@ void hci_sock_dev_event(struct hci_dev *
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}


