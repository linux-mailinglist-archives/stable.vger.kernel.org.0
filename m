Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15834997E7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351894AbiAXVRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34670 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448834AbiAXVNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26373B811A2;
        Mon, 24 Jan 2022 21:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384DCC340E5;
        Mon, 24 Jan 2022 21:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058831;
        bh=I6eodZE1LcEU8Q+OsMt9Qrl7f05Xen+Z8HM/mrSDGKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/IjIU8/nUTcwnh+OYRKuBCyJz7fVKMwNC7fs/idICvFpQwUkDaq8jgKPgyLkV3BS
         2LtYhO0eJCsOQtkBtPk4ye6Z6fykcImebsvKj8qwz2emffYoKHTXlD6qKBfl+wfTJY
         O6tCRyOD3+6itBwEPJMC7wDEQ3LxDQfe/LVsV08I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0417/1039] Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt()
Date:   Mon, 24 Jan 2022 19:36:46 +0100
Message-Id: <20220124184139.328443652@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b9f9dbad0bd1c302d357fdd327c398f51f5fc2b1 ]

This copies a u16 into the high bits of an int, which works on a big
endian system but not on a little endian system.

Fixes: 09572fca7223 ("Bluetooth: hci_sock: Add support for BT_{SND,RCV}BUF")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d0dad1fafe079..f2506e656f3e4 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1915,7 +1915,8 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
 			       sockptr_t optval, unsigned int len)
 {
 	struct sock *sk = sock->sk;
-	int err = 0, opt = 0;
+	int err = 0;
+	u16 opt;
 
 	BT_DBG("sk %p, opt %d", sk, optname);
 
@@ -1941,7 +1942,7 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
 			goto done;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u16))) {
+		if (copy_from_sockptr(&opt, optval, sizeof(opt))) {
 			err = -EFAULT;
 			break;
 		}
-- 
2.34.1



