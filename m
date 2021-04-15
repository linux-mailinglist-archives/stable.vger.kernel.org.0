Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE391360CB2
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhDOOxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhDOOvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EE4613CE;
        Thu, 15 Apr 2021 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498290;
        bh=fS+acfzHDpcFBoB9lxUE8LdI66SI5ldM2rL2MT5kA+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVVwpYIf4wxBt1IV3jYB5l0S3alyAvlxQi5/bGalBP5zi6a7nWuMp9+YzafB21vPt
         VaGxmPggFhblqdyAGng28mB8iKKDdjcSXf7Cx4W4DxPAhNnM133cpe5j8mlBMWt9ku
         uVM4SzkZ685jxNCDaQokN2UR6kd1fduFvJaMG1N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 07/47] nfc: fix memory leak in llcp_sock_connect()
Date:   Thu, 15 Apr 2021 16:46:59 +0200
Message-Id: <20210415144413.716748940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit 7574fcdbdcb335763b6b322f6928dc0fd5730451 upstream.

In llcp_sock_connect(), use kmemdup to allocate memory for
 "llcp_sock->service_name". The memory is not released in the sock_unlink
label of the subsequent failure branch.
As a result, memory leakage occurs.

fix CVE-2020-25672

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
Cc: <stable@vger.kernel.org> #v3.3
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -757,6 +757,8 @@ sock_unlink:
 	nfc_llcp_local_put(llcp_sock->local);
 
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+	kfree(llcp_sock->service_name);
+	llcp_sock->service_name = NULL;
 
 put_dev:
 	nfc_put_device(dev);


