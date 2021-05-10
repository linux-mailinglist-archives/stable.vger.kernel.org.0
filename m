Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB50237874A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237410AbhEJLO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236265AbhEJLHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C12861956;
        Mon, 10 May 2021 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644368;
        bh=1YN+s86/A3wBK8DclWLxTTZe/V+2+wWyeumguiQT+L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLL1pWKPl11ucQdAQM+a98mastJVWwqwLwItCA97adh/AfD0obFyGp08MyHKhK8AI
         g4kDgKRIWwq4uGLmuWOM3vyn+7rmoY+Dz3XIzQ0qBNMgAGQAJnWl0S75ZGPv9qGAYP
         IEKVRPdLXCsG8wFpwhS1KXsN097NqYXSXnx05TEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 054/384] cifs: detect dead connections only when echoes are enabled.
Date:   Mon, 10 May 2021 12:17:23 +0200
Message-Id: <20210510102016.657301445@linuxfoundation.org>
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


