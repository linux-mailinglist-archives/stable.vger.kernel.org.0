Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AE24DB270
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243294AbiCPOQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356460AbiCPOQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:16:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128192F03D
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:15:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7019FCE1F59
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 14:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078FAC340EC;
        Wed, 16 Mar 2022 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647440096;
        bh=UOyotBB63YnJSGCpSruZhKgJ1yBjSbgWDMnVUNRaOIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SSE5EtL0mwgVRXonLOOzHuX2VHXREHp5X5OPTe8mNQtUXiMNEh54g1Ti+XMvneRi6
         UY6Ip8esecZ6WSWyeB0vtSIjfkt5PeiJeZTzMNJK2kyCcjW+x4yriv9snpuMnHV5TW
         2LsJinY41oybtGWlUJA9GYoBRYeZj9bx1OxTwjgw=
Date:   Wed, 16 Mar 2022 15:14:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: kintegrityd workqueue fix backported, but only to some LTS
Message-ID: <YjHw3XTmijir7M7A@kroah.com>
References: <Yi8r+UyK092FE12X@x1-carbon>
 <Yi809h0I28SN0qG8@kroah.com>
 <Yi8+aIyDFWCfBMT/@x1-carbon>
 <Yi9JKo4TPnc036Oa@kroah.com>
 <Yi9j62xyno2Kq24h@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi9j62xyno2Kq24h@x1-carbon>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 03:48:59PM +0000, Niklas Cassel wrote:
> On Mon, Mar 14, 2022 at 02:54:50PM +0100, Greg KH wrote:
> > On Mon, Mar 14, 2022 at 01:08:57PM +0000, Niklas Cassel wrote:
> > > On Mon, Mar 14, 2022 at 01:28:38PM +0100, Greg KH wrote:
> > > > On Mon, Mar 14, 2022 at 11:50:18AM +0000, Niklas Cassel wrote:
> > > > > Hello Christoph, stable,
> > > > > 
> > > > > I recently saw a crash caused by the kintegrityd workqueue that could only
> > > > > be reproduced on older kernels.
> > > > > A null pointer dereference in function bio_integrity_verify_fn.
> > > > > 
> > > > > The fix in Linus's tree for this:
> > > > > 3df49967f6f1 ("block: flush the integrity workqueue in blk_integrity_unregister")
> > > > > was first merged in v5.15.
> > > > > 
> > > > > The fix has been backported to v5.10 LTS branch in:
> > > > > 1ef68b84bc11 ("block: flush the integrity workqueue in blk_integrity_unregister")
> > > > > 
> > > > > The fix doesn't have a fixes tag, but from inspecting the code,
> > > > > I don't understand why this was only backported to v5.10, AFAICT it should
> > > > > at least have been backported to v5.4, v4.19 and v4.14 LTS as well.
> > > > > 
> > > > > Original series:
> > > > > https://lore.kernel.org/all/20210914070657.87677-3-hch@lst.de/
> > > > > 
> > > > > The blk_flush_integrity() call that actually fixes the crash should be
> > > > > trivial to backport/add before clearing the flag and doing the memset.
> > > > 
> > > > A backported patch series would be great to have, to show that you have
> > > > tested that it works properly.
> > > 
> > > Hello Greg,
> > > 
> > > Unfortunately, I don't have access to the machine. I was only provided
> > > a kernel crash dump to diagnose the crash.
> > > 
> > > I guess I was hoping for someone more familiar with the integrity stuff
> > > to backport it. Both patch 1 and 3 are unrelated to the NULL pointer crash,
> > > and because of various refactoring, I'm not sure if patch 1 and 3 are even
> > > applicable for older kernel versions.
> > 
> > I do not know what patch 1 and 3 refer to here, sorry :(
> 
> Sorry, I was referring to patch 1/3 and 3/3 in the series:
> https://lore.kernel.org/all/20210914070657.87677-1-hch@lst.de/
> 
> Looking at it again, patch 1/2 and 2/2 are both required.
> 
> Patch 3/3, I don't know, since the flag used to be in bdi, but is now in
> request_queue.
> 
> But even then, since this doesn't have a Fixes tag, I'm not sure how far
> this has to be backported. Christoph, thoughts?
> 
> I'm assuming that it was the machine learning scripts that backported it to
> 5.10, but considering that I've seen a crash dump with this in 4.18, it
> definitely should have been backported to 4.19+ (but probably even further
> back).

Please test and if it works for you, provide a backported series and I
will be glad to consider it.

thanks,

greg k-h
