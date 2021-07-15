Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1919B3CAABC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243237AbhGOTP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242168AbhGOTNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:13:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFBAA613F8;
        Thu, 15 Jul 2021 19:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376178;
        bh=iDdTHi8fF05/l89Ec0k1cfTqdGzT83J5qDlWvN6L4fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDn6aQ6DkWE3QprIi5i7itIPNK7lMFCr2MM/YlTUayOniChcRoWoZ0QQVpXUdRcZJ
         BbhP1aenkHFH2IrG3VhQ4OngXNAu9KywicpPBZV9VoIz16mJnOfXGkM5xMZCemE4Z1
         fxXV4rRleknoM0nSbbcbbnTDV74Hr3Fr9Mo+syBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 158/266] Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails
Date:   Thu, 15 Jul 2021 20:38:33 +0200
Message-Id: <20210715182640.766373612@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

[ Upstream commit 3cfdf8fcaafa62a4123f92eb0f4a72650da3a479 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/cmtp/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 07cfa3249f83..0a2d78e811cf 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -392,6 +392,11 @@ int cmtp_add_connection(struct cmtp_connadd_req *req, struct socket *sock)
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
-- 
2.30.2



