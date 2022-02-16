Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC794B852B
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 11:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiBPKFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 05:05:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiBPKFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 05:05:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5A79DD4F;
        Wed, 16 Feb 2022 02:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46F37B81E5F;
        Wed, 16 Feb 2022 10:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65305C004E1;
        Wed, 16 Feb 2022 10:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645005934;
        bh=2J7xwzqTHWSDu2LH2Tt6SfS/J8p3zgSgjxdggOct+0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z4pivZNnjcWwH5gWkuZPpjR0L6KEqfJdR6PwK5kDhXQ8A3vR5/OYVmdZ1WCbQaA49
         dQjJ1epwQ1D/MLUj1C8LE5hNAcDDyhq3VNC/2vtvIhUf7E9R7IbtvQJa11JxX1sV34
         02B6PA4yjOIesDlOX37gQ6sdKQwFVe8vESYTHhxQ=
Date:   Wed, 16 Feb 2022 11:05:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Geffon <bgeffon@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
Message-ID: <YgzMa7VcdzRCyYGn@kroah.com>
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com>
 <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
 <066c9f4b-b0a3-9343-9db9-1c1c7303da6f@intel.com>
 <CADyq12yuzOPbv+jrdhf8unzsifVXGw31LbW+Sh2tZ3qG=xjGjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyq12yuzOPbv+jrdhf8unzsifVXGw31LbW+Sh2tZ3qG=xjGjg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 09:01:54PM -0500, Brian Geffon wrote:
> On Tue, Feb 15, 2022 at 4:42 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 2/15/22 13:32, Brian Geffon wrote:
> > >> How was this tested, and what do the maintainers of this subsystem
> > >> think?  And will you be around to fix the bugs in this when they are
> > >> found?
> > > This has been trivial to reproduce, I've used a small repro which I've
> > > put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
> > > , I also was able to reproduce this using the protection_keys self
> > > tests on a 11th Gen Core i5-1135G7.
> >
> > I've got an i7-1165G7, but I'm not seeing any failures on a
> > 5.11 distro kernel.
> >
> 
> Hi Dave,
> I suspect the reason you're not seeing it is toolchain related, I'm
> building with clang 14.0.0 and it produces the sequence of
> instructions which use the cached value. Let me know if there is
> anything I can do to help you investigate this further.

Do older versions of clang have this problem?

thanks,

greg k-h
