Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7CE4F0B74
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbiDCRFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 13:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiDCRFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 13:05:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802B3167CB;
        Sun,  3 Apr 2022 10:04:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649005439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0FYO/QymqAO+y1Q05iYfClrPZn9DYCQj8o18qRL5/l0=;
        b=igMsj+7iOclnRmjo3ROBNua2ZGLjOf6Pjbn5hKLYQ58wUynP3GlxuqyweBgD3LUEIz2OhZ
        9Eos4AEHYZ90RIFx35yojdQ1FI6uJgLAKTGV+dmRf1SaELxBvFxBtS5byFookMR0vkOgYy
        +qRkq/bVh5DEBl6iU6lEprV29BmafFjlXbwEPsGz6huZHSi7SACfj1nL6dwiSoy6En9umR
        bN0BHSUA/EBrFRb4/YeQJncg/WMV4NWCp3yp6kGv60ejsnZBmKLaPegILWobi6nVhbSIYl
        goyRb3pJFB1HL86fswDLBjiTXrU8o1upq9RGA8AWM+eHnm6WDheIbzsQ7yUhlA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649005439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0FYO/QymqAO+y1Q05iYfClrPZn9DYCQj8o18qRL5/l0=;
        b=F6Pm90niQA6fSu2wZ0hj2XwU90qnDpNGMPk+Aql+I7+r1KkstPG46logbBEtyxHDDMp8jd
        gEIgJit+1EJrFwBA==
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>
Subject: Re: [PATCH v6 2/2] x86/MCE/AMD: Fix memory leak when
 `threshold_create_bank()` fails
In-Reply-To: <20220329104705.65256-3-ammarfaizi2@gnuweeb.org>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
 <20220329104705.65256-3-ammarfaizi2@gnuweeb.org>
Date:   Sun, 03 Apr 2022 19:03:58 +0200
Message-ID: <87wng6ksjl.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29 2022 at 17:47, Ammar Faizi wrote:

> In mce_threshold_create_device(), if threshold_create_bank() fails, the
> @bp will be leaked, because the call to mce_threshold_remove_device()
> will not free the @bp. mce_threshold_remove_device() frees
> @threshold_banks. At that point, the @bp has not been written to
> @threshold_banks, @threshold_banks is NULL, so the call is just a nop.
>
> Fix this by extracting the cleanup part into a new static function
> __threshold_remove_device(), then call it from create/remove device
> functions.

The way simpler fix is to move 

>  	}
>  	this_cpu_write(threshold_banks, bp);

before the loop. That's safe because the banks cannot yet be reached via
an MCE as the vector is not yet enabled:
  
>  	if (thresholding_irq_en)
>  		mce_threshold_vector = amd_threshold_interrupt;

Thanks,

        tglx
