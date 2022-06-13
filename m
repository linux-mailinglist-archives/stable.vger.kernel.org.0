Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B9254811D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbiFMH6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239477AbiFMH61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBC82622
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B5D761016
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4FAC34114;
        Mon, 13 Jun 2022 07:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655107103;
        bh=c2BctJSlNeIaToxp09KtxqMpkqz13tGJlkLG924B4MA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GXMtBBLh/uXZ+7y36xigj1EgUwTEWrILOoCpgQnAlJQoTbNIlDQLXPmieuXL0cnyS
         8TjGf8BqEpJP6hD0xz7wix4ZJsixv7PPnxdMvzKaVhMj+Gor5JhrcDbtab59N5dhW0
         gThEdOEGQ1H1wyAycgmjr69foWvAV1Hc5gXxjHo0=
Date:   Mon, 13 Jun 2022 09:58:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 5.10] nfsd: Replace use of rwsem with errseq_t
Message-ID: <YqbuHTLVgIIzPkC6@kroah.com>
References: <20220607201036.4018806-1-lrumancik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607201036.4018806-1-lrumancik@google.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 01:10:36PM -0700, Leah Rumancik wrote:
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> 
> [ Upstream commit 555dbf1a9aac6d3150c8b52fa35f768a692f4eeb ]
> 
> The nfsd_file nf_rwsem is currently being used to separate file write
> and commit instances to ensure that we catch errors and apply them to
> the correct write/commit.
> We can improve scalability at the expense of a little accuracy (some
> extra false positives) by replacing the nf_rwsem with more careful
> use of the errseq_t mechanism to track errors across the different
> operations.
> 
> [Leah: This patch is for 5.10. 5011af4c698a ("nfsd: Fix stable writes")
> introduced a 75% performance regression on parallel random write
> workloads. With this commit, the performance is restored to 90% of what
> it was prior to 5011af4c698a. The changes to the fsync for asynchronous
> copies were not included in this backport version as the fsync was not
> added until 5.14 (eac0b17a77fb).]
> 
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> [ cel: rebased on zero-verifier fix ]
> ---
>  fs/nfsd/filecache.c |  1 -
>  fs/nfsd/filecache.h |  1 -
>  fs/nfsd/nfs4proc.c  |  7 ++++---
>  fs/nfsd/vfs.c       | 40 +++++++++++++++-------------------------
>  4 files changed, 19 insertions(+), 30 deletions(-)

What about 5.15?  We can't take this patch for 5.10 only as if you
upgrade to 5.15 you would have a regression.  Can you provide a version
for that tree so that I can then apply this one too?

thanks,

greg k-h
