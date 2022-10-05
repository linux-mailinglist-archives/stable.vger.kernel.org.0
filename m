Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514DF5F5CAF
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 00:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJEW31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 18:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJEW30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 18:29:26 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827AB8169A
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 15:29:25 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id r15-20020a4abf0f000000b004761c7e6be1so237030oop.9
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IdkuvjBUbeHkaiG0+XBbrzXdoM1HyeZk+D9Bg+bbKPc=;
        b=JNMgFT3KrKKXzs2XiDGSfxRJzMq0LNHvNCk+JsXvVYgydj3yK6myFJ1ZI6Gr3w47er
         DJacrYPYvuxZxs2ApPWYfVhMcAVLIGz28lgKLF4O+jjtQ1ym7WH1z220irgY+Dif6vt7
         t3DXXZCin/snhZQR26QjR3GyxT7xjmOSU5emxzq4Y2EUwcYasYGfnQ1112ZEQcv9eJVI
         v9CdynC1A0mnR62VSn2JD0WlJPXXz8Q6joU/XTPFSbv3u4sBZXBmV3+OzQdMQDKJOje5
         9OwH6uopFLYZy4NLWwF71oJDyef5foghto+wCgDDoazJP4GAnt2vzSC+hxCYyYXGNvBa
         fmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IdkuvjBUbeHkaiG0+XBbrzXdoM1HyeZk+D9Bg+bbKPc=;
        b=fZK4olVLcCBzl77L+jktIB49wap1TIe2oA6VKbJ0MZcs5+z2EwFl3x3gjCz1CZPBhA
         RPdKsrL+4OTbDzlV9wotZaExE2l0ad9nYURc1yXteBKqv2z7BRqw/ZhiikRHjqUKqcz6
         gDs+ZuPom4PsFiTIdal6tsL89o/0cVfW0dWNfazvEKOqrzg/CMu2FO8DbdtBMR+yTqu7
         F/8Nk1mpyso1JKmwUxysNVNCadOIMuAheJLf9bI2GYPlXfr/kid4LmXhLXadKhExs9vA
         xt+mGcehS4JNkWC+PXtAiEMn9exl0SOPoSV5dUCfn8kpgkavmyC4y5s6LNx2FHFMU5s8
         Z7lA==
X-Gm-Message-State: ACrzQf28mrrxR+UD0ecWWEvnrqDYIoGCOP+c3m7U5RN0tNuDr5m+80X9
        9IXhdXU8luWKg4zP5rKlVlffqgUd+UpuTWcO5oJfkg==
X-Google-Smtp-Source: AMsMyM4NYYmVUqY0Yw6YDhzHckTU04BAKE6QDHYrnmq/ZMZz9nvrSDz8kSstf/sMpvSoYhASP5wOXwV9Tn1QOXaYBlA=
X-Received: by 2002:a9d:6296:0:b0:656:761:28bc with SMTP id
 x22-20020a9d6296000000b00656076128bcmr705288otk.14.1665008964643; Wed, 05 Oct
 2022 15:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221005220227.1959-1-surajjs@amazon.com>
In-Reply-To: <20221005220227.1959-1-surajjs@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 5 Oct 2022 15:29:13 -0700
Message-ID: <CALMp9eTy2w_ZbkVSVvTwOW3wYH6vnn5waEWc0BesXL-kYRFy4g@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with WRMSR
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     kvm@vger.kernel.org, sjitindarsingh@gmail.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@suse.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        jpoimboe@kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, benh@kernel.crashing.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 5, 2022 at 3:03 PM Suraj Jitindar Singh <surajjs@amazon.com> wrote:
>
> tl;dr: The existing mitigation for eIBRS PBRSB predictions uses an INT3 to
> ensure a call instruction retires before a following unbalanced RET. Replace
> this with a WRMSR serialising instruction which has a lower performance
> penalty.

The INT3 is only on a speculative path and should not impact performance.

> == Background ==
>
> eIBRS (enhanced indirect branch restricted speculation) is used to prevent
> predictor addresses from one privilege domain from being used for prediction
> in a higher privilege domain.
>
> == Problem ==
>
> On processors with eIBRS protections there can be a case where upon VM exit
> a guest address may be used as an RSB prediction for an unbalanced RET if a
> CALL instruction hasn't yet been retired. This is termed PBRSB (Post-Barrier
> Return Stack Buffer).
>
> A mitigation for this was introduced in:
> (2b1299322016731d56807aa49254a5ea3080b6b3 x86/speculation: Add RSB VM Exit protections)
>
> This mitigation [1] has a ~1% performance impact on VM exit compared to without
> it [2].
>
> == Solution ==
>
> The WRMSR instruction can be used as a speculation barrier and a serialising
> instruction. Use this on the VM exit path instead to ensure that a CALL
> instruction (in this case the call to vmx_spec_ctrl_restore_host) has retired
> before the prediction of a following unbalanced RET.

I don't buy this solution. According to
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html:

"Note that a WRMSR instruction (used to set IBRS, for example), could
also serve as a speculation barrier for such a sequence in place of
LFENCE."

This says only that you can replace the LFENCE with a WRMSR. It
doesn't say that you can drop the rest of the sequence.

> This mitigation [3] has a negligible performance impact.
>
> == Testing ==
>
> Run the outl_to_kernel kvm-unit-tests test 200 times per configuration which
> counts the cycles for an exit to kernel mode.
>
> [1] With existing mitigation:
> Average: 2026 cycles
> [2] With no mitigation:
> Average: 2008 cycles
> [3] With proposed mitigation:
> Average: 2008 cycles

What testing did you do to see that this is an effective mitigation?
Improved timings are irrelevant if it doesn't work.
