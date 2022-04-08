Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E134F90FF
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiDHImB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiDHImA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:42:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFDC25286;
        Fri,  8 Apr 2022 01:39:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b15so7818667pfm.5;
        Fri, 08 Apr 2022 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V5DMYegRGGGrvLJGYRIFDIFxu5W5SILxKBy8IdkRB5k=;
        b=SOXNIESiSn8Wqd0OO6NKECbj+4aLsDWb0E+y9eEd7QeXMM1vlCT6/8XVhxRZ3KdFi3
         Rhhdf2yTt9ZumuCi5qw9C2Rdro3XEwFXjqapofkfCg42mLM9I41I0mmV/7lRvV/C6wah
         ElGR6fwiUYeYEz6KmurzyKzdGTVDxkox69zSCDzGRlvFIf/m0lWwbgn5vafm7A6Ha85f
         jSvS4QnjQugsZ47R7GyaLRtDOM0WK9MNKctiYL0fx3442wExMQfClwn5EI/8k7uyK60D
         9GA31uSNh4aP2VZO721+lDV4/pGykHJ+ZqbVpOA/qEswvUd4xumGZ3q5U0BPoIGlyLYg
         Aldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V5DMYegRGGGrvLJGYRIFDIFxu5W5SILxKBy8IdkRB5k=;
        b=K82Ymq/PsF7zDW5sCsfSe9fdRrNWOoJqh6M6PM2Ha7+xT96XSMuGP4Q9ybQZ0VP9hB
         MrAweQrbeXzLQdDIwG0VjFTMnuNhIV/D/CdfK7tfNjXLicSsAoCnVYfI/IvzVyTKnkkw
         JT09qnRfXOIoUgpfbqNHift7zPwS9G19XfZq2bbTdsvQtpQycDuPbaQVVZ8jTUwU6/XZ
         Gq6BgqCwwZy6uXXnMU/lEPjxBo6M+ZLueBll48y5u8CbFmaSt4GIz1SYCj2c4tjG56PU
         zhpx8xT7MQTmIywbsXBYg7bRDoWM7axSvaYgHLXqNB1nxKsbg5Jghz46DB+8En1GSnjT
         A9Lg==
X-Gm-Message-State: AOAM530hCVaaFpfnY34rHu5kxlpp1qyw4yrpsMMjglhWoOv6YGjgVGWy
        x2jPfU2x3Y7lnkIYKuo6UxM=
X-Google-Smtp-Source: ABdhPJyZpiVlMXwaGsnFkhtFrFHk0tDhdJ24lU257KGluptksTLUp9MbtVxnzCsz78sn5CD/MsGPOA==
X-Received: by 2002:a63:9d8f:0:b0:398:dad:c3d8 with SMTP id i137-20020a639d8f000000b003980dadc3d8mr14822781pgd.228.1649407196938;
        Fri, 08 Apr 2022 01:39:56 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id s16-20020a056a001c5000b00505688553e1sm4631722pfw.57.2022.04.08.01.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:39:56 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, rgoldwyn@suse.com,
        stable@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH v2] md: fix an incorrect NULL check in sync_sbs
Date:   Fri,  8 Apr 2022 16:39:35 +0800
Message-Id: <20220408083935.25816-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAPhsuW6S=PJsgVR=OkObMvs9uJ2QA3LFe+ZH8XtEyKRFh7XxHA@mail.gmail.com>
References: <CAPhsuW6S=PJsgVR=OkObMvs9uJ2QA3LFe+ZH8XtEyKRFh7XxHA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Apr 2022 17:36:48 -0700, Song Liu wrote:
> On Mon, Mar 28, 2022 at 1:11 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> >
> > The bug is here:
> >         if (!rdev)
> >
> > The list iterator value 'rdev' will *always* be set and non-NULL
> > by rdev_for_each(), so it is incorrect to assume that the iterator
> > value will be NULL if the list is empty or no element found.
> > Otherwise it will bypass the NULL check and lead to invalid memory
> > access passing the check.
> >
> > To fix the bug, use a new variable 'iter' as the list iterator,
> > while using the original variable 'pdev' as a dedicated pointer to
> 
> s/pdev/rdev/
>
Have fixed it in PATCH v3, please check it. Thank you.

> 
> > point to the found element.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 2aa82191ac36c ("md-cluster: Perform a lazy update")
> 
> "Fixes" should use a hash of 12 characters (13 given here). Did
> checkpatch.pl complain about it?

Have fixed it in PATCH v3, please check it. Thank you.

--
Xiaomeng Tong
