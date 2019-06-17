Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE5484CC
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfFQOCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 10:02:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41252 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFQOCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 10:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VY1lHdBgYCCCW3qLjN3FEOmA/p1aLGXZnNLs05o4lrM=; b=mkorBebSNsClbwPJKDcXy091n
        Ka/nuPa3uOABUQHQBHrm+M4326L4N2A0Ipm2LnvwIHAaCMZ1N+5pUD5BtcXHNDePDNStAvpttBpjT
        OhCQ/PdE4GNOTDItS0gWHXkxn3EST9eE2cR+83Welzg8ybLxC7+7F7L+5K3DNQw3XpLTX9oNisGEU
        TJTwr5Bqjwp6OdfI6bKdfi3nauV+2nmxf0pzj0dA5Yog6ZSabZLvYmxG7Pi7253pMYd+PfD9jCpSU
        U2CP8ArK5iHVkx+gU4XB8EU6uoNUIGGhW4PUeJusy++c8FUwrJeWaDDOu8E/ard1jqJ3sLrTwMQRA
        Yky4GOs0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcsD6-00009r-EY; Mon, 17 Jun 2019 14:02:12 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1518C201D1C98; Mon, 17 Jun 2019 16:02:10 +0200 (CEST)
Date:   Mon, 17 Jun 2019 16:02:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        akpm@linux-foundation.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ubsan: mark ubsan_type_mismatch_common inline
Message-ID: <20190617140210.GB3436@hirez.programming.kicks-ass.net>
References: <20190617123109.667090-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617123109.667090-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 02:31:09PM +0200, Arnd Bergmann wrote:
> objtool points out a condition that it does not like:
> 
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> 
> I guess this is related to the call ubsan_type_mismatch_common()
> not being inline before it calls user_access_restore(), though
> I don't fully understand why that is a problem.

The rules are that when AC is set, one is not allowed to CALL schedule,
because scheduling does not save/restore AC.  Preemption, through the
exceptions is fine, because the exceptions do save/restore AC.

And while most functions do not appear to call into schedule, function
trace ensures that every single call does in fact call into schedule.
Therefore any CALL (with AC set) is invalid.

> Marking the function inline shuts up the warning and might be
> the right thing to do. The patch that caused this is marked
> for stable backports, so this one should probably be backported
> as well.

This appears to be a 'fun' interaction between different checkers. What
happens is that __ubsan_handle_type_mismatch*() calls into
stackleak_track_stack() because it has an on-stack variable. It does
this before calling ubsan_type_mismatch_common().

ubsan_type_mismatch_common() does user_access_save/restore which
saves/restores AC and allows 'normal' code to be ran.

With the proposed __always_inline, the code generation changes such that
we run user_access_save() _before_ stackleack_track_stack() (for,
afaict, undefined raisins), and the warning goes away.

Maybe we should disable stackleak when building ubsan instead? We
already disable stack-protector when building ubsan.

> Fixes: 42440c1f9911 ("lib/ubsan: add type mismatch handler for new GCC/Clang")

I don't think this is quite right, because back then there wasn't any
uaccess validation.

> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  lib/ubsan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/ubsan.c b/lib/ubsan.c
> index ecc179338094..3d8836f0fc5c 100644
> --- a/lib/ubsan.c
> +++ b/lib/ubsan.c
> @@ -309,7 +309,7 @@ static void handle_object_size_mismatch(struct type_mismatch_data_common *data,
>  	ubsan_epilogue(&flags);
>  }
>  
> -static void ubsan_type_mismatch_common(struct type_mismatch_data_common *data,
> +static __always_inline void ubsan_type_mismatch_common(struct type_mismatch_data_common *data,
>  				unsigned long ptr)
>  {
>  	unsigned long flags = user_access_save();
