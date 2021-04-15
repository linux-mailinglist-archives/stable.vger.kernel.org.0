Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26AC360C59
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhDOOuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233806AbhDOOuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86F47613A9;
        Thu, 15 Apr 2021 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498180;
        bh=XAJg5YMWizKBSURekwDC2oe3p4LgBGSmgSOIz2GMYcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/0VA9KLvooEm3bjBqtwawUBfHHFvNfxAhs6+Q3sBYynhbt6azsFpLNGWBH+t1Oq+
         0NYN6EEG4/Hdjbu/V6l0jyE89gKK92lCdPkI55+yZja64ZjL6Yac1eKyiWfdvAusJf
         XAQHu7hTBQQ40JjQavRuibA/eh96U0ZJ57YBx7TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 06/38] nfc: Avoid endless loops caused by repeated llcp_sock_connect()
Date:   Thu, 15 Apr 2021 16:47:00 +0200
Message-Id: <20210415144413.559348852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
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
@@ -679,6 +679,10 @@ static int llcp_sock_connect(struct sock
 		ret = -EISCONN;
 		goto error;
 	}
+	if (sk->sk_state == LLCP_CONNECTING) {
+		ret = -EINPROGRESS;
+		goto error;
+	}
 
 	dev = nfc_get_device(addr->dev_idx);
 	if (dev == NULL) {


