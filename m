Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF141FB773
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbgFPPqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbgFPPqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F5C72071A;
        Tue, 16 Jun 2020 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322378;
        bh=H2+Cp8gjTj/jO87CDcmTBryoXX5RnUkQjR6CJ67DnkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbcvxLudGEwSL7EMwNp8XU+14xNv9rnE62PhIJEIIx0CKcBw8s66S1qyOR6uJ7Rdw
         yEQjOMbPD3MVgL9A8RIl26NX03gVBjcKLP7XW8p/39O9fs0iPT/4wpHgOM7BCgxDW+
         kOau2yI2aW1RI72WWzuzh9tFqhsflepS9uL+NRc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 108/163] mptcp: dont leak msk in token container
Date:   Tue, 16 Jun 2020 17:34:42 +0200
Message-Id: <20200616153111.982041311@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 4b5af44129d0653a4df44e5511c7d480c61c8f3c ]

If a listening MPTCP socket has unaccepted sockets at close
time, the related msks are freed via mptcp_sock_destruct(),
which in turn does not invoke the proto->destroy() method
nor the mptcp_token_destroy() function.

Due to the above, the child msk socket is not removed from
the token container, leading to later UaF.

Address the issue explicitly removing the token even in the
above error path.

Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -393,6 +393,7 @@ static void mptcp_sock_destruct(struct s
 		sock_orphan(sk);
 	}
 
+	mptcp_token_destroy(mptcp_sk(sk)->token);
 	inet_sock_destruct(sk);
 }
 


