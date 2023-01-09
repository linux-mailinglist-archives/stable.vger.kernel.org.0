Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A755E663180
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 21:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbjAIUbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 15:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbjAIUbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 15:31:08 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D65183A1
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 12:31:02 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id c82so2454448ybf.6
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 12:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=owP5FI071urUYEG4YIMMtTgFu7hLjIgCzMcnvRghbQA=;
        b=JDVzhQNLZcCFz+rWMr81Twg7r2thC0rtpQFU1sMgSxDOdOWOesRzvikC2JfR3or9EG
         b60mbkEC1CEy8n9z5ocY0vJXAZOr4kT7B8tV+sxRv1TAP5YVzlwGZxURBJMfeyuOnBRE
         hffXW/U1JqtYPVRNQ0nKdoSLm6wfDCeIE6s8gLlwGch+RA5Sq/fa/er3OZbMMuiVbJqL
         fh/E4RzZoAIreVZD9OuKmz1WRTrDHuYrO2bOohe8KdeJ3w4yyDV2VnC5kS6+ilLNbOfp
         aA0qEA2e2BUbFVfG5nXJNzp38SamISjUiLMwTyoR9/+zGVbPf7fqxfWXDxYis1cKM/JG
         ItXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=owP5FI071urUYEG4YIMMtTgFu7hLjIgCzMcnvRghbQA=;
        b=5QPmFMsclYChzhyQ8w9dlVuHMeTPAXbVtTQpPvEIJCyR20gPTY7DUffzFABB9PBHiI
         PLWFjFmBAKswSdNNB60LI8oSBoCmeKn9cUzof8vg2ijpmofoTwNOJdnO3kRvNs5MEwHl
         ZGnwlcH1cN/tK0LE0N/K0Ys2fdcbs6ldhqu65x+0cjSQ9kzAf4UrgvI+Y37oYs8N6pfg
         aeaEPPrWEyhStbyZWNX0cS5j8rAprLwgu7xgly3uXlKOd3aDbaFe7AfAR1DDdEr5zUhq
         9Noiz5JxvyJZpyucwa6oSDsn9ISeb25NLdOdJIWMvPMFbH/Bi5/0KsCbnt0s7k+rZcEO
         q9wg==
X-Gm-Message-State: AFqh2kpAFTThUaedR9Nrz7P5Xu3+6Sy2k0vzGqfxUU4u4BiwLCXs3Ath
        gIaX1tS0u/MPziFmVKJ2QDcVnqFFUd9QJ9/jfzrFwR58PPsQreF6
X-Google-Smtp-Source: AMrXdXvE1xU1JWUNaCj8WsVLtOIg5ZPnkmBcJNIOJLjr7XyfZjZl4ncMM4PXam0ogstyIgZDfjYX4ylQ7GVNWLyz+BY=
X-Received: by 2002:a25:d913:0:b0:7b9:1065:16f9 with SMTP id
 q19-20020a25d913000000b007b9106516f9mr1271559ybg.114.1673296261537; Mon, 09
 Jan 2023 12:31:01 -0800 (PST)
MIME-Version: 1.0
From:   Kyle Huey <me@kylehuey.com>
Date:   Mon, 9 Jan 2023 12:30:50 -0800
Message-ID: <CAP045Aq6pgaimrV9DCJUnweWtJTRGyULf7vTAftuCCrdDWzRCg@mail.gmail.com>
Subject: Please apply fixes for PKRU/ptrace interaction to 6 series stable kernels
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

The following commits fix a regression introduced into the kernel in
5.14 (in e84ba47e313d). Please cherry-pick them for both the 6.1.y and
the 6.0.y branches.

6a877d2450ac x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
1c813ce03055 x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
2c87767c35ee x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
4a804c4f8356 x86/fpu: Allow PKRU to be (once again) written by ptrace.
d7e5aceace51 x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU
bit is not set
6ea25770b043 selftests/vm/pkeys: Add a regression test for setting
PKRU through ptrace

5.15.y requires adjusted patches and will be sent separately.

- Kyle
