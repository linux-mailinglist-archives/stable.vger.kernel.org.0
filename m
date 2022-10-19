Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366436042F1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiJSLMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiJSLLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:11:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE90C15383F;
        Wed, 19 Oct 2022 03:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C519DB822E0;
        Wed, 19 Oct 2022 08:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2E3C433D6;
        Wed, 19 Oct 2022 08:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168923;
        bh=3fmz19ziBoeqOLteTXpvy4wRMaFIWZi67aTh2vCakBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9AgSY9gAKiqr3BN6qRQyfK9KKonGIJxeyqcI0WdURpBK1fbUnuVB06TlC/lGiQ9m
         9E4syEfPHGNycXF/4VAzIELsfdOMwVhsZXIVY0NLGWdM/hSvQPrw+7BXzRkjAp44cI
         IXZIyBwNiupiDDe+ubIAWFuBZFoRO64HoVmHTq6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.0 098/862] NFSD: Protect against send buffer overflow in NFSv3 READ
Date:   Wed, 19 Oct 2022 10:23:05 +0200
Message-Id: <20221019083254.250027544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit fa6be9cc6e80ec79892ddf08a8c10cabab9baf38 upstream.

Since before the git era, NFSD has conserved the number of pages
held by each nfsd thread by combining the RPC receive and send
buffers into a single array of pages. This works because there are
no cases where an operation needs a large RPC Call message and a
large RPC Reply at the same time.

Once an RPC Call has been received, svc_process() updates
svc_rqst::rq_res to describe the part of rq_pages that can be
used for constructing the Reply. This means that the send buffer
(rq_res) shrinks when the received RPC record containing the RPC
Call is large.

A client can force this shrinkage on TCP by sending a correctly-
formed RPC Call header contained in an RPC record that is
excessively large. The full maximum payload size cannot be
constructed in that case.

Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -150,7 +150,6 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 {
 	struct nfsd3_readargs *argp = rqstp->rq_argp;
 	struct nfsd3_readres *resp = rqstp->rq_resp;
-	u32 max_blocksize = svc_max_payload(rqstp);
 	unsigned int len;
 	int v;
 
@@ -159,7 +158,8 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 				(unsigned long) argp->count,
 				(unsigned long long) argp->offset);
 
-	argp->count = min_t(u32, argp->count, max_blocksize);
+	argp->count = min_t(u32, argp->count, svc_max_payload(rqstp));
+	argp->count = min_t(u32, argp->count, rqstp->rq_res.buflen);
 	if (argp->offset > (u64)OFFSET_MAX)
 		argp->offset = (u64)OFFSET_MAX;
 	if (argp->offset + argp->count > (u64)OFFSET_MAX)


