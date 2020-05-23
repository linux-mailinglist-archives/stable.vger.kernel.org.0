Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED751DF7C6
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 16:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgEWO0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 10:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387799AbgEWO0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 10:26:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4022071C;
        Sat, 23 May 2020 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590243975;
        bh=0Q1myEtL5uPwUEhQeqLqVK5hUcFZzoBGSYFUx0JMiXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gul4liqF2PfyDp9yJZsUJIddsL/Zpbm7J4ol3GTZWj3pn5I0MhMcAK7AxhukOZHOa
         ZtmtMfI0R05kbqwC92bomfoYplQSqqiQ4n8BMIdyjNgDXf46HX6+L6j1lwgF23PPRc
         GJy4dvlgc2nWU1Xj1SU7AkooAbFUfdcrJFibKxIo=
Date:   Sat, 23 May 2020 10:26:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/64s: Disable STRICT_KERNEL_RWX"
 failed to apply to 5.4-stable tree
Message-ID: <20200523142614.GT33628@sasha-vm>
References: <1590236015151171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1590236015151171@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 23, 2020 at 02:13:35PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 8659a0e0efdd975c73355dbc033f79ba3b31e82c Mon Sep 17 00:00:00 2001
>From: Michael Ellerman <mpe@ellerman.id.au>
>Date: Wed, 20 May 2020 23:36:05 +1000
>Subject: [PATCH] powerpc/64s: Disable STRICT_KERNEL_RWX
>
>Several strange crashes have been eventually traced back to
>STRICT_KERNEL_RWX and its interaction with code patching.
>
>Various paths in our ftrace, kprobes and other patching code need to
>be hardened against patching failures, otherwise we can end up running
>with partially/incorrectly patched ftrace paths, kprobes or jump
>labels, which can then cause strange crashes.
>
>Although fixes for those are in development, they're not -rc material.
>
>There also seem to be problems with the underlying strict RWX logic,
>which needs further debugging.
>
>So for now disable STRICT_KERNEL_RWX on 64-bit to prevent people from
>enabling the option and tripping over the bugs.
>
>Fixes: 1e0fc9d1eb2b ("powerpc/Kconfig: Enable STRICT_KERNEL_RWX for some configs")
>Cc: stable@vger.kernel.org # v4.13+
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20200520133605.972649-1-mpe@ellerman.id.au

I also took c55d7b5e6426 ("powerpc: Remove STRICT_KERNEL_RWX
incompatibility with RELOCATABLE") as a dependency for 5.4 and 4.19, and
4ec591e51a4b ("powerpc: restore alphabetic order in Kconfig") for 4.14.

-- 
Thanks,
Sasha
