Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70304FE814
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 20:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244910AbiDLSgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiDLSgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 14:36:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17314EA12
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 11:33:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c12so2252121plr.6
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 11:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIORrv+/2LRk4nx6ozs3wWj/aKmJXy1Yh96OLl5WUNE=;
        b=T/14KOgusZu9tE7Blvj716S2MXYnWYGVXdWWFu+K6ZQDeNHFwkMMIHNUFluS3bodzj
         /tNQdZvWhxuJ0PLZ+WAjbo9t4/nnirzb7Ha22W5twpHPDukCX+a7chuh2iMg/+hoCCnq
         EvOCgHo5h9VByatHhCI8kqXmIR668+T8d9bj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIORrv+/2LRk4nx6ozs3wWj/aKmJXy1Yh96OLl5WUNE=;
        b=caDC7LWN7DDT/hWiN1sqd3u35DZVqSpSFbyrBgyD95DGaXUjJ+yF2N4/4niJdTEZU1
         oiXnWFobzGVArXQ8ZzT9DA4DSzJ7lfN2Vv3hcEWruWdDLRlQo0Ppj9Sv0ui1GKshnkbE
         0BvhDrzUAdF9H8MCnMvzIUeEts/xFgQjRSvqg3wehQ0VqOcH/R785fykTWGFZAHQTEB7
         JzNuY+Aos+cnO0ejJsN+JcIqDv0gO9R3QC3TkHR5S4EUBl2iMvjdehk0CcFbPHDuDlm4
         pHmET97kKGtWxpjjKdFUBtGdMS6R+HJTqzdNXbSyg16k0yGdv/9aMrgUVevzn5rb/vo4
         BrJg==
X-Gm-Message-State: AOAM533sQC7n9udcSFOUuHAxnfPvkY4UIeBPIJB5AV33Y2rWQ8zta4Qt
        VuoLkaKecd0zO1LpGkg89zCz0A==
X-Google-Smtp-Source: ABdhPJwqcoomSOwjtJV29/CjOi1tnfkh4AfcHk1QUOr0hmpLGP9VH5eKPVzKPHi8RM6bXgAHa+o/9Q==
X-Received: by 2002:a17:903:2284:b0:154:3b97:8156 with SMTP id b4-20020a170903228400b001543b978156mr39323752plh.95.1649788434440;
        Tue, 12 Apr 2022 11:33:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j18-20020a633c12000000b0038204629cc9sm3597529pga.10.2022.04.12.11.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:33:54 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        PaX Team <pageexec@freemail.hu>,
        linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4] gcc-plugins: latent_entropy: use /dev/urandom
Date:   Tue, 12 Apr 2022 11:32:48 -0700
Message-Id: <164978836579.3579300.2356881730976056198.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220405222815.21155-1-Jason@zx2c4.com>
References: <CAHmME9pV4SdoSyMq4kax3w3Vu1nPxjO3faCZKq8d0RDo8t731g@mail.gmail.com> <20220405222815.21155-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Apr 2022 00:28:15 +0200, Jason A. Donenfeld wrote:
> While the latent entropy plugin mostly doesn't derive entropy from
> get_random_const() for measuring the call graph, when __latent_entropy is
> applied to a constant, then it's initialized statically to output from
> get_random_const(). In that case, this data is derived from a 64-bit
> seed, which means a buffer of 512 bits doesn't really have that amount
> of compile-time entropy.
> 
> [...]

Applied to for-v5.18/hardening, thanks!

I dropped the version number change, added a pointer to the GCC bug
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105171, and noted the
rationale for the buffer size. I'll get this sent to Linus shortly.

[1/1] gcc-plugins: latent_entropy: use /dev/urandom
      https://git.kernel.org/kees/c/c40160f2998c

-- 
Kees Cook

