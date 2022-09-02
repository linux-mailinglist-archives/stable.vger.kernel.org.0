Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F382A5AB8D1
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 21:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiIBTVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 15:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiIBTVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 15:21:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD85DF0A8;
        Fri,  2 Sep 2022 12:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B37A62297;
        Fri,  2 Sep 2022 19:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7387AC433D6;
        Fri,  2 Sep 2022 19:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662146464;
        bh=K8BGjhy+0YQS+LACFDgvDPfLnu+2CbH/clQ8DkWsJbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=liWMEdemKbFpZWLY/soRCTkD8UO2XGe0QeJetOISEetc0v98PVvDajeNoq7ml1jtL
         TQ+LPmnLeQmBit3DL51TAzW1HGGYBLDEJxyXZVqi2bY8JwPX9ZnTUiWAuNkKXVPeZm
         yE1fmE5e3dzD6LB9NdVkEm+O5BcJFsAD+0/jCS2L8PwERe8YrrOi23gQHF7wAdA8d7
         QSFVlHjaPCQ5RY+a/z7KRibnDOApgBUXO2VFppUyUYegGDn/cQXpx3SeCCX+FT7rsX
         jTg4MFgiQK5Lp8BL+1sxLs1Pm0tKJTR69X8mJUKenl8rybXvXip+d+F5Z6MyDmPRb4
         TIc/jSM+3/m+Q==
Date:   Fri, 2 Sep 2022 22:20:58 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Message-ID: <YxJXmuxTeKtDN9qu@kernel.org>
References: <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
 <YxFGykqMb+TD4L4l@kernel.org>
 <YxIEm4uHVvUY/rv6@kernel.org>
 <YxInD1m7rEnQ/yxW@kernel.org>
 <b418161b-2613-4bb9-9269-b4995de65794@intel.com>
 <YxIvr33xgjCbW6qu@kernel.org>
 <8d66f94f-9981-1456-9040-066e35c7ba1f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d66f94f-9981-1456-9040-066e35c7ba1f@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 10:38:34AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 9/2/2022 9:30 AM, Jarkko Sakkinen wrote:
> > On Fri, Sep 02, 2022 at 09:08:23AM -0700, Reinette Chatre wrote:
> >> Hi Jarkko,
> >>
> >> On 9/2/2022 8:53 AM, Jarkko Sakkinen wrote:
> >>> On Fri, Sep 02, 2022 at 04:26:51PM +0300, Jarkko Sakkinen wrote:
> >>>> +	if (ret)
> >>>> +		pr_err("%ld unsanitized pages\n", left_dirty);
> >>>
> >>> Yeah, I know, should be 'left_dirty'. I just quickly drafted
> >>> the patch for the email.
> >>>
> >>
> >> No problem - you did mention that it was an informal patch.
> >>
> >> (btw ... also watch out for the long local parameter returned
> >> as an unsigned long and the signed vs unsigned printing
> >> format string.) I also continue to recommend that you trim
> > 
> > Point taken.
> > 
> >> that backtrace ... this patch is heading to x86 area where
> >> this is required.
> > 
> > Should I just cut the whole stack trace, and leave the
> > part before it?
> 
> The trace is printed because of a WARN_ON() in the code.
> I do not think there is anything very helpful in that trace.
> I think the only helpful parts are the WARN itself that includes
> the line number and then information on which kernel it was
> encountered on.
> 
> How about something like (please note the FIXME within):
> 
> "
> Paul reported the following WARN while running kernel vFIXME:
>   WARNING: CPU: 6 PID: 83 at arch/x86/kernel/cpu/sgx/main.c:401 ksgxd+0x1b7/0x1d0

Yeah, this is a great idea, the use of WARN() is the whole point.
Thank you.

BR, Jarkko

