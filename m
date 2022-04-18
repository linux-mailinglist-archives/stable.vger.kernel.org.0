Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0478B5057AA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiDRNz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbiDRNx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:53:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FE945AEE;
        Mon, 18 Apr 2022 06:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2BB3B80D9C;
        Mon, 18 Apr 2022 13:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394D0C385A1;
        Mon, 18 Apr 2022 13:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286961;
        bh=PACYSDL0hP9BWct9PtTZMs8lOn8HGAqoXGmAb94qJnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8FjB6XzVlxvKbzsZtGztZJ4HOseLKQCW9VnYsyXD5kAOMxaUYYK3qm0APl1Edobi
         XLtHLku1+1f4fAf3CguS5LnjHng+YcnXAcvnfh7ecGj3caW707qSu+ikjrBCkaf3E8
         S7G+s8O+tRcI3BL5APoGD5IulNzJJEYNxFfmuv5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.9 016/218] NFSD: prevent underflow in nfssvc_decode_writeargs()
Date:   Mon, 18 Apr 2022 14:11:22 +0200
Message-Id: <20220418121159.538182766@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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
@@ -207,7 +207,7 @@ nfsd_proc_write(struct svc_rqst *rqstp,
 	int	stable = 1;
 	unsigned long cnt = argp->len;
 
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
 	int			vlen;
 };
 


