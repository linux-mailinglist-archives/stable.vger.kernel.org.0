Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F323F55C92A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiF0LAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiF0LAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CD710FE
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 04:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E562161361
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB56FC3411D;
        Mon, 27 Jun 2022 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656327633;
        bh=2rMl6l+HHp2KZkdnUKVulAv5wfOt6ch1NbDSk8U2UhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NVQm+9XC60E9x2asjQEkMg2wdB5+5Olp1LpGbEXiuxqaOqHBe6w/Zb5eXsVog7pHe
         8TN347SrCc7qOsLCqGlh3Na/s8nmxdCIl3vml9XxaYUi9yXoFKq7FDcafsy7KUPegP
         GYTG8HTb1hMtn4+7sc3HAqxt9vNllg5tIGsv2p+E=
Date:   Mon, 27 Jun 2022 13:00:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Yangxi Xiang <xyangxi5@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in
 __strncpy_from_user
Message-ID: <YrmNzn21zTqgeKbM@kroah.com>
References: <CAK8P3a31O-_oGvG3bHCer7DXJApsd-TLV71_NwVt=yMGQ_iR_Q@mail.gmail.com>
 <20220627093810.1352-1-xyangxi5@gmail.com>
 <CAK8P3a0D7sy=jjjUQK0F-RugCNecYBg+JjM=vH=fy0suLDAOCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0D7sy=jjjUQK0F-RugCNecYBg+JjM=vH=fy0suLDAOCA@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 12:19:18PM +0200, Arnd Bergmann wrote:
> On Mon, Jun 27, 2022 at 11:38 AM Yangxi Xiang <xyangxi5@gmail.com> wrote:
> >
> > > Which architectures do you mean? I don't see any architecture using
> > > asm-generic/uaccess.h without setting GENERIC_STRNCPY_FROM_USER
> > > before commit 98b861a30431 or the prior release.
> >
> > I am a user of LibOS, which uses this __strncpy_from_user.
> 
> Ok, got it. This should be part of the changelog then when you send a
> patch for stable  kernels. You should also indicate that the code was
> removed in mainline kernels and what the fix was there, as well as
> which of the older kernels need the fix.

But libos isn't part of the kernel tree, that's an out-of-tree change
that we can't control here, right?  How is that relevant for stable
kernels and why can't it just be added to the libos patchset?

thanks,

greg k-h
