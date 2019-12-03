Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE59A10FD12
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLCMDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfLCMDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 07:03:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D872068E;
        Tue,  3 Dec 2019 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575374586;
        bh=X3xxWWIPEUious9vCNNY5FmVrTaTZ1isVPGSJ+SVmvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mRwFLE5SiCcv4UB1m9HGKPNV7kwg7Z58Zi2nNNXc94MJRyYtkmHQgjs6tZ7tyv0FS
         zfJxyXEev4XRO1uJUIAsvBpytUBUmxO+KlVHQLUy15duz6PSpFm+3NeQhuqAVmUmdf
         tan0usNmmWpILPrTssIozou+ssfjSom5WjlAcMxg=
Date:   Tue, 3 Dec 2019 13:03:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [STABLE TEST] 5.3.13
Message-ID: <20191203120304.GA2126088@kroah.com>
References: <20191203062503.GA3467@workstation-kernel-dev>
 <20191203064052.GA1788679@kroah.com>
 <20191203071415.GA9640@workstation-portable>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203071415.GA9640@workstation-portable>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 12:44:15PM +0530, Amol Grover wrote:
> On Tue, Dec 03, 2019 at 07:40:52AM +0100, Greg KH wrote:
> > On Tue, Dec 03, 2019 at 11:55:03AM +0530, Amol Grover wrote:
> > > Compiled, Booted, however I'm getting the following errors when running
> > > "make kselftest"
> > > 
> > > sudo dmesg -l alert
> > > 
> > > [34381.903893] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > > [34381.903904] #PF: supervisor read access in kernel mode
> > > [34381.903908] #PF: error_code(0x0000) - not-present page
> > 
> > Which test causes this problem?
> 
> IIRC I didn't run make kselftest with summary=1 option. Is there any
> other way to get that information? The logs that kselftest generated
> also don't seem to help in this.

Watch the output when you run this?  I don't know, try re-running it
with that option.

> > ANd is it new in 5.3.13?
> > 
> 
> I previously ran kselftest on 5.4-rc7 and 5.3.9 (default kernel shipped
> by openSUSE), both were fine. However, a bit of backstory:
> 
> A day ago I used kselftest from the linux/next branch and ran it (w/o
> sudo).  It showed me the exact same error. However, I was running a
> modified version of 5.3.13, but those modifications were actually
> trivial (5 lines changed) and shouldn't have resulted in this kernel
> error. So, I switched to the vanilla 5.3.13 and ran kselftest (w/o sudo)
> again. I ran it 3 times (w/o any errors), switched back to the modified
> kernel and ran kselftest (w/o root) 2 more times and everything was
> fine. Then I decided to test the vanilla one again for the 4th time, but
> this time I ran kselftest as root where this BUG popped again.

Try a kernel.org 5.3.9 and if that works, then try 5.3.13 and if that
fails, run 'git bisect' and try to find the offending kernel commit.

thanks,

greg k-h
