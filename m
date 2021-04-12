Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A9C35BDC0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbhDLIxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238164AbhDLIvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFDDA61244;
        Mon, 12 Apr 2021 08:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217468;
        bh=hgbYQ5L79uypRxxIO2S3Vn64L3Vc1hz9tY8Q2ZyH1nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8/H3ZWtbqLB8Moto3bcptGOk0mLOaLSTPT2x5UFTuncq6d2xEo1edzrvQ4Kb7kk/
         IdtPutT4u63ZqqoBmcrICGRd3n7RtjSEP+/n8TLyw724xKAfVUSqni4FIFjkE4iElD
         qv1/Mtye5Nb3n8j5sM+P2OAnwqG+KZ9jOkIvPsxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 009/188] nfc: Avoid endless loops caused by repeated llcp_sock_connect()
Date:   Mon, 12 Apr 2021 10:38:43 +0200
Message-Id: <20210412084013.963182573@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit 4b5db93e7f2afbdfe3b78e37879a85290187e6f1 upstream.

When sock_wait_state() returns -EINPROGRESS, "sk->sk_state" is
 LLCP_CONNECTING. In this case, llcp_sock_connect() is repeatedly invoked,
 nfc_llcp_sock_link() will add sk to local->connecting_sockets twice.
 sk->sk_node->next will point to itself, that will make an endless loop
 and hang-up the system.
To fix it, check whether sk->sk_state is LLCP_CONNECTING in
 llcp_sock_connect() to avoid repeated invoking.

Fixes: b4011239a08e ("NFC: llcp: Fix non blocking sockets connections")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
Cc: <stable@vger.kernel.org> #v3.11
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -673,6 +673,10 @@ static int llcp_sock_connect(struct sock
 		ret = -EISCONN;
 		goto error;
 	}
+	if (sk->sk_state == LLCP_CONNECTING) {
+		ret = -EINPROGRESS;
+		goto error;
+	}
 
 	dev = nfc_get_device(addr->dev_idx);
 	if (dev == NULL) {


