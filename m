Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6905E558255
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiFWRNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiFWRMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AC226139;
        Thu, 23 Jun 2022 09:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD3C9B8248A;
        Thu, 23 Jun 2022 16:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E578DC3411B;
        Thu, 23 Jun 2022 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003488;
        bh=+XWr3PnDyJZMzZIi8Bb+yDWvvAjGFGsoYV1mRzJaXVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0VyvENjKK+gxXEQXphSXzftD/jEK8Xm4o6/cWST/Ok4lQhp1Cc/KQnuGhw3MLgWA
         lXLBcnd/IPg846kVnuyZjdal8w4J5k6mF1w+pKNaw7tCcXpLgGotMtqRsAF6LsaIyC
         HoOt+XMjCYi1+MQTwmBwXbbislRY0uxPG0g+ZQ88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 253/264] xprtrdma: fix incorrect header size calculations
Date:   Thu, 23 Jun 2022 18:44:06 +0200
Message-Id: <20220623164351.224935058@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -75,7 +75,7 @@ static unsigned int rpcrdma_max_call_hea
 
 	/* Maximum Read list size */
 	maxsegs += 2;	/* segment for head and tail buffers */
-	size = maxsegs * sizeof(struct rpcrdma_read_chunk);
+	size += maxsegs * sizeof(struct rpcrdma_read_chunk);
 
 	/* Minimal Read chunk size */
 	size += sizeof(__be32);	/* segment count */
@@ -101,7 +101,7 @@ static unsigned int rpcrdma_max_reply_he
 
 	/* Maximum Write list size */
 	maxsegs += 2;	/* segment for head and tail buffers */
-	size = sizeof(__be32);		/* segment count */
+	size += sizeof(__be32);		/* segment count */
 	size += maxsegs * sizeof(struct rpcrdma_segment);
 	size += sizeof(__be32);	/* list discriminator */
 


