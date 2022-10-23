Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D7960927B
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJWLi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 07:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJWLiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 07:38:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2297434A;
        Sun, 23 Oct 2022 04:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD5E60B55;
        Sun, 23 Oct 2022 11:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A22C433D6;
        Sun, 23 Oct 2022 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666525104;
        bh=M6HXpQhc0LgopSmchjDdBJF0+nlmGhCmgJ1jyMgGHwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUKxC0lMVPylJ3weuY1GQj+BI9Ykq5TAcV3TyoHwttVpHUg9+GLfz2SWrMjaiD2Uq
         jfaNesUy5mSEw9/uKsXV2Kptggigckotkw8NlMNu9zGofAyxfqyxr1q45VEFmqggoS
         Qtk8YM+pjPukKIL7mLXd+LcE1bIyEIwu23PeBq8A=
Date:   Sun, 23 Oct 2022 13:38:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 554/717] NFSD: Return nfserr_serverfault if
 splice_ok but buf->pages have data
Message-ID: <Y1UnrINKthRQu8R5@kroah.com>
References: <20221022072415.034382448@linuxfoundation.org>
 <20221022072522.883630640@linuxfoundation.org>
 <E22D29B2-5740-46E7-9A4A-52BAE214FDA1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E22D29B2-5740-46E7-9A4A-52BAE214FDA1@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 22, 2022 at 02:46:35PM +0000, Chuck Lever III wrote:
> 
> 
> > On Oct 22, 2022, at 3:27 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > From: Anna Schumaker <Anna.Schumaker@Netapp.com>
> > 
> > [ Upstream commit 06981d560606ac48d61e5f4fff6738b925c93173 ]
> > 
> > This was discussed with Chuck as part of this patch set. Returning
> > nfserr_resource was decided to not be the best error message here, and
> > he suggested changing to nfserr_serverfault instead.
> > 
> > Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> > Link: https://lore.kernel.org/linux-nfs/20220907195259.926736-1-anna@kernel.org/T/#t
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> > fs/nfsd/nfs4xdr.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> > index eef98e3f4ae5..1e5822d00043 100644
> > --- a/fs/nfsd/nfs4xdr.c
> > +++ b/fs/nfsd/nfs4xdr.c
> > @@ -3995,7 +3995,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
> > 	if (resp->xdr->buf->page_len &&
> > 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
> > 		WARN_ON_ONCE(1);
> > -		return nfserr_resource;
> > +		return nfserr_serverfault;
> > 	}
> > 	xdr_commit_encode(xdr);
> 
> Why is this change to be included in stable kernels?

Is it not a valid bugfix?  If so, I will be glad to drop it, but in
reading the changelog text and the code change itself, it seems like a
valid fix to be backporting to stable kernels.

thanks,

greg k-h
