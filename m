Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5DF35BF2A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbhDLJDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239639AbhDLJA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2E761373;
        Mon, 12 Apr 2021 08:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217930;
        bh=hgbYQ5L79uypRxxIO2S3Vn64L3Vc1hz9tY8Q2ZyH1nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDFTqtHzMI8wtohRG2Xcbp3RCP++JiBVaAJNv+EJOVBYn1sLseeWNqQIBqeXldXne
         dmgsQv1JtbQqCtRoETNpc7AbiXgbMLSLg5MJ8bgKMhL+jBiIOP4S2ImAfhO3LS6m1J
         vQ6vgPrGY2uiNOLzyvklK+eaE0kufu0XQ6RZzu4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 010/210] nfc: Avoid endless loops caused by repeated llcp_sock_connect()
Date:   Mon, 12 Apr 2021 10:38:35 +0200
Message-Id: <20210412084016.350867779@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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


