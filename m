Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E629F5899DA
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 11:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiHDJXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 05:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiHDJXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 05:23:24 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E0A22B29;
        Thu,  4 Aug 2022 02:23:23 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id t5so4750324edc.11;
        Thu, 04 Aug 2022 02:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=94Q4kaaMwy5G5HfhtZ+9vdLQKCyzSdsUN6J+1BjLmpM=;
        b=gvGQ/BWK13ZuVwVHOZNku+D1Ip1lq+ZnqMfLk1KV7GfW5x6o3SM44xDgi9hBaLZsTB
         Zg6bbo4HZ+ZAzS8cJpTmMrSPPHjI/sTlCTxBrBFCQKTtO+twLacveSP4QTplHnbWcJcc
         P7SvYnpSgSpVQcr1bt5hTi7YZ8lS4JJWR8qjVlxCmYBH6dRPeh0htm9aLScNGRoTLV1o
         VzpQRlQYPWm4fcrzvfAIlQ+4GBpZnqpr8uqE34r2jYdjMWksiMDGqYFemHgWOqA3A0+u
         CAKqVvKcf+OfNGIiH1slb19Ho2oQ5uhXzr/DkjPodHeAoivzF+c2VhNTKdok/SX44MCJ
         Sm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=94Q4kaaMwy5G5HfhtZ+9vdLQKCyzSdsUN6J+1BjLmpM=;
        b=iSIP4C22q75iWAeXbWntbzsq3qe5bnZHLv3a1HvDhab91wB3W2RVoue8QPjy/+HUFI
         tU5EpvnPRO1Yysp0ibXkBR49Eiz07Kpvm+Sozv1L5Q5QvOMHtH8BLmsDqomeWA5OSctH
         r+gFO9VCFFsH/0rN3i2BgHwZp7K/2JZ8x2XUuRnadJJVZApmM+rDmrG8uTgPC21h61xj
         ThGD7qz8wKAZxS6V3B70ij4rVj45XrtYSVr9DhTowXxgnrCmwCW3YIv00znGn4QN+Fwb
         NcaH2W5f5giXp3GgjgbP0UiYBbEeTfTdi1HrE/4efIzz5faGtnM8zFs2bi8dTo2hbgts
         xLrg==
X-Gm-Message-State: ACgBeo0vJB0sl0ZtO7u1LG9+mw96t0q4HAkg46NwTfWdaCYCxpDVnFub
        60MJAdGldC/gfrmlzD47Zm8=
X-Google-Smtp-Source: AA6agR6mol/l9PnbDY7eeiSHEN4lcS0b/yZlZ2NnoDtUtidZg3LAQXT+rso4GvZok5HFCHf8NPrycQ==
X-Received: by 2002:a05:6402:f22:b0:43e:8623:d32c with SMTP id i34-20020a0564020f2200b0043e8623d32cmr1097307eda.265.1659605002537;
        Thu, 04 Aug 2022 02:23:22 -0700 (PDT)
Received: from gmail.com (195-38-112-141.pool.digikabel.hu. [195.38.112.141])
        by smtp.gmail.com with ESMTPSA id kd25-20020a17090798d900b006f3ef214ddesm142937ejc.68.2022.08.04.02.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 02:23:21 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Thu, 4 Aug 2022 11:23:19 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Kyle Huey <me@kylehuey.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/fpu: Allow PKRU to be (once again) written by
 ptrace.
Message-ID: <YuuQB8YihPWQfuOk@gmail.com>
References: <20220804031632.52921-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804031632.52921-1-khuey@kylehuey.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Kyle Huey <me@kylehuey.com> wrote:

> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 0531d6a06df5..dfb79e2ee81f 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -406,16 +406,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  	if (ustate->xsave.header.xfeatures & ~xcr0)
>  		return -EINVAL;
>  
> -	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> -	if (ret)
> -		return ret;
> -
> -	/* Retrieve PKRU if not in init state */
> -	if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
> -		xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
> -		*vpkru = xpkru->pkru;
> -	}
> -	return 0;
> +	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
>  }
>  EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);

So this removes 'ret' and 'xpkru' use from 
fpu_copy_uabi_to_guest_fpstate(), but leaves the variables in place, 
generating a build warning (and error with CONFIG_WERROR=y) ...

Thanks,

	Ingo
