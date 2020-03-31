Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA98199050
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbgCaJK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbgCaJKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:10:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D6120787;
        Tue, 31 Mar 2020 09:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645854;
        bh=QBRWgqCrNTqkqSiXzSZqGwRGdI6o65xRYc1R9QeALGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Yen5+R9wykkufjX6Fmmisstmh1HrxhyclnRV0QgJJCTYmgwIav+GhV1/9tg+cD0r
         k+z4hhy8nQkRdlWVQjz612bcP24fY8EEGKJ53TuPJ2PXaUO0FYag+9j26fiNOZozvd
         WwiINhGtYwJX5cnvyzkz7z4bCPiSxeuDF9w9HNPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Meneguele <bmeneg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 015/155] net/bpfilter: fix dprintf usage for /dev/kmsg
Date:   Tue, 31 Mar 2020 10:57:35 +0200
Message-Id: <20200331085420.091785566@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruno Meneguele <bmeneg@redhat.com>

[ Upstream commit 13d0f7b814d9b4c67e60d8c2820c86ea181e7d99 ]

The bpfilter UMH code was recently changed to log its informative messages to
/dev/kmsg, however this interface doesn't support SEEK_CUR yet, used by
dprintf(). As result dprintf() returns -EINVAL and doesn't log anything.

However there already had some discussions about supporting SEEK_CUR into
/dev/kmsg interface in the past it wasn't concluded. Since the only user of
that from userspace perspective inside the kernel is the bpfilter UMH
(userspace) module it's better to correct it here instead waiting a conclusion
on the interface.

Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpfilter/main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -10,7 +10,7 @@
 #include <asm/unistd.h>
 #include "msgfmt.h"
 
-int debug_fd;
+FILE *debug_f;
 
 static int handle_get_cmd(struct mbox_request *cmd)
 {
@@ -35,9 +35,10 @@ static void loop(void)
 		struct mbox_reply reply;
 		int n;
 
+		fprintf(debug_f, "testing the buffer\n");
 		n = read(0, &req, sizeof(req));
 		if (n != sizeof(req)) {
-			dprintf(debug_fd, "invalid request %d\n", n);
+			fprintf(debug_f, "invalid request %d\n", n);
 			return;
 		}
 
@@ -47,7 +48,7 @@ static void loop(void)
 
 		n = write(1, &reply, sizeof(reply));
 		if (n != sizeof(reply)) {
-			dprintf(debug_fd, "reply failed %d\n", n);
+			fprintf(debug_f, "reply failed %d\n", n);
 			return;
 		}
 	}
@@ -55,9 +56,10 @@ static void loop(void)
 
 int main(void)
 {
-	debug_fd = open("/dev/kmsg", 00000002);
-	dprintf(debug_fd, "Started bpfilter\n");
+	debug_f = fopen("/dev/kmsg", "w");
+	setvbuf(debug_f, 0, _IOLBF, 0);
+	fprintf(debug_f, "Started bpfilter\n");
 	loop();
-	close(debug_fd);
+	fclose(debug_f);
 	return 0;
 }


