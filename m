Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268F238CCD1
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 19:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbhEUSBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhEUSBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 14:01:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5372EC061574
        for <stable@vger.kernel.org>; Fri, 21 May 2021 10:59:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so7744707pjp.4
        for <stable@vger.kernel.org>; Fri, 21 May 2021 10:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WvnbS4IVZhECF51z6O+EfBBe87ZTqf6cbpg5WnJxJSc=;
        b=dRa+q4djh2zWgsZsG80B8J00y/BYlEh4KnODAALlDl6ALDWnGO2ZWZvDRGfrs948mW
         IdQF3TyoEgErcIHsHN/PQIcBxYgYdxfvYktPTaZJ6arZDaRW7Wxqid4ZxuyunuxU39Kk
         rsYiltUpO/o400ktq/z/L2SyyiawsfLpXN4xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WvnbS4IVZhECF51z6O+EfBBe87ZTqf6cbpg5WnJxJSc=;
        b=t8izR3jco461Vzzv/3ojRKV6qjj0nLmbPPN4WSTep3ciBXx/m4VY0dwnRb1XD0YEca
         6SjCmO1DDNApOKm/ZJqd4cJG8XQ6BSXq/RVNbKqZuxXDlKpN3Wl6HV/d3e/OKcYNerzG
         X3hMbow1DsxTTMRrEybCHjE8IMYjSa8LbWFVuOSQXPnuwHeM08kRPnHCeo+3hqzaNI37
         9FVIXx+dQhPa17dK2c9BS89XGRgaeEF7cNsKRxeozCvV9S4SSBI8+s8+SeMS/FicULHV
         s96LUx57ncMfyXy43+rmH6IYn56yVGCt9VDP+NsIMwO+jZkD2Wk6z94+Rchm1xo3q9pF
         0UcQ==
X-Gm-Message-State: AOAM532U8EnqrqVeaZS32L0k/4gk4S9vjCvK/jsYCCsaXwKPafIjNYJG
        mps1triTwbQmkivWrXpAv+9ANg==
X-Google-Smtp-Source: ABdhPJzBxhmutnAM94ho9VxOqH7WslOekEyezmP+aJAEVSUnTsp8WNLP0bzekNRAJeF64PcP78udBg==
X-Received: by 2002:a17:90a:9d88:: with SMTP id k8mr12209792pjp.64.1621619984833;
        Fri, 21 May 2021 10:59:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s5sm206280pjo.10.2021.05.21.10.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:59:44 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     x86@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Kees Cook <keescook@chromium.org>,
        clang-built-linux@googlegroups.com,
        Anthony Ruhier <aruhier@mailbox.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix location of '-plugin-opt=' flags
Date:   Fri, 21 May 2021 10:59:10 -0700
Message-Id: <162161994470.2028902.331062863146834934.b4-ty@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518190106.60935-1-nathan@kernel.org>
References: <20210518190106.60935-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 May 2021 12:01:06 -0700, Nathan Chancellor wrote:
> Commit b33fff07e3e3 ("x86, build: allow LTO to be selected") added a
> couple of '-plugin-opt=' flags to KBUILD_LDFLAGS because the code model
> and stack alignment are not stored in LLVM bitcode. However, these flags
> were added to KBUILD_LDFLAGS prior to the emulation flag assignment,
> which uses ':=', so they were overwritten and never added to $(LD)
> invocations. The absence of these flags caused misalignment issues in
> the AMDGPU driver when compiling with CONFIG_LTO_CLANG, resulting in
> general protection faults.
> 
> [...]

(I've slightly adjusted the title.)

Applied to for-next/clang/features, thanks!

[1/1] x86: lto: Fix location of '-plugin-opt=' flags
      https://git.kernel.org/kees/c/5d6c8592ee5f

-- 
Kees Cook

