Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C01B111F26
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfLCWoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfLCWoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F01CE20803;
        Tue,  3 Dec 2019 22:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413076;
        bh=DX3MlaJR24u347KXFwaZUu2joPNmxXCZOAJEq0+M8AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKwgIbk7AQ8ces+yi8Vxl7NJumHYCs7YtmelPmr2qxK9Y9p67UCYsAbk9cbLS1YP+
         5dZB6wsy+y4isLNTgoin72wu4LSwMzuWu43gU3jT6z+/Ki71sn5kj6LHeSUMchcdEx
         37HhMuf+xc3MOy1noJSAP63/WmmqTPKMv+/jqiMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 123/135] net/tls: free the record on encryption error
Date:   Tue,  3 Dec 2019 23:36:03 +0100
Message-Id: <20191203213044.695046895@linuxfoundation.org>
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

[ Upstream commit d10523d0b3d78153ee58d19853ced26c9004c8c4 ]

When tls_do_encryption() fails the SG lists are left with the
SG_END and SG_CHAIN marks in place. One could hope that once
encryption fails we will never see the record again, but that
is in fact not true. Commit d3b18ad31f93 ("tls: add bpf support
to sk_msg handling") added special handling to ENOMEM and ENOSPC
errors which mean we may see the same record re-submitted.

As suggested by John free the record, the BPF code is already
doing just that.

Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -766,8 +766,14 @@ static int bpf_exec_tx_verdict(struct sk
 
 	policy = !(flags & MSG_SENDPAGE_NOPOLICY);
 	psock = sk_psock_get(sk);
-	if (!psock || !policy)
-		return tls_push_record(sk, flags, record_type);
+	if (!psock || !policy) {
+		err = tls_push_record(sk, flags, record_type);
+		if (err) {
+			*copied -= sk_msg_free(sk, msg);
+			tls_free_open_rec(sk);
+		}
+		return err;
+	}
 more_data:
 	enospc = sk_msg_full(msg);
 	if (psock->eval == __SK_NONE) {


