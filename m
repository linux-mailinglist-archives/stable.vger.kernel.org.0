Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0502A58914E
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiHCRZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236279AbiHCRZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:25:45 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B2A17AA1;
        Wed,  3 Aug 2022 10:25:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 8-20020a05600c024800b003a2fe343db1so1179884wmj.1;
        Wed, 03 Aug 2022 10:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GXZ4xXNRwdNX246uTCDjp/6UfuNozlv9ogOaTndHxOo=;
        b=BqcDSD4qn8OphNeXpd4d1tICbsWAbV05Cvz+aFGaHqgRoneYmfEIQI10k2dCySJ0oG
         uD2WrHSD66whZkjrFUTtw0Cl9ZNMwWzlBvEPk/5HwAhrvRgfpvgWgst01K/6+4r6ckV8
         3pDECBqxeMSC2SgqdcphAHHqEw0WbFd00j4k0yJebkVBonPd44SLNvBtqSxZQVF4tYii
         cmnypkd1Tb990NlTdqggfgVNlTBH1xAlHz+xCO71uEyKLvwSV8DuYF+wapx/FCxeJ4ku
         AgpkIaJpMEj2n9xtMl+b0i4bk1dewK6pXeZpClNTRJ+Am3qGIGHi5RzV7biuwysveun+
         5KjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GXZ4xXNRwdNX246uTCDjp/6UfuNozlv9ogOaTndHxOo=;
        b=rvP3lRA4s2rGq7xFZHGYIJ3mWjP3b+aDfEKAbLxgMvJaeiV2H7SlnyqmHsOKWVzlRm
         fVZmfMRysrCbVohNjsNYJQ9aQLsQZ55V5Ixsjq48UFkc/tpVwiqsTKbPxcU5EWH/VKc5
         ustAHOvj36iWt5FYLWPLdC6HipoiT4RK/f7XdhWlz8OC9G0cgOrXjZwWNvxo/hCBRa5E
         79LwskcF+kdJ+HeHqf9ereOCzeopkkpUred3fOmvc9dXackUsAS9OX1gEWuA+uwTr008
         GZhaUl9p+R2B0AkBB/AuLuIdHHpFrPfiPMkJfnVmfWU+EAENuBGMJZm3eBlD9+6yk42k
         mOLA==
X-Gm-Message-State: ACgBeo2oDqITane6Kux9IEqm7vF3kjIv4bTXaEFRwul3TMgiFfX10eOg
        Az7hd/hGmambK9Qky24CDi0=
X-Google-Smtp-Source: AA6agR7uecIPoAy4JexF43f01e/Ul4jeTMonddQbm0RbqwtLyfKDXjbJXnVTFT8AB1q0vYGU0QVTTg==
X-Received: by 2002:a05:600c:2854:b0:3a3:1551:d7d with SMTP id r20-20020a05600c285400b003a315510d7dmr3400140wmb.174.1659547541214;
        Wed, 03 Aug 2022 10:25:41 -0700 (PDT)
Received: from gmail.com (84-236-113-167.pool.digikabel.hu. [84.236.113.167])
        by smtp.gmail.com with ESMTPSA id s14-20020a5d424e000000b0021d7fa77710sm18608588wrr.92.2022.08.03.10.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 10:25:40 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Wed, 3 Aug 2022 19:25:38 +0200
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
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Message-ID: <Yuqvkufu7Hu4drL6@gmail.com>
References: <20220731050342.56513-1-khuey@kylehuey.com>
 <Yuo59tV071/i6yhf@gmail.com>
 <CAP045ArF0SX84tDr=iZoK=EnXK2LsXYut3-KMkCxQO2OOhn=0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP045ArF0SX84tDr=iZoK=EnXK2LsXYut3-KMkCxQO2OOhn=0A@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Kyle Huey <me@kylehuey.com> wrote:

> > Also, what's the security model for this register, do we trust all 
> > input values user-space provides for the PKRU field in the XSTATE? I 
> > realize that WRPKRU already gives user-space write access to the 
> > register - but does the CPU write it all into the XSTATE, with no 
> > restrictions on content whatsoever?
> 
> There is no security model for this register. The CPU does write whatever 
> is given to WRPKRU (or XRSTOR) into the PKRU register. The pkeys(7) man 
> page notes:
> 
> Protection keys have the potential to add a layer of security and 
> reliability to applications. But they have not been primarily designed as 
> a security feature. For instance, WRPKRU is a completely unprivileged 
> instruction, so pkeys are useless in any case that an attacker controls 
> the PKRU register or can execute arbitrary instructions.

Ok - allowing ptrace to set the full 32 bits of the PKRU register seems OK 
then, and is 100% equivalent to using WRPKRU, right? So there's no implicit 
masking/clearing of bits depending on how many keys are available, or other 
details where WRPKRU might differ from a pure 32-bit per thread write, 
correct?

Thanks,

	Ingo
