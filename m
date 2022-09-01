Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A275A9BB0
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiIAPaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 11:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbiIAPaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 11:30:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5555BF55
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 08:29:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso2810029pjk.0
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 08:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=uEj+Y7Y/+YOHMSskQFWNi+2HHQDrIeW3yFZoL+MzmCA=;
        b=XnJ2wsCxF8tcfraG5sEl0nCNjGP9Bilt7of9qMjRKEcLdnCtKg/Y/70LxLSz5b/LQW
         HB7FwbLhalHN/C3kOLN1pB2v/LJyTHSucRh85pppfXgfAzvejP4gPJFlfiU8Q+KnCQmU
         yPdk/503lGXLXQ71TW81D1UxFpAE9siiVke4rKqb/jPQ2gGYMfU6ln/flqL9VNl+PH3C
         0Fv+RojMJYsoBEaBN7p0QfRr4O/7KG5Ylhr9ReSQf80+DUFAXTVV5+CiTRkMurXAdzAk
         lZRuywlOuVc01HdjcAYq125MKpHz8Zmk3KfemiIY9iKxSPCbb/hwFo07lNSf8jt/YxaF
         1i3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uEj+Y7Y/+YOHMSskQFWNi+2HHQDrIeW3yFZoL+MzmCA=;
        b=yYBrK/JSPFqdNiyJqgZ2r9p1toOBqFRbp3YGxtKXMAiUty7OwT9KpElM+9U3hGLILR
         yGJ6l9IUbHWglMKhH0AtYkrc5Eh9ixbJwM4kxjasc8CnWyaurzZt3zEWsXeSPTqFLERT
         l0fMlou2sazzVPoTd+IyEvpljoB/1HhqaKoSCuA1vRlyvQupRq7M3hqfhKmHYTlBjyMx
         CJNJNm4wEwBVtkEg1geZ0HXa5offGILRl0zE/bNMXjSy80B1hfzFrJht6HGt1oCi70+J
         o2ovgsthbvNwX32jhff1b6xqEaElPx5Xy0XaSPguB3+bIHJTLYZ9F962vB9FtJDYxjps
         uwjQ==
X-Gm-Message-State: ACgBeo2+D8I9lcKqOmfn0za9N/JK+PCLvq5l47QZsTDNXH+yeicEgVZd
        adgZjoyz3Hw5jLC7F3yJ6udplg==
X-Google-Smtp-Source: AA6agR6g/blRPHq0d3n7aMFn6OtHPk3vvVO7+7+iZmO5GTldkf85RNK960XEeC83SwKhjZRzxu+kdA==
X-Received: by 2002:a17:90b:1d0f:b0:1fe:4171:6e6f with SMTP id on15-20020a17090b1d0f00b001fe41716e6fmr5633707pjb.206.1662046191185;
        Thu, 01 Sep 2022 08:29:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r21-20020a170902ea5500b001708c4ebbaesm13590277plg.309.2022.09.01.08.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 08:29:50 -0700 (PDT)
Date:   Thu, 1 Sep 2022 15:29:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kyle Huey <me@kylehuey.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again) written by
 ptrace.
Message-ID: <YxDP6jie4cwzZIHp@google.com>
References: <20220829194905.81713-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829194905.81713-1-khuey@kylehuey.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022, Kyle Huey wrote:
> @@ -1246,6 +1246,21 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>  		}
>  	}
>  
> +	/*
> +	 * Update the user protection key storage. Allow KVM to
> +	 * pass in a NULL pkru pointer if the mask bit is unset
> +	 * for its legacy ABI behavior.
> +	 */
> +	if (pkru)
> +		*pkru = 0;
> +
> +	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> +		struct pkru_state *xpkru;
> +
> +		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> +		*pkru = xpkru->pkru;
> +	}

What about writing this as:

	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
		...

		*pkru = xpkru->pkru;
	} else if (pkru) {
		*pkru = 0;
	}

to make it slightly more obvious that @pkru must be non-NULL if the feature flag
is enabled?

Or we could be paranoid, though I'm not sure this is worthwhile.

	if ((hdr.xfeatures & XFEATURE_MASK_PKRU) &&
	    !WARN_ON_ONCE(!pkru)) {
		...

		*pkru = xpkru->pkru;
	} else if (pkru) {
		*pkru = 0;
	}


Otherwise, looks good from a KVM perspective.  Thanks!
