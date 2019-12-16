Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A2011FCC8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 03:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLPCUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 21:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfLPCUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 21:20:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F8424676;
        Mon, 16 Dec 2019 02:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576462836;
        bh=4AnmbnlLPl7XKgtS2mksctBTpY4tp2JLCuCBmgeZahQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vEzpX+uBKkUG/zH2jBrAHw/yCuilNzXy9jcmt2tc1JzyFZyiEEkXta6QyB9sdsnyq
         u6smqKfSWp8CW3MMv/MsK5IWHvN7k4dmahsLGYp+cdEy6hwqLkr4kecaCqB8SsQvIa
         RdeY0gF5IAcjaUb7xDcveLYPSwuhrsoDDsw/29Ys=
Date:   Sun, 15 Dec 2019 21:20:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     vincenzo.frascino@arm.com, christophe.leroy@c-s.fr,
        mpe@ellerman.id.au, skhan@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Fix vDSO clock_getres()" failed
 to apply to 5.4-stable tree
Message-ID: <20191216022035.GB17708@sasha-vm>
References: <157642997725350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157642997725350@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 06:12:57PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 552263456215ada7ee8700ce022d12b0cffe4802 Mon Sep 17 00:00:00 2001
>From: Vincenzo Frascino <vincenzo.frascino@arm.com>
>Date: Mon, 2 Dec 2019 07:57:29 +0000
>Subject: [PATCH] powerpc: Fix vDSO clock_getres()
>
>clock_getres in the vDSO library has to preserve the same behaviour
>of posix_get_hrtimer_res().
>
>In particular, posix_get_hrtimer_res() does:
>    sec = 0;
>    ns = hrtimer_resolution;
>and hrtimer_resolution depends on the enablement of the high
>resolution timers that can happen either at compile or at run time.
>
>Fix the powerpc vdso implementation of clock_getres keeping a copy of
>hrtimer_resolution in vdso data and using that directly.
>
>Fixes: a7f290dad32e ("[PATCH] powerpc: Merge vdso's and add vdso support to 32 bits kernel")
>Cc: stable@vger.kernel.org
>Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
>Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
>Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>[chleroy: changed CLOCK_REALTIME_RES to CLOCK_HRTIMER_RES]
>Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/a55eca3a5e85233838c2349783bcb5164dae1d09.1575273217.git.christophe.leroy@c-s.fr

Adjusted for context changes due to missing 176ed98c8a76 ("y2038: vdso:
powerpc: avoid timespec references") and queued for all branches.

-- 
Thanks,
Sasha
