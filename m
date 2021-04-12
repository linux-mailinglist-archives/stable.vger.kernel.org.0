Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD035BCF4
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbhDLIq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237809AbhDLIpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E6361263;
        Mon, 12 Apr 2021 08:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217128;
        bh=0kr8QWFvtcZLMgeafwh5vmuEU8lY8MldROstZqTnSk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkOWq4GaSoWQxMIFRyqCCYLriihRgLcmcK8ZbJ4CuFzzMZi7qjQajE/Vl/dfhRZgv
         R447YqAlBEa2zfQIDcW0ZXxHYpduB6FZe69yDkhQiKIL5A1nf44C6EAsmYUP3LadEt
         UwOw6o+8M3iIzg2W1MWuUVGoTRpwTO2tZ3W8IE7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 005/111] nfc: fix refcount leak in llcp_sock_bind()
Date:   Mon, 12 Apr 2021 10:39:43 +0200
Message-Id: <20210412084004.387591294@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit c33b1cc62ac05c1dbb1cdafe2eb66da01c76ca8d upstream.

nfc_llcp_local_get() is invoked in llcp_sock_bind(),
but nfc_llcp_local_put() is not invoked in subsequent failure branches.
As a result, refcount leakage occurs.
To fix it, add calling nfc_llcp_local_put().

fix CVE-2020-25670
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
@@ -108,11 +108,13 @@ static int llcp_sock_bind(struct socket
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
 	if (!llcp_sock->service_name) {
+		nfc_llcp_local_put(llcp_sock->local);
 		ret = -ENOMEM;
 		goto put_dev;
 	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		nfc_llcp_local_put(llcp_sock->local);
 		kfree(llcp_sock->service_name);
 		llcp_sock->service_name = NULL;
 		ret = -EADDRINUSE;


