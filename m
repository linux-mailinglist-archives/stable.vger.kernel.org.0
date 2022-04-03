Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78784F0726
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 05:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiDCD6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 23:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbiDCD6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 23:58:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B797F3631B;
        Sat,  2 Apr 2022 20:56:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so8554918pjb.5;
        Sat, 02 Apr 2022 20:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aq3tVUArEckm4a747xQx+SdBWz59m2Jh3U4GOewQ4uE=;
        b=cMW5vN9tE/Suao9f7D9zbdp4upPtBWQSC1KKYV1PiRtvawmd7puF08uAW+VQMuhdff
         +5KO2rjaSA1L1a4kHhNsbdHjVUQhwWjIytwqeGAV0DOot/vjfcw3I5Qir19Z8hNEr2Qu
         TYLwCTbz2r7UtxBz/BYvfNYsFR+AkM1jLDoHxXourRWaMwsOrOvmTUEf32PnHBBfyIoQ
         G8OOwCgaA0DKU3GfL1JHRHMrd+LVjLmoiKaCOt32cF1uzcmpT1SoOSnpXmOGkXT2r5av
         M3UqIYWFlBI+Fx67mzlm4zGZdOoetB1Ccu73yFJ1hVEQ4PA2mz7xqQl111vh4/ZpDUUs
         tvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aq3tVUArEckm4a747xQx+SdBWz59m2Jh3U4GOewQ4uE=;
        b=zbLleXVhOEr8dZCosGNf6zh2ejQKS1W+ESQv6XtZfReF2mI72iON8pe/OJTG3Oa7oT
         /CYSz9BuuNjN4Bnr96FxLdTZJuyDaCMJ0HHIOXfTotkjJbcUAD+rEs86Pu12x6lGM4Gs
         UjjmQnFL8t68Un65PLcrALlNaNIRrd+aIK1G4INHKdeuROcDuz6RPDbQOyPj5FgAn1Tq
         wPDYOxG5mWuAV52hfsLu2T+okY0JUdGBZe6/FiC6Kyh/4h5VXG4EJs5kGTCHzsuTS/ch
         n4b9bBaGH2rAkZ6/qGlYsCFN+nGxxxDzGEmQmjd1/YIxm67G1jn3mWaTA5RiS2S2FvoK
         Tkhg==
X-Gm-Message-State: AOAM5335AuPUnwHVC+VlAcinQs9aZ7AFO6ed+sdtl3rWMMBAjQSCGHQL
        NYRl9ta2fJrq9PdkhNx2ENY=
X-Google-Smtp-Source: ABdhPJxUT5CbGHWP7XJ0MkUXkzUaa9hbM7mE7aEECrruz/Rjj3hGl2iTan9I1XVfje+10AmndVSIHA==
X-Received: by 2002:a17:90b:1bc6:b0:1c7:3229:652a with SMTP id oa6-20020a17090b1bc600b001c73229652amr19831973pjb.65.1648958184216;
        Sat, 02 Apr 2022 20:56:24 -0700 (PDT)
Received: from localhost.localdomain ([183.156.181.188])
        by smtp.googlemail.com with ESMTPSA id i187-20020a62c1c4000000b004faafada2ffsm7785714pfg.204.2022.04.02.20.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 20:56:23 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     snitzer@redhat.com
Cc:     agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: md: fix missing check on list iterator
Date:   Sun,  3 Apr 2022 11:56:03 +0800
Message-Id: <20220403035603.16169-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <YkcQdjE6uTfScyEy@redhat.com>
References: <YkcQdjE6uTfScyEy@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 1 Apr 2022 10:47:18 -0400, Mike Snitzer wrote:
> Did you acually hit a bug (invalid memory access)?
> 
> I cannot see how given the checks prior to iterating m->priority_groups:
> 
>         if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
>             !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
>                 DMWARN("invalid PG number supplied to bypass_pg");
>                 return -EINVAL;
>         }
> 
> So I have _not_ taken your "fix".

Yes, you are correct. It has been checked before, thus not a bug and
no need to fix. And I have sent a PATCH v2 to use list iterator only
inside the loop, please check it. Thank you very much.

--
Xiaomeng Tong
