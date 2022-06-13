Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A50454A2E6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiFMXqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiFMXqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:46:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC3432EDA
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 16:46:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i1so6391169plg.7
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 16:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NWnp6jh4IkeAqpnKZ+lfODjxLkR8xXkYDCufUeozcMI=;
        b=l2DgFOPVzpt8vqockhiGQHR/UbEeui3SEsQbSBLVLtvFzGUiPGtkTJm85IAAu8ONoP
         0Z4f35MP8HX8R9bXQ/3/aYtTp8duKv/T6/NZQse15JJAngo0LX0847p6JZ/6if3l5CHp
         IoC+5TmdJo+tc6cgliypMPvClGUuz8yUn2DJYy22/p1bADFOIsL0tKdVv8v9H2vBL5/r
         dk4wnu0/Vq+F9jusk4UkzW25GZztady4FRc7k86qsluZd8j7nwoFKDeauWVDii3kBd14
         dTxScss2Tnsg9WczeZYQ8VWJUS44kACP3xqJqgCFIip8zxFzANhPJZUEfMIw69QEzHSS
         AP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NWnp6jh4IkeAqpnKZ+lfODjxLkR8xXkYDCufUeozcMI=;
        b=KPAY3+xz76XCWGYIqYXF3LdiAfLsZRLMySP2NSlqQavUoV0LzWUid6qW2CE/D8gs2U
         CLFZxOBkA2n6bNfND4Rwy2itZK6nU6KU3NNTfmT0UHrB3jtCg4/biwtdwlXozataLDT6
         hulfL1OMSXCbnrnlY+k6VZH3dQZH+A5DeB3SeP6PzGjq5PtUW35FdR4TYqFl05lXOKfe
         9y4cUb3Akt5InvYXCDalCQu83H7Zzdnjito/dcejX22LYA3xJrglZrAPoTg+SqBwKj6G
         GM22QwIUBXAoKjxBAlPVN9fwD/STYR9+XxUv6OnGs5F34cEnD/qgARD3Mw7S+iuwApsw
         v6cw==
X-Gm-Message-State: AJIora9qpvRjHMsmEW5yilL0n1zNIsQZdeN+dYTeUOxfgLyhw2eapzB7
        1iHewulLOQz2EDs3WIhx21ykrH4iXJrtIg==
X-Google-Smtp-Source: AGRyM1tESuQl21EJGN6Enph7gVp+8hZ47yjVXCGk44Bhabnu+aVDef7NGQ9dn8uLA4wZuYzAgVso8w==
X-Received: by 2002:a17:90b:1809:b0:1e8:7495:3c6d with SMTP id lw9-20020a17090b180900b001e874953c6dmr1277920pjb.193.1655164009353;
        Mon, 13 Jun 2022 16:46:49 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:2423:f4b7:238e:d393])
        by smtp.gmail.com with ESMTPSA id x25-20020a62fb19000000b005183cf12184sm5944112pfm.133.2022.06.13.16.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:46:49 -0700 (PDT)
Date:   Mon, 13 Jun 2022 16:46:47 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 5.10] nfsd: Replace use of rwsem with errseq_t
Message-ID: <YqfMZ7ltC2+9IJmp@google.com>
References: <20220607201036.4018806-1-lrumancik@google.com>
 <YqbuHTLVgIIzPkC6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqbuHTLVgIIzPkC6@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 09:58:21AM +0200, Greg KH wrote:
> On Tue, Jun 07, 2022 at 01:10:36PM -0700, Leah Rumancik wrote:
> > From: Trond Myklebust <trond.myklebust@hammerspace.com>
> > 
> > [ Upstream commit 555dbf1a9aac6d3150c8b52fa35f768a692f4eeb ]
> > 
> > The nfsd_file nf_rwsem is currently being used to separate file write
> > and commit instances to ensure that we catch errors and apply them to
> > the correct write/commit.
> > We can improve scalability at the expense of a little accuracy (some
> > extra false positives) by replacing the nf_rwsem with more careful
> > use of the errseq_t mechanism to track errors across the different
> > operations.
> > 
> > [Leah: This patch is for 5.10. 5011af4c698a ("nfsd: Fix stable writes")
> > introduced a 75% performance regression on parallel random write
> > workloads. With this commit, the performance is restored to 90% of what
> > it was prior to 5011af4c698a. The changes to the fsync for asynchronous
> > copies were not included in this backport version as the fsync was not
> > added until 5.14 (eac0b17a77fb).]
> > 
> > Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> > [ cel: rebased on zero-verifier fix ]
> > ---
> >  fs/nfsd/filecache.c |  1 -
> >  fs/nfsd/filecache.h |  1 -
> >  fs/nfsd/nfs4proc.c  |  7 ++++---
> >  fs/nfsd/vfs.c       | 40 +++++++++++++++-------------------------
> >  4 files changed, 19 insertions(+), 30 deletions(-)
> 
> What about 5.15?  We can't take this patch for 5.10 only as if you
> upgrade to 5.15 you would have a regression.  Can you provide a version
> for that tree so that I can then apply this one too?
> 
> thanks,
> 
> greg k-h

Just sent the 5.15 version. The upstream commit
(555dbf1a9aac6d3150c8b52fa35f768a692f4eeb) actually applies cleanly on
5.15 so you can pull that or the version I just sent with the
justification for backporting. After applying this commit to 5.15, I
confirmed there was no peformance regression.

Best,
Leah
