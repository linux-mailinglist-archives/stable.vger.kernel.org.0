Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6555076E
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbfFXKHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbfFXKHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:03 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF96217D7;
        Mon, 24 Jun 2019 10:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370822;
        bh=SNyT30zTNR7FIwwROCLH1qOKMHdFefreBa9XQfNA9bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdq/Y54YztCea0OJ29TnMZQChRHyPY02++e61Ujst0SeKxa5zzi9//99ZZejibOfo
         i0EB7p9KDFoOmrdwpFfiGC8A3yvNiMFDErFD2JhLwf50GvZgZ1rdKrc6yTy/pOXO41
         oAI5uh5BZHuq0bK/+MdJTkf37/5B2v45uHPtKjnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 014/121] cifs: fix GlobalMid_Lock bug in cifs_reconnect
Date:   Mon, 24 Jun 2019 17:55:46 +0800
Message-Id: <20190624092321.371392266@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 61cabc7b0a5cf0d3c532cfa96594c801743fe7f6 upstream.

We can not hold the GlobalMid_Lock spinlock during the
dfs processing in cifs_reconnect since it invokes things that may sleep
and thus trigger :

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:23

Thus we need to drop the spinlock during this code block.

RHBZ: 1716743

Cc: stable@vger.kernel.org
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -478,6 +478,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 	spin_lock(&GlobalMid_Lock);
 	server->nr_targets = 1;
 #ifdef CONFIG_CIFS_DFS_UPCALL
+	spin_unlock(&GlobalMid_Lock);
 	cifs_sb = find_super_by_tcp(server);
 	if (IS_ERR(cifs_sb)) {
 		rc = PTR_ERR(cifs_sb);
@@ -495,6 +496,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 	}
 	cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
 		 server->nr_targets);
+	spin_lock(&GlobalMid_Lock);
 #endif
 	if (server->tcpStatus == CifsExiting) {
 		/* the demux thread will exit normally


