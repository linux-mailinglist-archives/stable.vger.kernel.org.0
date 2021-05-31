Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228A1395E46
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhEaN42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233118AbhEaNya (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2774061439;
        Mon, 31 May 2021 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468027;
        bh=IQ7IhCWeAmbY4PS5fgPbkHkaNBhyHOKfgSAxpYDpQB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+BVNwDw2VnC81GDOBi7Z4Ox3buYMbUIGeNbroSM5Buz3Dkka5o+uJUEY8Tf22Yz1
         craLb+4288r/QX9Dsnu5bJiReA+0Y3cwguyNASs9p4AGiZDZRpR7hpSBY8gtAJm/Oa
         Xv7Ij4TxHE1LYhTWEHUsN4UWG3x/lqxY/OG2jz8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 090/252] Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails
Date:   Mon, 31 May 2021 15:12:35 +0200
Message-Id: <20210531130701.027736633@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 8da3a0b87f4f1c3a3bbc4bfb78cf68476e97d183 upstream.

When cmtp_attach_device fails, cmtp_add_connection returns the error value
which leads to the caller to doing fput through sockfd_put. But
cmtp_session kthread, which is stopped in this path will also call fput,
leading to a potential refcount underflow or a use-after-free.

Add a refcount before we signal the kthread to stop. The kthread will try
to grab the cmtp_session_sem mutex before doing the fput, which is held
when get_file is called, so there should be no races there.

Reported-by: Ryota Shiga
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/cmtp/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -392,6 +392,11 @@ int cmtp_add_connection(struct cmtp_conn
 	if (!(session->flags & BIT(CMTP_LOOPBACK))) {
 		err = cmtp_attach_device(session);
 		if (err < 0) {
+			/* Caller will call fput in case of failure, and so
+			 * will cmtp_session kthread.
+			 */
+			get_file(session->sock->file);
+
 			atomic_inc(&session->terminate);
 			wake_up_interruptible(sk_sleep(session->sock->sk));
 			up_write(&cmtp_session_sem);


