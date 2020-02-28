Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDF172E5A
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 02:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgB1Bfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 20:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgB1Bfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 20:35:44 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B2E724695;
        Fri, 28 Feb 2020 01:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582853743;
        bh=3c7y53TBz8CoRcBHPa47xfths3DIyspvtqjQbhAV/WA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cb8txwtpNtfGZlUgMlY1+oUahx3WwpA6j5dzL/C+rn4eZ1LYX/m57Jk3AtOk6BhQ5
         UF5WaQLcj7w3siZb5hnG0AxScSJdJTDbWqQjv8OG32RiVp8cq9lCig/L1Az6u8WWMt
         fiRCjgSTUz02v521ZZfETdz+KV5KYRg2Xor+SGAA=
Date:   Thu, 27 Feb 2020 20:35:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, jannh@google.com, pablo@netfilter.org
Subject: Re: [v4.9.y, v4.4.y] netfilter: xt_bpf: add overflow checks
Message-ID: <20200228013542.GH22178@sasha-vm>
References: <20200226213501.113484-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200226213501.113484-1-zsm@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 01:35:01PM -0800, Zubin Mithra wrote:
>From: Jann Horn <jannh@google.com>
>
>[ Upstream commit 6ab405114b0b229151ef06f4e31c7834dd09d0c0 ]
>
>Check whether inputs from userspace are too long (explicit length field too
>big or string not null-terminated) to avoid out-of-bounds reads.
>
>As far as I can tell, this can at worst lead to very limited kernel heap
>memory disclosure or oopses.
>
>This bug can be triggered by an unprivileged user even if the xt_bpf module
>is not loaded: iptables is available in network namespaces, and the xt_bpf
>module can be autoloaded.
>
>Triggering the bug with a classic BPF filter with fake length 0x1000 causes
>the following KASAN report:
>
>==================================================================
>BUG: KASAN: slab-out-of-bounds in bpf_prog_create+0x84/0xf0
>Read of size 32768 at addr ffff8801eff2c494 by task test/4627
>
>CPU: 0 PID: 4627 Comm: test Not tainted 4.15.0-rc1+ #1
>[...]
>Call Trace:
> dump_stack+0x5c/0x85
> print_address_description+0x6a/0x260
> kasan_report+0x254/0x370
> ? bpf_prog_create+0x84/0xf0
> memcpy+0x1f/0x50
> bpf_prog_create+0x84/0xf0
> bpf_mt_check+0x90/0xd6 [xt_bpf]
>[...]
>Allocated by task 4627:
> kasan_kmalloc+0xa0/0xd0
> __kmalloc_node+0x47/0x60
> xt_alloc_table_info+0x41/0x70 [x_tables]
>[...]
>The buggy address belongs to the object at ffff8801eff2c3c0
>                which belongs to the cache kmalloc-2048 of size 2048
>The buggy address is located 212 bytes inside of
>                2048-byte region [ffff8801eff2c3c0, ffff8801eff2cbc0)
>[...]
>==================================================================
>
>Fixes: e6f30c731718 ("netfilter: x_tables: add xt_bpf match")
>Signed-off-by: Jann Horn <jannh@google.com>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>Signed-off-by: Zubin Mithra <zsm@chromium.org>

Queued up for 4.9 and 4.4, thanks!

-- 
Thanks,
Sasha
