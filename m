Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0D5B8D3F
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiINQj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 12:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiINQj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 12:39:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1934EE2A;
        Wed, 14 Sep 2022 09:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 743FFB8188A;
        Wed, 14 Sep 2022 16:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B4DC433D6;
        Wed, 14 Sep 2022 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663173581;
        bh=ZveLLZvJ+Ts6o0HbiWXx2xckAfycFTaLYVEB1OTB1JI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGkulEqu6Y3SXg7eBlpZ8+XKiNwDWdU+lbMHC2JnBrw4vtH/yFmKFbaB7NUcNU7RW
         KqwhV/uM4x17hc40rIciAqM7XuDnBrxUqRPnciG9q5N7pJF9vWFncEAbtDwoixY3j+
         NdDpdBHYZO5bPZmZai1TryUev3jPY2dNB453t0K0m11gRyleFCtf4I74Q0ZZTMdG4D
         KLcM8IUeqi5GLAwoLRV8+jDTIsrGp+GJ7ibwQzD19pjUzZfWRH3oOtbXY11IIHEeTn
         xTrFsJxSu5iWElKLrIh47Pyd295awgvqYEyb3rGi5GUcV3UvYDt/PxVJjrwtk9zgvm
         q0vmAuuQpHOqA==
Date:   Wed, 14 Sep 2022 09:39:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Varsha Teratipally <teratipally@google.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <YyIDzPTn99XLTCFp@magnolia>
References: <20220906183600.1926315-1-teratipally@google.com>
 <20220906183600.1926315-2-teratipally@google.com>
 <YxnWi5YcuY6Rbodt@kroah.com>
 <CAOQ4uxi4UH2pDEe1c6Mn52Qh1GABv2axuQqN=D6QHc7rKwQ2zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi4UH2pDEe1c6Mn52Qh1GABv2axuQqN=D6QHc7rKwQ2zQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 08, 2022 at 03:02:41PM +0300, Amir Goldstein wrote:
> On Thu, Sep 8, 2022 at 2:48 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Sep 06, 2022 at 06:36:00PM +0000, Varsha Teratipally wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > >
> > > XFS always inherits the SGID bit if it is set on the parent inode, while
> > > the generic inode_init_owner does not do this in a few cases where it can
> > > create a possible security problem, see commit 0fa3ecd87848
> > > ("Fix up non-directory creation in SGID directories") for details.
> > >
> > > Switch XFS to use the generic helper for the normal path to fix this,
> > > just keeping the simple field inheritance open coded for the case of the
> > > non-sgid case with the bsdgrpid mount option.
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >
> > Why did you not sign off on this if you are forwarding it on?
> >
> > Also, what is the git id of this commit in Linus's tree (we need that
> > hint...)
> >
> > Please fix both up and resend and get the ack of the stable xfs
> > developers on it as well.
> >
> 
> Varsha,
> 
> FWIW, I re-tested the patch on top of v5.10.141,
> so when re-posting [PATCH 5.10] you may add:
> 
> Tested-by: Amir Goldstein <amir73il@gmail.com>
> 
> Darrick or Christoph,
> 
> Can you please ACK this patch?

With all the bookkeepping bits corrected (and assuming that the VFS
fixes have been or are about to be applied):

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Amir.
