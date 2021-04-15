Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530C2360D13
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhDOO5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234303AbhDOOzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2479B60FDC;
        Thu, 15 Apr 2021 14:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498413;
        bh=T6bWhoNPayEs0PRL1jqIQDVhJYJXfKfeSQE2ZS4HFyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPBPboFXrH2cX6cqXoaYNr4nYeIqyWXyhnNAZcPt75aKaT7ECukYgd9Csl1l+inHT
         1qWirFMxfqA9KViXKIvIfihaLLqjepjqyECfH7fkhMgze1jIz1bsavKSFGMvTFuxh8
         krkidRWsBaF45tUFtvAmrnTFYheVboyQuC4ahiNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 05/68] nfc: fix memory leak in llcp_sock_connect()
Date:   Thu, 15 Apr 2021 16:46:46 +0200
Message-Id: <20210415144414.634528261@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
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
@@ -758,6 +758,8 @@ sock_unlink:
 	nfc_llcp_local_put(llcp_sock->local);
 
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+	kfree(llcp_sock->service_name);
+	llcp_sock->service_name = NULL;
 
 put_dev:
 	nfc_put_device(dev);


