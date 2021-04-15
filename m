Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D006360CAE
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhDOOxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234072AbhDOOvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2321613BB;
        Thu, 15 Apr 2021 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498285;
        bh=rKs7XCrUW6sXmV4U4qBajC/vDGRR/PNicC23f4ay+QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkimSMeYcU/Qgg/xcKbnNdXJeYjfd8Jy7D9aUFNbs2DBeAwbvAlQq4A0s0An6ABTM
         hmWaaFcI5/ayNp3soisq4Q6M3ABauVTPrNOypEd+AUugoRzTHS8CHPCW4OVCBhhyLL
         AbFW1uXv/cQlmvgWfG+4XbA+RHNw13858/EQVTts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 05/47] nfc: fix refcount leak in llcp_sock_bind()
Date:   Thu, 15 Apr 2021 16:46:57 +0200
Message-Id: <20210415144413.652529355@linuxfoundation.org>
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
@@ -119,11 +119,13 @@ static int llcp_sock_bind(struct socket
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


