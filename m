Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBFD4C8675
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 09:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiCAI1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 03:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiCAI1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 03:27:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE477A998;
        Tue,  1 Mar 2022 00:26:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E87A0B817D0;
        Tue,  1 Mar 2022 08:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F136C340EE;
        Tue,  1 Mar 2022 08:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646123212;
        bh=TwhJPmV9y9c3eqT3zE3wD0HQcup9gYh9eXtwtOtu4EQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w7cJw0GLrgvMVletWXAGP6NYKkLVc9SJg4Anj/PRy87gWz9cM9TPHo2vyESw4fNin
         WAUrVotZQVMP0A/c4VFlWPbg10DELaJEYtCFptAvCdTTi0FzoKnV9aqag/LwB+daVd
         Ag/8qLqQqiBEjuXASy363BhMQb7wiyxSd3Gb/kRI=
Date:   Tue, 1 Mar 2022 09:26:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Message-ID: <Yh3YyU2VVK/iaLcA@kroah.com>
References: <20220301073223.98236-1-ammarfaizi2@gnuweeb.org>
 <20220301073223.98236-2-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301073223.98236-2-ammarfaizi2@gnuweeb.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 02:32:22PM +0700, Ammar Faizi wrote:
> The asm constraint does not reflect that the asm statement can modify
> the value of @loops. But the asm statement in delay_loop() does change
> the @loops.
> 
> If by any chance the compiler inlines this function, it may clobber
> random stuff (e.g. local variable, important temporary value in reg,
> etc.).
> 
> Fortunately, delay_loop() is only called indirectly (so it can't
> inline), and then the register it clobbers is %rax (which is by the
> nature of the calling convention, it's a caller saved register), so it
> didn't yield any bug.
> 
> ^ That shouldn't be an excuse for using the wrong constraint anyway.
> 
> This changes "a" (as an input) to "+a" (as an input and output).
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Fixes: e01b70ef3eb3080fecc35e15f68cd274c0a48163 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")

You only need 12 characters here :)

> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---

Why is this one not tagged for stable?
