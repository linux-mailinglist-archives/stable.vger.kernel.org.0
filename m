Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9662B60AC86
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiJXOIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiJXOG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:06:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C25A7229D;
        Mon, 24 Oct 2022 05:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DFC7B817F6;
        Mon, 24 Oct 2022 12:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F1EC433C1;
        Mon, 24 Oct 2022 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614997;
        bh=SemBgwVN8OON6vFrEY8Oc1HWbiubQeH0TdHVV1OIaQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibyWn9MPt692BiYH/UiySlfYo18sAq2lSZT9/Dhu/uMssLJkbTKKYB5Xsk9wJDysi
         AiLpwlY7lx15fg16zeEdzh/lFnzmuXfoO4mtKJaTk/qAJ6ewimN3S/0SAZCGudD1AK
         K/6f80ZY4xAGzr8cEHjqcodxXYMoqfxjwwEgLG/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 065/530] NFSD: Protect against send buffer overflow in NFSv2 READ
Date:   Mon, 24 Oct 2022 13:26:49 +0200
Message-Id: <20221024113047.980213344@linuxfoundation.org>
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

commit 401bc1f90874280a80b93f23be33a0e7e2d1f912 upstream.

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
 fs/nfsd/nfsproc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -182,6 +182,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 		argp->count, argp->offset);
 
 	argp->count = min_t(u32, argp->count, NFSSVC_MAXBLKSIZE_V2);
+	argp->count = min_t(u32, argp->count, rqstp->rq_res.buflen);
 
 	v = 0;
 	len = argp->count;


