Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A09F35BC8B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbhDLInm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237506AbhDLIne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4591861245;
        Mon, 12 Apr 2021 08:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618216995;
        bh=oFAqnnUADnTEWjykGov1rmLc69VHpj5dRjoLHjvP8p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOFuP5Y/lsNOF2WFoLwlrQ9GyivLtVv9wRynjSNe79/tYJcstRgP7xBC1tU2mz9Sh
         jap7vRDCUuxBuqzVZFGbVYWa3l3C8LTPsADwMDbbYyw7V4vJ0GUy8tAF4bc6H0BH4a
         kwleDfNT9V8zU0WZpfPpLBSgQqkGkMxYozOErYzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 04/66] nfc: fix refcount leak in llcp_sock_connect()
Date:   Mon, 12 Apr 2021 10:40:10 +0200
Message-Id: <20210412083958.277993168@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit 8a4cd82d62b5ec7e5482333a72b58a4eea4979f0 upstream.

nfc_llcp_local_get() is invoked in llcp_sock_connect(),
but nfc_llcp_local_put() is not invoked in subsequent failure branches.
As a result, refcount leakage occurs.
To fix it, add calling nfc_llcp_local_put().

fix CVE-2020-25671
Fixes: c7aa12252f51 ("NFC: Take a reference on the LLCP local pointer when creating a socket")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
Cc: <stable@vger.kernel.org> #v3.6
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -716,6 +716,7 @@ static int llcp_sock_connect(struct sock
 	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		nfc_llcp_local_put(llcp_sock->local);
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -753,6 +754,7 @@ static int llcp_sock_connect(struct sock
 
 sock_unlink:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+	nfc_llcp_local_put(llcp_sock->local);
 
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 


