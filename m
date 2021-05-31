Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC03395B41
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhEaNSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhEaNS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DF2661370;
        Mon, 31 May 2021 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467008;
        bh=IQ7IhCWeAmbY4PS5fgPbkHkaNBhyHOKfgSAxpYDpQB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/Rh4IXaLY0z5YlMtjMqnSBiDPW0SG1iP9PrhinXl/26Vhv0XJFLK+dCsksGCBBfl
         ZtdbGHgV6DfAqe/GzUzBGFlJlS9D/AZ+ze4/PK6lKVtqNOHtOLzpxezJ+h3M+z4evo
         5j674Ic/Ocj7jz4zu7sYV/1e4BWX1VtrowRW+jWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.4 22/54] Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails
Date:   Mon, 31 May 2021 15:13:48 +0200
Message-Id: <20210531130635.790214447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
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


