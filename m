Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4EF111F78
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfLCXJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfLCWof (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8255E207DD;
        Tue,  3 Dec 2019 22:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413074;
        bh=X0xSGi6xT4B5606Mrh/tfrSpMoE/QoK7hRlEwjUTq+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBDh2HfMjFxqwPksL14wQMyh5Iw9Gn2fevVdabjz/gGh4dmXc+3h+QgOzd/nwA9fZ
         jQgfe2EHT07DZUYA6B3hJZIoOjYm43x+cX7/CFhvPqQQ7i+6kxE3rlak93hgQFGAm8
         4diP0eyz0qxFR6MFOYkjryKwRQuXzXEkgv1Dm7ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 122/135] net/tls: take into account that bpf_exec_tx_verdict() may free the record
Date:   Tue,  3 Dec 2019 23:36:02 +0100
Message-Id: <20191203213044.443548621@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit c329ef9684de9517d82af5b4758c9e1b64a8a11a ]

bpf_exec_tx_verdict() may free the record if tls_push_record()
fails, or if the entire record got consumed by BPF. Re-check
ctx->open_rec before touching the data.

Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -979,7 +979,7 @@ alloc_encrypted:
 					num_async++;
 				else if (ret == -ENOMEM)
 					goto wait_for_memory;
-				else if (ret == -ENOSPC)
+				else if (ctx->open_rec && ret == -ENOSPC)
 					goto rollback_iter;
 				else if (ret != -EAGAIN)
 					goto send_end;
@@ -1048,11 +1048,12 @@ wait_for_memory:
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret) {
 trim_sgl:
-			tls_trim_both_msgs(sk, orig_size);
+			if (ctx->open_rec)
+				tls_trim_both_msgs(sk, orig_size);
 			goto send_end;
 		}
 
-		if (msg_en->sg.size < required_size)
+		if (ctx->open_rec && msg_en->sg.size < required_size)
 			goto alloc_encrypted;
 	}
 
@@ -1185,11 +1186,13 @@ wait_for_sndbuf:
 wait_for_memory:
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret) {
-			tls_trim_both_msgs(sk, msg_pl->sg.size);
+			if (ctx->open_rec)
+				tls_trim_both_msgs(sk, msg_pl->sg.size);
 			goto sendpage_end;
 		}
 
-		goto alloc_payload;
+		if (ctx->open_rec)
+			goto alloc_payload;
 	}
 
 	if (num_async) {


