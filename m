Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D06378942
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbhEJL0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235324AbhEJLOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:14:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 226626101E;
        Mon, 10 May 2021 11:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645053;
        bh=DSD6YYvZ0+XAhO+Nujk7EHWrzJzjyk4XXWrkdsUiQv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbe8/cfEibvsL2wB7gwsYPXjS943yycHYzVDRNAE67QqdDprZObZqTzG6SMnXp2sa
         LDimoI4bMLjvZltDeZpnXzJaTBO3ciGNfC9SDZBkhI7k8Oe6W4mjfFaIWF3kJzfegu
         Z3nMtTieucoFGnZGuCxM5KkSRd+GO+1EztlKSshk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 331/384] smb3: do not attempt multichannel to server which does not support it
Date:   Mon, 10 May 2021 12:22:00 +0200
Message-Id: <20210510102025.703417295@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 9c2dc11df50d1c8537075ff6b98472198e24438e upstream.

We were ignoring CAP_MULTI_CHANNEL in the server response - if the
server doesn't support multichannel we should not be attempting it.

See MS-SMB2 section 3.2.5.2

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-By: Tom Talpey <tom@talpey.com>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -97,6 +97,12 @@ int cifs_try_adding_channels(struct cifs
 		return 0;
 	}
 
+	if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		cifs_dbg(VFS, "server %s does not support multichannel\n", ses->server->hostname);
+		ses->chan_max = 1;
+		return 0;
+	}
+
 	/*
 	 * Make a copy of the iface list at the time and use that
 	 * instead so as to not hold the iface spinlock for opening


