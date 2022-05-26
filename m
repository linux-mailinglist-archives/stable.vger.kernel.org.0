Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141B4535144
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 17:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243709AbiEZPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 11:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244797AbiEZPP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 11:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D3B2C13D
        for <stable@vger.kernel.org>; Thu, 26 May 2022 08:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3555161C22
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8EEC34114
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:15:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aMjLiPwG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653578124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2pKO2B/FLHpy550eky3ZackpsK23gcjJkOHAblwE/WI=;
        b=aMjLiPwG9Pi4idYQxQhrADYN9p8AeTNu7peO91v/sObasNOUNw3XrmEKc2XO8GR4wS66H+
        TiMNTn7+INAyGkpzU/j4wPwp3bEXAT0EuCSJuCQPeHZ3Bgk/EBXNvomJmTz5C0Iw6ujd64
        ppSr55FCa5foT6I/+Ll9NdYAu64v2w8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 070957f1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Thu, 26 May 2022 15:15:24 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id z7so3373389ybf.7
        for <stable@vger.kernel.org>; Thu, 26 May 2022 08:15:23 -0700 (PDT)
X-Gm-Message-State: AOAM5305+WHxjDoA9oc8+Kb/W407s/W6TgjWsOvZsIuA5byuh9MlEfte
        JYElLB5IB9xRzQOXJzhrJDI2/ZlZxx7qyK/gKVY=
X-Google-Smtp-Source: ABdhPJwmsB2B1PYgO3IBAlnp/YqlFpuzSFta1Aq+RnoPJktzYaXnjfIKhTCGUbVP1I7fLffjIzy0bbxcx2S24nJKac0=
X-Received: by 2002:a25:2d3:0:b0:656:2671:6b20 with SMTP id
 202-20020a2502d3000000b0065626716b20mr6674005ybc.373.1653578123206; Thu, 26
 May 2022 08:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <YouECCoUA6eZEwKf@zx2c4.com> <YouNwkU/8+hRwz9s@kroah.com> <Yo+SOpVZisR8iGG1@kroah.com>
In-Reply-To: <Yo+SOpVZisR8iGG1@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 26 May 2022 17:15:12 +0200
X-Gmail-Original-Message-ID: <CAHmME9oHuKcokorkRt9x264Be612Sh2iQrELveAzL1Yz6dhy5w@mail.gmail.com>
Message-ID: <CAHmME9oHuKcokorkRt9x264Be612Sh2iQrELveAzL1Yz6dhy5w@mail.gmail.com>
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 26, 2022 at 4:44 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> I get build errors in the 5.15 and 5.10 trees when applying these
> patches.
>
> Here's the 5.10 error:
> In file included from ../crypto/testmgr.c:32:
> ../include/crypto/drbg.h:139:38: error: field 'random_ready' has incomplete type
>   139 |         struct random_ready_callback random_ready;
>       |                                      ^~~~~~~~~~~~
>
>
> And the same error in 5.15.
>
> So obviously I can't take them, I'm doing a simple 'make allmodconfig'
> build for these trees on x86-64.

Sorry about that. I've fixed the broken backport (of "random: replace
custom notifier chain with standard one") and force pushed
linux-5.10.y and linux-5.15.y branches.

Jason
