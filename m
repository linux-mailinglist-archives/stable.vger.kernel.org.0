Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E637537858C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhEJLAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhEJK4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC81619A4;
        Mon, 10 May 2021 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643534;
        bh=1YN+s86/A3wBK8DclWLxTTZe/V+2+wWyeumguiQT+L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QS/kRxv2z0BnkQlm8Q5+1sAyVCtvBdjxw1EYIu4k0xmTqaplYrCe8wTMtAhGGUw64
         4ynBR1AvR0x5tKm4Y+/QZTIjvAnpIeeyd76iJzoK4bDmELAC6fiAS8zq3e4KyaKi8K
         6jAqaW9+KPOwTDll5rGfc4yvTg+G64f+zhAbsFjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 052/342] cifs: detect dead connections only when echoes are enabled.
Date:   Mon, 10 May 2021 12:17:22 +0200
Message-Id: <20210510102011.845024708@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit f4916649f98e2c7bdba38c6597a98c456c17317d upstream.

We can detect server unresponsiveness only if echoes are enabled.
Echoes can be disabled under two scenarios:
1. The connection is low on credits, so we've disabled echoes/oplocks.
2. The connection has not seen any request till now (other than
negotiate/sess-setup), which is when we enable these two, based on
the credits available.

So this fix will check for dead connection, only when echo is enabled.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
CC: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -488,6 +488,7 @@ server_unresponsive(struct TCP_Server_In
 	 */
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
+	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
 	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
 		cifs_server_dbg(VFS, "has not responded in %lu seconds. Reconnecting...\n",
 			 (3 * server->echo_interval) / HZ);


