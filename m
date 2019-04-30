Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F16F853
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfD3Lka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbfD3Lk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61ED821707;
        Tue, 30 Apr 2019 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624428;
        bh=sspXV42TCOAkUcSZ2kigqA1X5pjGlPYYt7R5u7gn3eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hn5gRL32EkGyPv6kvFOIp18mmmxobPbT+WA2tefKZcWiHoRFdhCaCxuObrywglW+k
         3nxOjUfxXrEY21O3c312AJBwVX6vnbs+tMY0WDznAlakMbPiMH1pjsoIOIZ4VOzIkY
         93S81hHDeT4Fdlm3VnhwYiAWcL+V/JbzZcmNSREA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+047a11c361b872896a4f@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.9 24/41] NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.
Date:   Tue, 30 Apr 2019 13:38:35 +0200
Message-Id: <20190430113530.731893661@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 7c2bd9a39845bfb6d72ddb55ce737650271f6f96 upstream.

syzbot is reporting uninitialized value at rpc_sockaddr2uaddr() [1]. This
is because syzbot is setting AF_INET6 to "struct sockaddr_in"->sin_family
(which is embedded into user-visible "struct nfs_mount_data" structure)
despite nfs23_validate_mount_data() cannot pass sizeof(struct sockaddr_in6)
bytes of AF_INET6 address to rpc_sockaddr2uaddr().

Since "struct nfs_mount_data" structure is user-visible, we can't change
"struct nfs_mount_data" to use "struct sockaddr_storage". Therefore,
assuming that everybody is using AF_INET family when passing address via
"struct nfs_mount_data"->addr, reject if its sin_family is not AF_INET.

[1] https://syzkaller.appspot.com/bug?id=599993614e7cbbf66bc2656a919ab2a95fb5d75c

Reported-by: syzbot <syzbot+047a11c361b872896a4f@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2047,7 +2047,8 @@ static int nfs23_validate_mount_data(voi
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen = sizeof(data->addr);
 		args->nfs_server.port = ntohs(data->addr.sin_port);
-		if (!nfs_verify_server_address(sap))
+		if (sap->sa_family != AF_INET ||
+		    !nfs_verify_server_address(sap))
 			goto out_no_address;
 
 		if (!(data->flags & NFS_MOUNT_TCP))


