Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523455F5897
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiJEQtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 12:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiJEQtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 12:49:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45537EFC6
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 09:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 864DCB81E98
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 16:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBA6C433D6;
        Wed,  5 Oct 2022 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664988537;
        bh=x+U48QlXr3380GM/+51Z9qvnrMNmYuKUn5n0d8Bi+v4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5ghfPfEgsBL5mRqA+vZRUM/9PU5f6i7+ysSt5AiLKKnENJ1aos5jXnBohJ60J+QB
         DGEX68btE8QpovxZDzCpyL6YczNKFUJnrKnEOuLMCiigVYTtAmM+PbvrazHb0xtunh
         sr9KHKgcvvs9LfCPTGLPB2QM6muhyCAt50Twx9+U=
Date:   Wed, 5 Oct 2022 18:48:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff and
 d6ffe6067a54972564552ea45d320fb98db1ac5e
Message-ID: <Yz21dn2vJPOVOffr@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <YzflXQMdGLsjPb70@kroah.com>
 <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 08:28:06AM -0400, Mikulas Patocka wrote:
> 
> 
> On Sat, 1 Oct 2022, Greg KH wrote:
> 
> > On Fri, Sep 30, 2022 at 11:32:30AM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > Here I'm submitting backport of patches 
> > > 8238b4579866b7c1bb99883cfe102a43db5506ff and 
> > > d6ffe6067a54972564552ea45d320fb98db1ac5e to the stable branches.
> > 
> > Thanks, but you provide no information as to why these are needed.
> > 
> > What needs them?  They are just adding new functions to the tree from
> > what I can tell.
> > 
> > thanks,
> > 
> > greg k-h
> 
> There's a race condition in wait_on_bit. wait_on_bit tests a bit using the 
> "test_bit" function, however this function doesn't do any memory barrier, 
> so the memory accesses that follow wait_on_bit may be reordered before it 
> and return invalid data.
> 
> Linus didn't want to add a memory barrier to wait_on_bit, he instead 
> wanted to introduce a new function test_bit_acquire that performs the 
> "acquire" memory barrier and use it in wait_on_bit.
> 
> The patch d6ffe6067a54972564552ea45d320fb98db1ac5e fixes an oversight in 
> the patch 8238b4579866b7c1bb99883cfe102a43db5506ff where the function 
> test_bit_acquire was not defined for some architectures and this caused 
> compile failure.
> 
> The backport of the patch 8238b4579866b7c1bb99883cfe102a43db5506ff should 
> be applied first and the backport of the patch 
> d6ffe6067a54972564552ea45d320fb98db1ac5e afterwards.

All now queued up, thanks.

greg k-h
