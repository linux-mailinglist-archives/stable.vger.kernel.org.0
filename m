Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4BE4FD047
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350604AbiDLGrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351639AbiDLGp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:45:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5D93B3D1;
        Mon, 11 Apr 2022 23:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85D32B818C8;
        Tue, 12 Apr 2022 06:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00442C385A1;
        Tue, 12 Apr 2022 06:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745533;
        bh=LD7zo3JOG/9bqZLh81Kty32eCuIvJR5j5cUU2/FODlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfIHzvok5Eli7li//fYiYopIndysg8pQmjsNLGe3wd3QIlUf7RallJmd3OqJq/7Ch
         fPWb3RjbNchNrGtXcfOg0OmhCKpWhftTeQuqr3BnSG0H/wRp1gmQjYpSBK3DUtOIBo
         TXxcuXVObi4EUsCIW3AIJutjYMDz6R8mx4WZgl6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/171] SUNRPC: svc_tcp_sendmsg() should handle errors from xdr_alloc_bvec()
Date:   Tue, 12 Apr 2022 08:30:20 +0200
Message-Id: <20220412062931.617708057@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b056fa070814897be32d83b079dbc311375588e7 ]

The allocation is done with GFP_KERNEL, but it could still fail in a low
memory situation.

Fixes: 4a85a6a3320b ("SUNRPC: Handle TCP socket sends with kernel_sendpage() again")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index eba1714bf09a..6d5bb8bfed38 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1091,7 +1091,9 @@ static int svc_tcp_sendmsg(struct socket *sock, struct msghdr *msg,
 	int flags, ret;
 
 	*sentp = 0;
-	xdr_alloc_bvec(xdr, GFP_KERNEL);
+	ret = xdr_alloc_bvec(xdr, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
 	msg->msg_flags = MSG_MORE;
 	ret = kernel_sendmsg(sock, msg, &rm, 1, rm.iov_len);
-- 
2.35.1



