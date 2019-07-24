Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE2E673EF3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389037AbfGXTeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389026AbfGXTeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:34:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6969A21951;
        Wed, 24 Jul 2019 19:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996840;
        bh=eWLE12TI9q55kDE2CbptexNcBXzWn/WZQmLU0F6g4Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Di+5sBmAuda0gPVpPCE043+8SMFwLdhy5caP7Dem4iiE7Ftim3wwwkaOLg+J6/eS
         TYnzxfI6WkGM+o30Xo9ilmcXttUUfh08a80Wo4GpnUOKK/ULuTlG+CaLc9mU0vcRGx
         jz+oZvcNrYNCQjfOdtvo1VC0EWbV687ECdfJupf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 235/413] Bluetooth: hidp: NUL terminate a string in the compat ioctl
Date:   Wed, 24 Jul 2019 21:18:46 +0200
Message-Id: <20190724191752.049270801@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dcae9052ebb0c5b2614de620323d615fcbfda7f8 ]

This change is similar to commit a1616a5ac99e ("Bluetooth: hidp: fix
buffer overflow") but for the compat ioctl.  We take a string from the
user and forgot to ensure that it's NUL terminated.

I have also changed the strncpy() in to strscpy() in hidp_setup_hid().
The difference is the strncpy() doesn't necessarily NUL terminate the
destination string.  Either change would fix the problem but it's nice
to take a belt and suspenders approach and do both.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hidp/core.c | 2 +-
 net/bluetooth/hidp/sock.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index a442e21f3894..5abd423b55fa 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -775,7 +775,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, sizeof(hid->name));
+	strscpy(hid->name, req->name, sizeof(hid->name));
 
 	snprintf(hid->phys, sizeof(hid->phys), "%pMR",
 		 &l2cap_pi(session->ctrl_sock->sk)->chan->src);
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 2151913892ce..03be6a4baef3 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -192,6 +192,7 @@ static int hidp_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsigne
 		ca.version = ca32.version;
 		ca.flags = ca32.flags;
 		ca.idle_to = ca32.idle_to;
+		ca32.name[sizeof(ca32.name) - 1] = '\0';
 		memcpy(ca.name, ca32.name, 128);
 
 		csock = sockfd_lookup(ca.ctrl_sock, &err);
-- 
2.20.1



