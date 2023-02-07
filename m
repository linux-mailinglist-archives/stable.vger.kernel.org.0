Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC9168D09E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 08:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjBGHa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 02:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjBGHa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 02:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A3A32E7F
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 23:30:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4607B611D5
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 07:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CE8C4339B;
        Tue,  7 Feb 2023 07:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675755055;
        bh=jQpUf6ZoVDjN1pVuN4q/kf52W7gtpPDieZdOjV8r9UQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BrrGqQLv+JOtbMW0RlRLKUTwfC75ArXJIShjH0AY9u/CTHcTpYvCyaN/bf6V7fFR0
         ftB7ysWLYwnM3eqJmCeJi5HFXEadOesccyoBGWT9oXQjQs+SBwYWDcfAc8rvewSfGH
         9rN/f4ZKlD0NmTGL56fMba4l6q8XY8KukL9caNME=
Date:   Tue, 7 Feb 2023 08:30:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xinghui Li <korantwork@gmail.com>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
Message-ID: <Y+H+LDbPoN2JDE2X@kroah.com>
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com>
 <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
 <Y+DK4fP/u7iYi7Kt@kroah.com>
 <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
 <Y+H1HRqfnULl/B9f@kroah.com>
 <CAEm4hYXnX=E55CQ9Ts5E1Z7pBLRnH91fckMvVO-xmnaT0++JFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEm4hYXnX=E55CQ9Ts5E1Z7pBLRnH91fckMvVO-xmnaT0++JFA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 03:19:06PM +0800, Xinghui Li wrote:
> Greg KH <gregkh@linuxfoundation.org> 于2023年2月7日周二 14:52写道：
> > I do not understand the actual runtime error, sorry.  Stack traces don't
> > matter at runtime, do they?
> >
> Sorry for the inaccurate description~ I mean it might not just a
> compiling warning.
> > > > That is very odd, why is it hard to update to a new kernel?  What
> Some features we developed based on v5.4's API. Update the kernel
> verison could cause the KABI issue.

What abi issue are you referring to?  The user/kernel api?  Or
out-of-tree-code that is in your kernel tree?

If out-of-tree stuff, just forward port it, like you are going to have
to do anyway.  You have to always have a plan to move forward, otherwise
you are guaranteed to have an insecure kernel someday.

Moving to a new kernel version should always be planned, and possible.
If not, something is very wrong with your management process :(

> > > > happens if 5.4 stops being maintained tomorrow, what are your plans to
> We will align with the LTS's lifecycle on our product
> lifecycle(actually shorter).
> If v5.4 do stop being maintained(I know it is not real), It looks like
> we can only maintain it all by ourselves :-(.

Again, why?  What is so magical about this release?

thanks,

greg k-h
