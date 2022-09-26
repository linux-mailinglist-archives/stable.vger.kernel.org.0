Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9726E5EAD50
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiIZQ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiIZQ5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:57:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F49261D67;
        Mon, 26 Sep 2022 08:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE4AAB80AF1;
        Mon, 26 Sep 2022 15:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF53C433C1;
        Mon, 26 Sep 2022 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664207636;
        bh=0crWaPXBHQZ29qdGzZd0JYh4qhM+URw3eXnNCAjtI1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gODjHIt2kUVr5VF9QN5sgYvJvod+whH/q8QJHk4T1No91iuU0iYYRG30XmYbR6ULY
         bO9YNbFYtkgt+aPXEfAL3lDe+q+3AGJbYJ3himCuMf/BbNJ8FTqi1WHAKJEjAwIqvd
         Bp0JESAfiLYqjPb4MZoZ4nRipGRfeYPtBa88CNpM=
Date:   Mon, 26 Sep 2022 17:53:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Marth <daniel.marth@inso.tuwien.ac.at>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 06/40] efi: libstub: Disable struct randomization
Message-ID: <YzHLEZtLCw9V3xnZ@kroah.com>
References: <20220926100738.148626940@linuxfoundation.org>
 <20220926100738.463310701@linuxfoundation.org>
 <20220926110826.GE8978@amd>
 <CAMj1kXHOMuaBeR_LqVBKVtmGaJQg5hznSxow5bosQ9+NzhZ72A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHOMuaBeR_LqVBKVtmGaJQg5hznSxow5bosQ9+NzhZ72A@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 04:16:02PM +0200, Ard Biesheuvel wrote:
> On Mon, 26 Sept 2022 at 13:08, Pavel Machek <pavel@denx.de> wrote:
> >
> > Hi!
> >
> > > These structs look like the ideal randomization candidates to the
> > > randstruct plugin (as they only carry function pointers), but of course,
> > > these protocols are contracts between the firmware that exposes them,
> > > and the EFI applications (including our stubbed kernel) that invoke
> > > them. This means that struct randomization for EFI protocols is not a
> > > great idea, and given that the stub shares very little data with the
> > > core kernel that is represented as a randomizable struct, we're better
> > > off just disabling it completely here.
> >
> > > Cc: <stable@vger.kernel.org> # v4.14+
> >
> > AFAICT RANDSTRUCT_CFLAGS is not available in v4.19, so we should not
> > take this patch.
> >
> 
> Ugh, as it turns out, this macro doesn't exist before v5.19 so it
> should not be backported beyond that version at all.
> 
> Greg, can you please drop this patch from all the -stable trees except
> v5.19? Thanks, and apologies for creating confusion.

Now dropped from the 4.14, 4.19, and 5.4 queues, it is already in the
5.10 release.

thanks,

greg k-h
