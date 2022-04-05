Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07DB4F30EE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiDEI7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbiDEIlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85C310E5;
        Tue,  5 Apr 2022 01:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23972B81B13;
        Tue,  5 Apr 2022 08:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83974C385A0;
        Tue,  5 Apr 2022 08:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147643;
        bh=HKZ2APyN8Q6yQ6rOSEX8CU6i+12Lcl92XlYYntOj588=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4v2wpzNUk2N0OmVDb2uvT7bl6Aw+G7YM4PJ7Bc/sZgzTSDojk3a9CVz7VCkwBdWC
         64dIGfn6Q9GZYoCIGTh0xqtCfmD4aO8vTIEM9nHxMCA+Ulg/sDQ6heZ27SHLoftQj3
         HPdQ4Yq5ZDaT5rc4Lf5tXlCZpyeQfEafnx+jUNmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.16 0068/1017] NFSD: prevent underflow in nfssvc_decode_writeargs()
Date:   Tue,  5 Apr 2022 09:16:21 +0200
Message-Id: <20220405070356.207622361@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 184416d4b98509fb4c3d8fc3d6dc1437896cc159 upstream.

Smatch complains:

	fs/nfsd/nfsxdr.c:341 nfssvc_decode_writeargs()
	warn: no lower bound on 'args->len'

Change the type to unsigned to prevent this issue.

Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsproc.c |    2 +-
 fs/nfsd/xdr.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -230,7 +230,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 	unsigned long cnt = argp->len;
 	unsigned int nvecs;
 
-	dprintk("nfsd: WRITE    %s %d bytes at %d\n",
+	dprintk("nfsd: WRITE    %s %u bytes at %d\n",
 		SVCFH_fmt(&argp->fh),
 		argp->len, argp->offset);
 
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -32,7 +32,7 @@ struct nfsd_readargs {
 struct nfsd_writeargs {
 	svc_fh			fh;
 	__u32			offset;
-	int			len;
+	__u32			len;
 	struct xdr_buf		payload;
 };
 


