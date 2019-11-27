Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE7510ABD6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 09:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfK0IdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 03:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbfK0IdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 03:33:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D2332064B;
        Wed, 27 Nov 2019 08:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574843580;
        bh=EOkaLp9VA78EaVRbhZB/baFiW0sHTjl/nkgMW86i0J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aY2M7DDejEL6xmYArZ2UWQXAU0S4CoK8Z8MIMiWqpU0M8qt++aKk4evt4kIDwGIFD
         lRXRX4lJUCookzsKRUyP/kPhxEifIGixPM9yR6N2BH8m5pD6snTcICKKfpYqD5zAKl
         EB1qPj5hIdF95KMASFCsK2+6cfNbL1NAnF++Rr2Y=
Date:   Wed, 27 Nov 2019 09:32:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: Re: [PATCH] ARC: perf: Accommodate big-endian CPU
Message-ID: <20191127083258.GA1834144@kroah.com>
References: <20191127080123.21890-1-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127080123.21890-1-abrodkin@synopsys.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 11:01:23AM +0300, Alexey Brodkin wrote:
> 8-letter strings representing ARC perf events are stores in two
> 32-bit registers as ASCII characters like that: "IJMP", "IALL", "IJMPTAK" etc.
> 
> And the same order of bytes in the word is used regardless CPU endianness.
> 
> Which means in case of big-endian CPU core we need to swap bytes to get
> the same order as if it was on little-endian CPU.
> 
> Otherwise we're seeing the following error message on boot:
> ------------------------->8----------------------
> ARC perf        : 8 counters (32 bits), 40 conditions, [overflow IRQ support]
> sysfs: cannot create duplicate filename '/devices/arc_pct/events/pmji'
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.2.18 #3
> Stack Trace:
>   arc_unwind_core+0xd4/0xfc
>   dump_stack+0x64/0x80
>   sysfs_warn_dup+0x46/0x58
>   sysfs_add_file_mode_ns+0xb2/0x168
>   create_files+0x70/0x2a0
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at kernel/events/core.c:12144 perf_event_sysfs_init+0x70/0xa0
> Failed to register pmu: arc_pct, reason -17
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.2.18 #3
> Stack Trace:
>   arc_unwind_core+0xd4/0xfc
>   dump_stack+0x64/0x80
>   __warn+0x9c/0xd4
>   warn_slowpath_fmt+0x22/0x2c
>   perf_event_sysfs_init+0x70/0xa0
> ---[ end trace a75fb9a9837bd1ec ]---
> ------------------------->8----------------------
> 
> What happens here we're trying to register more than one raw perf event
> with the same name "PMJI". Why? Because ARC perf events are 4 to 8 letters
> and encoded into two 32-bit words. In this particular case we deal with 2
> events:
>  * "IJMP____" which counts all jump & branch instructions
>  * "IJMPC___" which counts only conditional jumps & branches
> 
> Those strings are split in two 32-bit words this way "IJMP" + "____" &
> "IJMP" + "C___" correspondingly. Now if we read them swapped due to CPU core
> being big-endian then we read "PMJI" + "____" & "PMJI" + "___C".
> 
> And since we interpret read array of ASCII letters as a null-terminated string
> on big-endian CPU we end up with 2 events of the same name "PMJI".
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Cc: stable@vger.kernel.org
> ---
> 
> Greg, Sasha, this is the same patch as
> commit 5effc09c4907 ("ARC: perf: Accommodate big-endian CPU")
> but fine-tuned to be applicable to kernels 4.19 and older.

Thanks, now queued up.

greg k-h
