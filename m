Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74B5621B57
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 19:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiKHSAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 13:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiKHSAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 13:00:23 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77234252A3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 10:00:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p12so9358701plq.4
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 10:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srOBYBXjJ0LyLH8d270eQqxw6HUjH3xiNMOvx7A4gsY=;
        b=eENReWR7gzXXy1BAqG4WBmwK5FBnPlzeaSmQ7VyJQ6ab5Emvzcajwytz1OeD9nQw6B
         CljEKaLIYxRyNzkOqoDmiaCUOTNRyJred4Ed0aTA1PCqRPe9GF+4+LNex7NhRR4O13gO
         f3kGCD7CbeuIEkaBwAO3dkqMwPsAEJeZEEwk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srOBYBXjJ0LyLH8d270eQqxw6HUjH3xiNMOvx7A4gsY=;
        b=3ZlpNpXNI5Sw/qE1UOvsBW6MZQ6sdtnSe0Sug2aFtoFjXLydFAAgUoX5sWW2PfH8Ek
         apKvdxORmDt+Cno0M3n8Ej7oLrfxduq/KDMMBu6LyhA1VEf9rFRuw58R+YGX/qw4pce0
         mgzdS5MicrqkIJw2vWBR1EA0yKv+EKFkPIpefZidCBjo4gTz8NHF8JXlZgFC0R2VTpYz
         IM0tEtoSvZ3sKTqfZNNHmtbXPFu2AsdQLfMMzgPcJdmmUOw3Sg3ItGFhzJAtd240aOwc
         J9e80bnxxWw5rCL6bI5jOp/dSsR64XUrr7J53RksfOJIAvNwB3iiCHGaUtg1LBN+5njS
         dQWA==
X-Gm-Message-State: ACrzQf14PkERyRN6b/lni5bTvePXjExdnKw+qXbGaVujH1t/iTBIjwnA
        d9fmgGeV0Z953N6HbdGyrkjLHw==
X-Google-Smtp-Source: AMsMyM68d5KjRap1Sfn/jTCJoUToFAGz7kZJJpw1g1YLwciHjbTY76YfuFElI8B88ypVmLhlta1JOA==
X-Received: by 2002:a17:902:e5cc:b0:187:2b02:969d with SMTP id u12-20020a170902e5cc00b001872b02969dmr44540139plf.9.1667930421991;
        Tue, 08 Nov 2022 10:00:21 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h3-20020a63df43000000b0046fd180640asm6040904pgj.24.2022.11.08.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:00:21 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     nathan@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-arch@vger.kernel.org,
        xiafukun@huawei.com, ardb@kernel.org, zhaowenhui8@huawei.com
Subject: Re: [PATCH] vmlinux.lds.h: Fix placement of '.data..decrypted' section
Date:   Tue,  8 Nov 2022 10:00:17 -0800
Message-Id: <166793041556.1591113.6967612003001783225.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108174934.3384275-1-nathan@kernel.org>
References: <20221108174934.3384275-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Nov 2022 10:49:34 -0700, Nathan Chancellor wrote:
> Commit d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
> fixed an orphan section warning by adding the '.data..decrypted' section
> to the linker script under the PERCPU_DECRYPTED_SECTION define but that
> placement introduced a panic with !SMP, as the percpu sections are not
> instantiated with that configuration so attempting to access variables
> defined with DEFINE_PER_CPU_DECRYPTED() will result in a page fault.
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/1] vmlinux.lds.h: Fix placement of '.data..decrypted' section
      https://git.kernel.org/kees/c/000f8870a47b

-- 
Kees Cook

