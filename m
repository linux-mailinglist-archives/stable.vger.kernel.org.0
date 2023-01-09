Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E276663252
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbjAIVKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbjAIVKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:10:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28533F139
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:02:31 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l1-20020a17090a384100b00226f05b9595so9092193pjf.0
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 13:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BSu13JTt5o7hMMqg7U7IzYnkzOe4bOQKfXv/cqgpCA0=;
        b=D4TpZxif7nYF0shqVgP9KwAlqRID+ACC312D7ccjRpcJihEqan25UM/TIXLYyITfyZ
         e6xLnrUbXeYVvLafcrMcX9cHqcn9oL7x8TDmo/elfuJiZG/pIF5Lkq2o6xiBIB+sfv9F
         70dY31K6tDzmlTI+3sgITPQAopL3m7OShLBNcWgEu4+pBtJ3Ah/SM3/GRJM0wiV+JP+R
         YxKb2jskSq/D2+yJZhJGK43KhL8iqyvRRgfjCUsjyumzCyljfaVk/HrmLbh9HB3q2s/j
         AS1lHN5yD3f6J+EXVUYcl9Y4/qU1wTlPQEJh8UCmtj0J6Uy7OX7GAmzwIH3L2JJ0Yy6U
         vctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BSu13JTt5o7hMMqg7U7IzYnkzOe4bOQKfXv/cqgpCA0=;
        b=frSAwROeVtn0QPGuDUU3DVNlSOTMv9RFR6+uoZpXhC9VShmhNfCfgO8IZIQGLRIXKP
         PoIfrDxi2RBqdxw+qIUwooywwfapsDFIEzPeU/ygUUvaK/J0tycE+eW5csGkI4AbMuaK
         rjEyRl8d48Jy4T9iXqZqyyUk9jmgr0YKcvXx4ktmBBV6REU+6WaBsazVdWryTf1C8LJv
         aWQS3zOLy2hvx0++hpnY5LhQnLgXXtmDq0wvXP8HaYh1AHo9IZXWSxyXfJLS1DYrGSl3
         BLqfqX/yF85RClFZhdyoAwI9qJwJNTv80IxQDW1XTPWTS3ef50q1qsM8wzg10Zyj+Qs9
         7OJg==
X-Gm-Message-State: AFqh2krnHPFoXY2S54kS6Wnri4QBq3SdymMVrqSA96WRPa1LZftP+wIl
        VoYzcAaqBhykKsbVXCeutZPx+Vp4QdgWifLkBwQ=
X-Google-Smtp-Source: AMrXdXs55Q4TZUpjhsEiAzZL8J2bjVzEcx70hM43mtFScc1FtD6Vz2LadGNXYeTrkZHpzoWYC0voUQ==
X-Received: by 2002:a17:90a:de04:b0:226:c0ff:20f6 with SMTP id m4-20020a17090ade0400b00226c0ff20f6mr18004839pjv.16.1673298150937;
        Mon, 09 Jan 2023 13:02:30 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm5559482pgp.71.2023.01.09.13.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:02:30 -0800 (PST)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>
Subject: [PATCH 5.15 0/6] Backport x86/fpu: Allow PKRU to be (once again) written by ptrace
Date:   Mon,  9 Jan 2023 13:02:08 -0800
Message-Id: <20230109210214.71068-1-khuey@kylehuey.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

What follows is backports of the upstream commits

6a877d2450ac x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
1c813ce03055 x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
2c87767c35ee x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
4a804c4f8356 x86/fpu: Allow PKRU to be (once again) written by ptrace.
d7e5aceace51 x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU bit is not set
6ea25770b043 selftests/vm/pkeys: Add a regression test for setting PKRU through ptrace

Those commits fix a regression introduced in 5.14 (by e84ba47e313d) related to
handling of PKRU through ptrace(2).

The only substantive difference between this patch series and the upstream
patch series is that, because on upstream kernels KVM also calls into
copy_uabi_to_xstate(), while on 5.15 KVM has its own separate code path,
this patch series copies (five lines of) previously KVM-specific code into
copy_uabi_to_xstate() whereas the upstream patch series moves previously
KVM-specific code into copy_uabi_to_xstate(). All other changes are
adjustments for context that varies or refactorings that are newer than 5.15.


