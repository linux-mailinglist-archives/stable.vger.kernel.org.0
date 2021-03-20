Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C428342C90
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhCTLxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCTLxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF1C661953;
        Sat, 20 Mar 2021 09:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616233948;
        bh=85GRKLkKiCsYPt5LA6jmas18wQB2oc9NU6q/HnEaJeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MoBJcwSjz5ymWTpM4SXYwgHbr6hK6u/EsaKX/ZmPZDweR2wOSH7HFuLekjxWfQNF3
         TyxTCOodlbwU4jhEyMEcrq4G/cId6R1YGC6DNn83YNXwsSjkJTqXB+5IgfIabdGXpA
         k+OLPzG4V2d8FuwjZ7Rad60iOElZL3D9WjvJqvgY=
Date:   Sat, 20 Mar 2021 10:52:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/8] 4.19.182-rc1 review
Message-ID: <YFXF2QFObKGGS9Zb@kroah.com>
References: <20210319121744.114946147@linuxfoundation.org>
 <20210319212146.GA23228@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210319212146.GA23228@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 02:21:46PM -0700, Guenter Roeck wrote:
> On Fri, Mar 19, 2021 at 01:18:19PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.182 release.
> > There are 8 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 154 fail: 1
> Failed builds:
> 	x86_64:tools/perf
> Qemu test results:
> 	total: 420 pass: 420 fail: 0
> 
> jvmti/jvmti_agent.c:48:21: error: static declaration of ‘gettid’ follows non-static declaration
>    48 | static inline pid_t gettid(void)
>       |                     ^~~~~~
> In file included from /usr/include/unistd.h:1170,
>                  from jvmti/jvmti_agent.c:33:
> /usr/include/x86_64-linux-gnu/bits/unistd_ext.h:34:16: note: previous declaration of ‘gettid’ was here
> 
> The tools/perf error is not new. It is seen because I started updating
> my servers to Ubuntu 20.0. The following patches would be needed to fix the
> problem in v4.19.y.
> 
> 8feb8efef97a tools build feature: Check if get_current_dir_name() is available
> 11c6cbe706f2 tools build feature: Check if eventfd() is available
> 4541a8bb13a8 tools build: Check if gettid() is available before providing helper
> fc8c0a992233 perf tools: Use %define api.pure full instead of %pure-parser
> 
> The first two patches prevent a conflict with the third patch, and the
> last patch fixes an unrelated build warning.
> 
> Older kernels are also affected. The list of patches needed for v4.14.y is:
> 
> 0ada120c883d perf: Make perf able to build with latest libbfd
>         (this patch is in v4.9.y but not in v4.14.y)
> 25ab5abf5b14 tools build feature: Check if pthread_barrier_t is available
> 8feb8efef97a tools build feature: Check if get_current_dir_name() is available
> 11c6cbe706f2 tools build feature: Check if eventfd() is available
> 4541a8bb13a8 tools build: Check if gettid() is available before providing helper
> fc8c0a992233 perf tools: Use %define api.pure full instead of %pure-parser
> 
> I tried to fix the problem in v4.9.y and v4.4.y as well, but that is pretty
> much hopeless. I'll have to stop testing perf builds for those kernels.

I'll suck these in for the next round of releases, thanks.

and thanks for testing.

greg k-h
