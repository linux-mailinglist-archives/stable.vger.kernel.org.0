Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBFF35BDBC
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbhDLIxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238137AbhDLIvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:51:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F03861262;
        Mon, 12 Apr 2021 08:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217463;
        bh=9/rmLVtQR0rxgAhWp88SVpj53/FzBRpIMWunlLy8qM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxMiKZ+VL+IOHgCB/hyEAy8Ya4e+ZGPehAamj++DZ1ZAK3lC7kyg3fLKw0TtfNWw3
         m9WrJNgEntN/Shxb8bFyiCIFcem5LyjDINoZsTegGOmterqZNvm/8bFPWGFboO2Fg1
         /DIpQ8lPZo5DUn4BrYthjUD91TJl87l9hF5EFeH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 007/188] nfc: fix refcount leak in llcp_sock_connect()
Date:   Mon, 12 Apr 2021 10:38:41 +0200
Message-Id: <20210412084013.891616232@linuxfoundation.org>
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
@@ -704,6 +704,7 @@ static int llcp_sock_connect(struct sock
 	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		nfc_llcp_local_put(llcp_sock->local);
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -748,6 +749,7 @@ sock_unlink:
 
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+	nfc_llcp_local_put(llcp_sock->local);
 
 put_dev:
 	nfc_put_device(dev);


