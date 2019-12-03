Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E519D111BE5
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfLCWiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfLCWiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFE720862;
        Tue,  3 Dec 2019 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412698;
        bh=X0xSGi6xT4B5606Mrh/tfrSpMoE/QoK7hRlEwjUTq+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTGhNi0q/HIFNYvcd6jPm3l/9+3gC2dhft5MkXFwMkZqA9lmJ+GcDMJAijLRpxe13
         beUDjg/yIQpG7+EecGSVb7V9sOSRgDOU+F6+hozPKdKqFttfzs8yS0d4kCFIRmyhbx
         OjA3f7CG9/OhIVHvk5XHGj9/f6pap62pi5B7IFqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 29/46] net/tls: take into account that bpf_exec_tx_verdict() may free the record
Date:   Tue,  3 Dec 2019 23:35:49 +0100
Message-Id: <20191203212744.480975788@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
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


