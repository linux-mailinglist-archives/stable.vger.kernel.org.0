Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEEB663254
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbjAIVKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbjAIVKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:10:18 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BBC18698
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:02:40 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so14128484pjg.5
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 13:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+LqvqGGpKaHxm0wZH0Ny6bz4cyOpNFDV88y2n2/SD8=;
        b=edFHcUziBZBHY2W/hdQbqT48mi/WGCLDgsNbxsq1u0VdOPi9y2if589N6cVuYA/bdU
         SFSZPa8XH6hzGsZ92nvVgyOyWABmJAs7DhCzakX/rhjm1LFvXhT6dRsyGpq2ynpeTYmS
         uMmTXjDz9t/CSE+rCfyLX6onxF/TLCpFF2dcyXD8vMYmlPFjBIQPpauU0u8Hq0i90iJd
         ofEguXxYDeIoaaDpXgRS7gTU//GLm7oulykVWeMRx+9OIBNS2Qi5Aq8SJvMF7xMq8cTC
         M9rvIk4wb6YvJxByuxcbYEjHdLIhNbMU6BU8ei4DLHJMb3JcLNtFG+s5vhrfRunsG2cc
         owJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+LqvqGGpKaHxm0wZH0Ny6bz4cyOpNFDV88y2n2/SD8=;
        b=V3ZmR3A1UDKAW8d6PcpRnVMFibFJp0KFgWi/uz5wzPvM3dOdJn/xp1HsXDPaZRCLP9
         VXjmwl7d/hXUK6pfzJ+LgszolwfyJwXSvFf/J2MBqiSob/ltjUFQt40wgs45X981MADt
         eVybfpvedPeLqSK2QcVTuWgxTdV5+v7BFhpdQeiCZoqH8Q7JhJUm3T7UDX591K609xOt
         shqzfAzEPPBkSKBP+5vO8TSLPpYCpS4RQkXWpo+iQ0r/Z9q6gVoPoMynu3anGIy3hAGj
         sjMRYO0o8Vs7vKjoUn013/OARC4WrO8/ci0NA3EQkxlhpSDfTka58R6xykohnuoT1CLD
         wh0g==
X-Gm-Message-State: AFqh2ko2VfUW0HbOUb+G78kse+T31e3LNsRy5q7PHV3dm/6MKvlC4amC
        ydbEgqtulTl30sjxl2JQTRjZMiRROJE86TC8h28=
X-Google-Smtp-Source: AMrXdXvx23Ee9uAp06ZrJQawPP42dXFYl16mTCMBM6JxGCLcgGzJWBAXdrx9rVGCTBilHtJAEMtQ6g==
X-Received: by 2002:a05:6a21:1507:b0:9d:efbe:529a with SMTP id nq7-20020a056a21150700b0009defbe529amr76765826pzb.10.1673298159239;
        Mon, 09 Jan 2023 13:02:39 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm5559482pgp.71.2023.01.09.13.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:02:38 -0800 (PST)
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
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 5/6] x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU bit is not set
Date:   Mon,  9 Jan 2023 13:02:13 -0800
Message-Id: <20230109210214.71068-6-khuey@kylehuey.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109210214.71068-1-khuey@kylehuey.com>
References: <20230109210214.71068-1-khuey@kylehuey.com>
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

From: Kyle Huey <me@kylehuey.com>

commit d7e5aceace51 upstream

The hardware XRSTOR instruction resets the PKRU register to its hardware
init value (namely 0) if the PKRU bit is not set in the xfeatures mask.
Emulating that here restores the pre-5.14 behavior for PTRACE_SET_REGSET
with NT_X86_XSTATE, and makes sigreturn (which still uses XRSTOR) and
behave identically.

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-6-khuey%40kylehuey.com
---
 arch/x86/kernel/fpu/xstate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index fe9050c60adc..8bbf37c0bebe 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1168,7 +1168,8 @@ static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
 
 		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
 		*pkru = xpkru->pkru;
-	}
+	} else
+		*pkru = 0;
 
 	/*
 	 * The state that came in from userspace was user-state only.
-- 
2.25.1

