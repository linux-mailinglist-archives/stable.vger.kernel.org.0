Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82A86747F7
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 01:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjATA07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 19:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjATA06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 19:26:58 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B97A297F
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 16:26:56 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g68so2923305pgc.11
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 16:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r62mI4Hdb7OvtubTfDK21uFvf5aPUhnIoPblGNN+bbY=;
        b=g+qayvoMIw+dfkhFqGMfysfuKmYArIDGlXekcsu+7WTuDz0ZQnQzAEWoP7lCYlCHgc
         dsUwzsSS3vCdPK8JHdWxZaCL6eE6wOiwNqmPqtpKDU+6T4zsKIMP2wQ/Iv+eNk+oqKTM
         R4USK2Qh8X0sUtEzqsMslEDd+cr7xLqljStNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r62mI4Hdb7OvtubTfDK21uFvf5aPUhnIoPblGNN+bbY=;
        b=BpidGQCMRFZ7Ae6+yVxfm2VKAjrQ2manutLd3PMR7ivJSqbJFVkO82B9JuKn6L2Vhx
         J6JpQnng6TAi/BCrtKvumSOabW8dFT3RqPSyzXO4CL97ldjFF7NofY9p+hsHF1ax7L1C
         oXkXqnBQL/5ye+1X4yd7OiJiL5QfuL65UxjQeCQY+xiMytT0pji0Xh08GTHqFTXgUkaI
         oNcWhHxNnl8EyXdITaOYbb39vl8nWlqhF+FDSj2v0cC87N7YcK8mKxVNI4gERweG8z97
         AHPj9KZQHYi5pINV0ZtJ9sc5vTTzg154bt629cvVKFw7trSJl1JeP59d75psF6jV0qUg
         0i0A==
X-Gm-Message-State: AFqh2kqxudazrsjxu4CjaddtRGfuv3j0+6LOrBOoLcnKAdoy/dRRlv1P
        Ya+27zGW5NzQ1DAH9SCW/LCTbw==
X-Google-Smtp-Source: AMrXdXs+vSEGIi0uhxygnrdZmzY5xUrg5Ob9gUucJutSepSjFr1+J5O3roCZeFMbehXldQ3cpJJb0Q==
X-Received: by 2002:aa7:850c:0:b0:580:ccae:291c with SMTP id v12-20020aa7850c000000b00580ccae291cmr13558642pfn.24.1674174416479;
        Thu, 19 Jan 2023 16:26:56 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u64-20020a627943000000b00581816425f3sm24520765pfc.112.2023.01.19.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 16:26:56 -0800 (PST)
Date:   Thu, 19 Jan 2023 16:26:55 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Please add oops_limit to -stable
Message-ID: <202301191532.AEEC765@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'd like to ask that the oops_limit series get included in -stable
releases. It's a recommended defense developed while writing this
report:
https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html

I've had a few people ask about having it in -stable, for example:
https://lore.kernel.org/lkml/20230119201023.4003-1-sj@kernel.org

This is the series:

9360d035a579 panic: Separate sysctl logic from CONFIG_SMP
d4ccd54d28d3 exit: Put an upper limit on how often we can oops
9db89b411170 exit: Expose "oops_count" to sysfs
de92f65719cd exit: Allow oops_limit to be disabled
79cc1ba7badf panic: Consolidate open-coded panic_on_warn checks
9fc9e278a5c0 panic: Introduce warn_limit
8b05aa263361 panic: Expose "warn_count" to sysfs
00dd027f721e docs: Fix path paste-o for /sys/kernel/warn_count
7535b832c639 exit: Use READ_ONCE() for all oops/warn limit reads

For v6.1.x they apply cleanly and behave as expected.

I'm hoping someone can step up and do backports for v5.15.x and earlier,
as there appear to be a number of conflicts and I'm swamped with other
stuff to do. :P

Thanks!

-Kees

-- 
Kees Cook
