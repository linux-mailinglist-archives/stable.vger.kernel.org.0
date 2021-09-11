Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A08407A69
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 22:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhIKUtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 16:49:01 -0400
Received: from x127130.tudelft.net ([131.180.127.130]:58246 "EHLO
        djo.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229487AbhIKUtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 16:49:01 -0400
Received: by djo.tudelft.nl (Postfix, from userid 2001)
        id 81AA71C42C2; Sat, 11 Sep 2021 22:49:05 +0200 (CEST)
Date:   Sat, 11 Sep 2021 22:49:05 +0200
From:   wim <wim@djo.tudelft.nl>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        wim <wim@djo.tudelft.nl>
Subject: Re: kernel-4.9.270 crash
Message-ID: <20210911204905.GA18345@djo.tudelft.nl>
Reply-To: wim@djo.tudelft.nl
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
 <YTWgKo4idyocDuCD@kroah.com>
 <20210906093611.GA20123@djo.tudelft.nl>
 <YTXy5BmzQpY0SprA@kroah.com>
 <20210908015139.GA26272@djo.tudelft.nl>
 <YThKidnH3d1fb18g@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YThKidnH3d1fb18g@kroah.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 07:30:49AM +0200, Greg KH wrote:
> 
> That is a vt change that handles an issue with a console driver, so this
> feels like a false failure.
> 
> If you revert this change on a newer kernel release, does it work?

Oh, you mean a higher version number (which wasn't directly obvious to me).
Make oldconfig gives an awful lot of output which I'm not going to read.
Just keep pressing the return key for all the defaults.
Kernel-5.10.10 runs into a black screen, I can perform a blind login and
play an audio file. I then tried to revert the patch, but git couldn't
complete it. The closest uplevel version is 4.14.246 which I then tried.
It runs into a black screen, but I can login and play audio, but no reaction
on modprobe fbcon. Git revert ran fine, but that also gave me a black
screen. It appeared that there was no fbcon.ko, even worse, the option to
modularize it was gone! Insane.
Since that option was now invalid, make oldconfig chose for a default no,
which I didn't know. In-kernel fbcon gives no problems, I guess.
This led to the discovery that the hard crash in 4.9.270(-282) did NOT occur
when fbcon.ko was not loaded. Modprobe fbcon after i915 went fine.

So here you have another reason to not wanting to run a kernel version above 4.9.
I need fbcon.ko as a diagnostics tool. In many machines with i915 I loose
sound when i915.ko gets loaded. I need to fiddle with the rc scripts to make
sure that the snd modules got loaded first. And because the changing fonts and
layout drives me nuts while looking at the progress, I need to put fbcon/i915
the very last (in rc.local).

Regards, Wim.
