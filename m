Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21F75586EF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbiFWSSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbiFWSR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243B31BEA4;
        Thu, 23 Jun 2022 10:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEE8A61EE5;
        Thu, 23 Jun 2022 17:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87081C341C4;
        Thu, 23 Jun 2022 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005022;
        bh=eVK8vlGSvvQndlAiBX0xjJxVD2cAGmDzUQkJP/Po380=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN8XDIUSIjDdKzFKuJkDAX2XKfTOFwZkHSK/wA5/80OjQFkb6VrjqfYM9kh6S1COy
         Gy2cSZ5EpctqQfk4HGHg1mLp4rrEf/454GUFjgZqdZHYxzGXTHlGKIMuGB+XdbVhDZ
         5732MpV/uFln4XXLPDoHOLcdmpWuQolLljF3wUjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 227/234] xprtrdma: fix incorrect header size calculations
Date:   Thu, 23 Jun 2022 18:44:54 +0200
Message-Id: <20220623164349.473012104@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 912288442cb2f431bf3c8cb097a5de83bc6dbac1 upstream.

Currently the header size calculations are using an assignment
operator instead of a += operator when accumulating the header
size leading to incorrect sizes.  Fix this by using the correct
operator.

Addresses-Coverity: ("Unused value")
Fixes: 302d3deb2068 ("xprtrdma: Prevent inline overflow")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
[bwh: Backported to 4.19: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -72,7 +72,7 @@ static unsigned int rpcrdma_max_call_hea
 
 	/* Maximum Read list size */
 	maxsegs += 2;	/* segment for head and tail buffers */
-	size = maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
+	size += maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
 
 	/* Minimal Read chunk size */
 	size += sizeof(__be32);	/* segment count */
@@ -98,7 +98,7 @@ static unsigned int rpcrdma_max_reply_he
 
 	/* Maximum Write list size */
 	maxsegs += 2;	/* segment for head and tail buffers */
-	size = sizeof(__be32);		/* segment count */
+	size += sizeof(__be32);		/* segment count */
 	size += maxsegs * rpcrdma_segment_maxsz * sizeof(__be32);
 	size += sizeof(__be32);	/* list discriminator */
 


