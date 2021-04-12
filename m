Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370BD35BC89
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237537AbhDLIni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237523AbhDLInc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DE061243;
        Mon, 12 Apr 2021 08:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618216993;
        bh=wGfmxTQN5cHM5gK33nw1ti9aitJP/n9OXdqcb/De3z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIwbPbZ0BWlgwDoWLbwHp0llWu0WcOkVO873iDq0GQKwCrAy+7A2TPTaArZQ56YuN
         QatfBGWya7o5y9WbaEq/F7AcxmRgRu0N3XCRhky3WPEB/+C6GaXqaKl5TtvbuMYM3X
         73o4gprq2eM8OTG8MFDQShSF+Y2U1KgqLlhH6NdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 03/66] nfc: fix refcount leak in llcp_sock_bind()
Date:   Mon, 12 Apr 2021 10:40:09 +0200
Message-Id: <20210412083958.239120288@linuxfoundation.org>
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
@@ -120,11 +120,13 @@ static int llcp_sock_bind(struct socket
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


