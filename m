Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EF935BC8D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhDLInn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237526AbhDLIng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE3960241;
        Mon, 12 Apr 2021 08:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618216998;
        bh=fS+acfzHDpcFBoB9lxUE8LdI66SI5ldM2rL2MT5kA+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDoub3OEmWO77jPf+up7G4v1gQ11llt5yBeTRE8KvJajfoLKenCHweWqeMZzjkF4B
         q+QYgfcKnOjrUMEyc94bof57ZPKsMKXPniZYR1E+mAOVoY3XRRRa52IHCwXDPwRlgP
         WmNmt6Kcz/UbWNmoEdJmeZa3pzHOafun3vC4LAQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/66] nfc: fix memory leak in llcp_sock_connect()
Date:   Mon, 12 Apr 2021 10:40:11 +0200
Message-Id: <20210412083958.309423620@linuxfoundation.org>
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


