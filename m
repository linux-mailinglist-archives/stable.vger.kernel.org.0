Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36685417154
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 13:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhIXLxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 07:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhIXLxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 07:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F29760FA0;
        Fri, 24 Sep 2021 11:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632484332;
        bh=wZ7JvLbW6/CccQC7u8oTZoyuiNApc1cmhBoRk7LItGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cEzoVkd6fMFdfl4pHJVhO355zwb+8jFkAzNMa/HzeG8UXOspqCAJem81cSioMwIVQ
         2H3XEbHdJCro16tMu74Ks3Jfy5JGrdiHup/26axU0FhTdpEh/QpHSWdVO1SRlDgq20
         0wA4Hvd5ZhagBdB68AtzgIHLmT3RLabPIAN0471kaQK1HxYg7AjYGsjMaleymo9kNx
         4Z1kcUqh9X/flHc8ox3YGmViTqc9dMjVjFT2Pt79lTbg+HuKvcdKA63AWhrFd1UACJ
         mq10GtCH+Y9yCsuInwjVsA0quoHfmS0vnC4iG06J8c5lbU9d4xP5HaQ3HBOMy9AFjl
         ym/uoKo5BhbKQ==
Date:   Fri, 24 Sep 2021 07:52:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH stable 4.9 v2 0/4] ARM: ftrace MODULE_PLTS warning
Message-ID: <YU2769mOr3lb8jFi@sashalap>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
 <YUxYV/m36iPuxdoe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YUxYV/m36iPuxdoe@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 23, 2021 at 12:35:03PM +0200, Greg Kroah-Hartman wrote:
>On Wed, Sep 22, 2021 at 10:02:42AM -0700, Florian Fainelli wrote:
>> This patch series is present in v5.14 and fixes warnings seen at insmod
>> with FTRACE and MODULE_PLTS enabled on ARM/Linux.
>
>All now queued up, thanks.

Looks like 4.19 and older break the build:

arch/arm/kernel/ftrace.c: In function 'ftrace_update_ftrace_func':
arch/arm/kernel/ftrace.c:157:9: error: too few arguments to function 'ftrace_call_replace'
   157 |   new = ftrace_call_replace(pc, (unsigned long)func);
       |         ^~~~~~~~~~~~~~~~~~~
arch/arm/kernel/ftrace.c:99:22: note: declared here
    99 | static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
       |                      ^~~~~~~~~~~~~~~~~~~
arch/arm/kernel/ftrace.c: In function 'ftrace_make_nop':
arch/arm/kernel/ftrace.c:240:9: error: too few arguments to function 'ftrace_call_replace'
   240 |   old = ftrace_call_replace(ip, adjust_address(rec, addr));
       |         ^~~~~~~~~~~~~~~~~~~
arch/arm/kernel/ftrace.c:99:22: note: declared here
    99 | static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
       |                      ^~~~~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:303: arch/arm/kernel/ftrace.o] Error 1

I've dropped them.

-- 
Thanks,
Sasha
