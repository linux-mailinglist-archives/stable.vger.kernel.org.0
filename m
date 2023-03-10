Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CC6B3FC0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCJMyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjCJMyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:54:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682A210E268
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:53:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 246A761626
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63BAC433EF;
        Fri, 10 Mar 2023 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678452823;
        bh=WuD1BBVHkAcnwCA8+h00PLME2n10fdVjg1eUQR7JQmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZR7CG/IM1UkiF6WUPrKc0huBohKgoQ/ul1xZfXNmtz9pZQh4P9gM1k3Z8/hx+rDB2
         a9F1o5v/jq6sq8ykbZzTy5P0o7Y0ja9sAbCjJ3tyJI2mCpBTtP+yPVE49XKXMtwutj
         VN7UXJdVK+ZD13XVLfVc9XM38DuMjS9bDd9OzXhg=
Date:   Fri, 10 Mar 2023 13:53:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
Message-ID: <ZAsoVKmT7N9FD7ik@kroah.com>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
 <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com>
 <ZAi4k/09acWV0wRZ@eldamar.lan>
 <8579fc77c0de08c17d6d34b4d5dcc9386d69ebba.camel@suse.com>
 <ZAjjAcLZ/3HsqtzQ@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAjjAcLZ/3HsqtzQ@eldamar.lan>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 08:33:21PM +0100, Salvatore Bonaccorso wrote:
> Hi Martin,
> 
> On Wed, Mar 08, 2023 at 07:06:10PM +0100, Martin Wilck wrote:
> > On Wed, 2023-03-08 at 17:32 +0100, Salvatore Bonaccorso wrote:
> > > hi Martin, hi Sreekanth,
> > > 
> > > On Mon, Mar 06, 2023 at 08:16:35PM -0500, Martin K. Petersen wrote:
> > > > 
> > > > Hi Salvatore!
> > > > 
> > > > > Sreekanth and Martin is this still on your radar?
> > > > 
> > > > Broadcom will have to provide a suitable fix for the relevant older
> > > > stable releases. It is the patch author's responsibility to provide
> > > > backports.
> > > > 
> > > > > as 9df650963bf6 picking as well is not an option.
> > > > 
> > > > Why not?
> > > 
> > > Thanks to Martin Wilck from SUSE to get me understanding the picture.
> > > The problem is that e0e0747de0ea ("scsi: mpt3sas:
> > > Fix return value check of dma_get_required_mask()") was backported to
> > > several series. In mainline though the mis-merge did undo that. So I
> > > believe the right thing would be to revert first in the stable series
> > > where it was applied (5.10.y, 5.15.y) the commit e0e0747de0ea ("scsi:
> > > mpt3sas: Fix return value check of dma_get_required_mask()")  and
> > > then
> > > on top of this revert apply the patches:
> > > 
> > > 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
> > > reallocating pools")
> > > 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
> > > 06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask()
> > > API")
> > > 
> > > Attached mbox file implements this.
> > > 
> > > Does that looks now good for resolving the regression?
> > > 
> > 
> > Yes, this makes sense and it's actually the same thing I did for our
> > 5.14 series. Thanks for re-figuring it out, the matter is really
> > confusing.
> 
> Thanks for confirming. 
> 
> I had a small typo in the commit message of the revert commit,
> attached is an updated mbox with that fixed (afferomentioned ->
> aforementioned).

Now queued up for 5.10.y and 5.15.y, thanks!

greg k-h
