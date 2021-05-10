Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50E1378511
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhEJK6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbhEJKx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 624876142D;
        Mon, 10 May 2021 10:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643299;
        bh=XBY718aeLLfgEynBg4op5j+VG2Vw2BF1/Yw7EmWk8g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPSvaPC7u4pEldkMSlmhVKT5qSQ0yoJX/cUxTM9BeiWfKLadyt/xOiWib1jeG7sTu
         9ZLOhFAbuX458tmbUfpkr9GXQ1Fk0JkJI/ufs2iEv7gSLf27ta+X12/wUk4EN2F1N4
         wvkaOR6LCnOrOw9hNyUGH/auGlp089lcRvhJU1Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 259/299] smb3: do not attempt multichannel to server which does not support it
Date:   Mon, 10 May 2021 12:20:56 +0200
Message-Id: <20210510102013.507543604@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
@@ -92,6 +92,12 @@ int cifs_try_adding_channels(struct cifs
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


