Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9154E8AF8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 00:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiC0WyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 18:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiC0WyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 18:54:08 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004A9338A5;
        Sun, 27 Mar 2022 15:52:28 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 223E81EC01A2;
        Mon, 28 Mar 2022 00:52:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1648421543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fXK18M0KVpIRPx1rmbaiuZ7FWqGHqgKnqmOp0B4zeeI=;
        b=GaWshRQG9YEh7hi3v6G7o2WOoPQsxZ47PZDGD+OCVzj7XsICK71UpDRwiUZ6GlGNh9x1th
        vkcutIyO7RY1JTUqKsQDWOiYDWHNsNCX5mgU9DdhTVFzLR3I2/8SGXkrzQE9vGrBeFXCuL
        vwdSRMu4G1L85J4Av5rMwFN2f2n14hI=
Date:   Mon, 28 Mar 2022 00:52:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org
Subject: Re: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when
 `threshold_create_bank()` fails
Message-ID: <YkDqo2eEbABbtSGY@zn.tnic>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <20220310015306.445359-3-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220310015306.445359-3-ammarfaizi2@gnuweeb.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 08:53:06AM +0700, Ammar Faizi wrote:
> In mce_threshold_create_device(), if threshold_create_bank() fails, the
> @bp will be leaked, because the call to mce_threshold_remove_device()
> will not free the @bp. mce_threshold_remove_device() frees
> @threshold_banks. At that point, the @bp has not been written to
> @threshold_banks, @threshold_banks is NULL, so the call is just a nop.
> 
> Fix this by extracting the cleanup part into a new static function
> _mce_threshold_remove_device(), then call it from create/remove device
> functions.
> 
> Also, eliminate the "goto out_err", just early return inside the loop
> if the creation fails.
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org # v5.8+
> Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")

How did you decide this is the commit that this is fixing?

> Link: https://lore.kernel.org/lkml/9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org

That Link tag is not needed.

> Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Co-authored-by: Yazen Ghannam <yazen.ghannam@amd.com>

There's no "Co-authored-by".

The correct tag is described in

Documentation/process/submitting-patches.rst

Please make sure you've read that file before sending patches.

> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  arch/x86/kernel/cpu/mce/amd.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)

...

> @@ -1350,15 +1357,14 @@ int mce_threshold_create_device(unsigned int cpu)
>  		if (!(this_cpu_read(bank_map) & (1 << bank)))
>  			continue;
>  		err = threshold_create_bank(bp, cpu, bank);
> -		if (err)
> -			goto out_err;
> +		if (err) {
> +			_mce_threshold_remove_device(bp, numbanks);
> +			return err;
> +		}
>  	}
>  	this_cpu_write(threshold_banks, bp);

Do I see it correctly that the publishing of the @bp pointer - i.e.,
this line - should be moved right above the for loop?

Then mce_threshold_remove_device() would properly free it in the error
case and your patch turns into a oneliner?

And then your Fixes: tag would be correct too...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
