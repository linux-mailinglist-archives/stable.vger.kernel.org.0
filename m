Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208181CAFE5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgEHNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728667AbgEHMkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B33EC24968;
        Fri,  8 May 2020 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941613;
        bh=/mYlckhND+F8kcom9qxYJclgey5dvTSPeJ/PIyGaRqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhXN80fuGdCbHp+zaSnnB7uUPT/2ycXZyGt4KPQfhdP6uyIJQJ5gxUGm5fEYbQxhN
         MNj2uva23KYxexDAnixI0cc18XxUvvbjFg6/3bZdxhyI00QQPSx0TO5U70rdRwj6F6
         vyvvEgGjRj1Ap/9FAg/FSwVmcFQdeEcZKYAl3Dyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.4 100/312] xprtrdma: checking for NULL instead of IS_ERR()
Date:   Fri,  8 May 2020 14:31:31 +0200
Message-Id: <20200508123131.557610584@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit abfb689711aaebd14d893236c6ea4bcdfb61e74c upstream.

The rpcrdma_create_req() function returns error pointers or success.  It
never returns NULL.

Fixes: f531a5dbc451 ('xprtrdma: Pre-allocate backward rpc_rqst and send/receive buffers')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/backchannel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -42,8 +42,8 @@ static int rpcrdma_bc_setup_rqst(struct
 	size_t size;
 
 	req = rpcrdma_create_req(r_xprt);
-	if (!req)
-		return -ENOMEM;
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 	req->rl_backchannel = true;
 
 	size = RPCRDMA_INLINE_WRITE_THRESHOLD(rqst);


