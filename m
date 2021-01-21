Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA84A2FE8CE
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 12:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbhAULav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 06:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730087AbhAULas (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 06:30:48 -0500
Received: from shrek.podlesie.net (shrek-3s.podlesie.net [IPv6:2a00:13a0:3010::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00D15C061575;
        Thu, 21 Jan 2021 03:29:59 -0800 (PST)
Received: by shrek.podlesie.net (Postfix, from userid 603)
        id 05D2A7BD; Thu, 21 Jan 2021 12:29:57 +0100 (CET)
Date:   Thu, 21 Jan 2021 12:29:57 +0100
From:   Krzysztof Mazur <krzysiek@podlesie.net>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Krzysztof =?iso-8859-2?Q?Ol=EAdzki?= <ole@ans.pl>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] x86/mmx: Use KFPU_387 for MMX string operations
Message-ID: <20210121112957.GA16586@shrek.podlesie.net>
References: <cover.1611205691.git.luto@kernel.org>
 <e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org>
User-Agent: Mutt/1.6.2 (2016-07-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 09:09:49PM -0800, Andy Lutomirski wrote:
> The default kernel_fpu_begin() doesn't work on systems that support XMM but
> haven't yet enabled CR4.OSFXSR.  This causes crashes when _mmx_memcpy() is
> called too early because LDMXCSR generates #UD when the aforementioned bit
> is clear.
> 
> Fix it by using kernel_fpu_begin_mask(KFPU_387) explicitly.
> 
> Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
> Cc: <stable@vger.kernel.org>
> Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/lib/mmx_32.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

Thanks, 5.10 + this patch series boots on K7 with SSE.

Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>

Regards,
Krzysiek
