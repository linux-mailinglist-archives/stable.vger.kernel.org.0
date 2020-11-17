Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630482B641B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbgKQNoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732806AbgKQNkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B38E207BC;
        Tue, 17 Nov 2020 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620408;
        bh=aeWeB7GhISJbMU5/XDoRIlrYHmcH3VZQgdT6UK1SHt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLcMKfyuvZhYVtjqXhEda7n/1f0tYjsAJuiQOntGS4B1bXU7Sxw1sYI85gzCUzipo
         wsm+iuUdd4yN/DG8qbTyQ3YEdD/2FKovaZBAJWPh0yM6IyK3wJyKot51uws57GWqBb
         SIQvSLw3j98hKGw+pGsTrcXEN11QmacnqoJnw+SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.chen.surf@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 208/255] bootconfig: Extend the magic check range to the preceding 3 bytes
Date:   Tue, 17 Nov 2020 14:05:48 +0100
Message-Id: <20201117122149.056573069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 50b8a742850fce7293bed45753152c425f7e931b upstream.

Since Grub may align the size of initrd to 4 if user pass
initrd from cpio, we have to check the preceding 3 bytes as well.

Link: https://lkml.kernel.org/r/160520205132.303174.4876760192433315429.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 85c46b78da58 ("bootconfig: Add bootconfig magic word for indicating bootconfig explicitly")
Reported-by: Chen Yu <yu.chen.surf@gmail.com>
Tested-by: Chen Yu <yu.chen.surf@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/main.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -267,14 +267,24 @@ static void * __init get_boot_config_fro
 	u32 size, csum;
 	char *data;
 	u32 *hdr;
+	int i;
 
 	if (!initrd_end)
 		return NULL;
 
 	data = (char *)initrd_end - BOOTCONFIG_MAGIC_LEN;
-	if (memcmp(data, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN))
-		return NULL;
+	/*
+	 * Since Grub may align the size of initrd to 4, we must
+	 * check the preceding 3 bytes as well.
+	 */
+	for (i = 0; i < 4; i++) {
+		if (!memcmp(data, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN))
+			goto found;
+		data--;
+	}
+	return NULL;
 
+found:
 	hdr = (u32 *)(data - 8);
 	size = hdr[0];
 	csum = hdr[1];


