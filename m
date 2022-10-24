Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF160B8F0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiJXT7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiJXT7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB4C22537;
        Mon, 24 Oct 2022 11:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7DE4B81886;
        Mon, 24 Oct 2022 12:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012E6C433D7;
        Mon, 24 Oct 2022 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614968;
        bh=/AcIXoetPdzPf4/uB9B8l2ay+aVrATiWQ9JdhKzLDAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcBfzeTYUQhKve6OeR1UX/h2mKdMVIixCTlcs+Jk251SnGENqKUjaSUdUXmIzgq82
         5pskOUEChk4gHmzZZ+p8oPzygCiU5qSVhG2L6sqnI3w3eCwIBzGJbSub0rZnllCPOE
         kxzUFVdJrLcqPHQBTOm0o8R62kbYGKuSP18LE48E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Ronallo <Benjamin.Ronallo@synopsys.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 064/530] NFSD: Protect against send buffer overflow in NFSv3 READDIR
Date:   Mon, 24 Oct 2022 13:26:48 +0200
Message-Id: <20221024113047.941028770@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 640f87c190e0d1b2a0fcb2ecf6d2cd53b1c41991 upstream.

Since before the git era, NFSD has conserved the number of pages
held by each nfsd thread by combining the RPC receive and send
buffers into a single array of pages. This works because there are
no cases where an operation needs a large RPC Call message and a
large RPC Reply message at the same time.

Once an RPC Call has been received, svc_process() updates
svc_rqst::rq_res to describe the part of rq_pages that can be
used for constructing the Reply. This means that the send buffer
(rq_res) shrinks when the received RPC record containing the RPC
Call is large.

A client can force this shrinkage on TCP by sending a correctly-
formed RPC Call header contained in an RPC record that is
excessively large. The full maximum payload size cannot be
constructed in that case.

Thanks to Aleksi Illikainen and Kari Hulkko for uncovering this
issue.

Reported-by: Ben Ronallo <Benjamin.Ronallo@synopsys.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -447,13 +447,14 @@ static void nfsd3_init_dirlist_pages(str
 {
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
-
-	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
+	unsigned int sendbuf = min_t(unsigned int, rqstp->rq_res.buflen,
+				     svc_max_payload(rqstp));
 
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
-	buf->buflen = count - XDR_UNIT * 2;
+	buf->buflen = clamp(count, (u32)(XDR_UNIT * 2), sendbuf);
+	buf->buflen -= XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page += (buf->buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 


