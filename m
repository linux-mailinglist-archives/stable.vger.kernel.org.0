Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D025475D5
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiFKOx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiFKOxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A1612090;
        Sat, 11 Jun 2022 07:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36B4260FFA;
        Sat, 11 Jun 2022 14:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EFAC34116;
        Sat, 11 Jun 2022 14:53:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ep5VjlLv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654959231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9pqfqYStan/I+ZPRU4QEBBVfKsXKknoHw/gVA4DBjss=;
        b=ep5VjlLvDgxBMrb0h9f9JrT35RB1zn2rbsrUgslarBPtas7cBJ1ZLsk3D/xzDrpcfcYD0i
        kqf+3Xt+sJ536d2iof0NVOp1/8L0rwGzD81sGSPt0Et3cvuthS3HcOGyG8+J2Z+quPIjlN
        T81N5n3ZNav3mNQDOKb7Gk4l0MTowCU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8aa3d6ca (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 14:53:50 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-3137316bb69so15581537b3.10;
        Sat, 11 Jun 2022 07:53:50 -0700 (PDT)
X-Gm-Message-State: AOAM532oWWUMgPkyrZYAG4wSjbnkpZdazf929SFO6izSNHp2wF5LAXSb
        OqStlJldFiC4Ui0Sm/ThfxKvWaNmYut658W+yUE=
X-Google-Smtp-Source: ABdhPJwgmnQjNeYtkfIN6xGH9ZFfcVbNxRhMGQJjaIN0Dh1KWfZ5lVm1oeHb/OBW4MjKj2SuINtm8f6mvvXx4Gwkyek=
X-Received: by 2002:a81:6c04:0:b0:313:c938:ba1b with SMTP id
 h4-20020a816c04000000b00313c938ba1bmr7414813ywc.231.1654959229974; Sat, 11
 Jun 2022 07:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220611100447.5066-1-Jason@zx2c4.com> <20220611100447.5066-2-Jason@zx2c4.com>
 <6432586f-9eb9-ac71-7934-c48da09a928e@csgroup.eu> <CAHmME9rBWcdZtJCQ1WZAPOJtnA6u4w0ub4s4M+UW60gMSNgWrQ@mail.gmail.com>
 <YqSqqq0zC7yDOQib@zx2c4.com> <c94deb33-c28e-12c1-e3b1-aebd4249baa3@csgroup.eu>
In-Reply-To: <c94deb33-c28e-12c1-e3b1-aebd4249baa3@csgroup.eu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 11 Jun 2022 16:53:39 +0200
X-Gmail-Original-Message-ID: <CAHmME9pNGrSWNuYNV4jZCPiAk5NzNRt3LuZuBMhS-GVobaeiMQ@mail.gmail.com>
Message-ID: <CAHmME9pNGrSWNuYNV4jZCPiAk5NzNRt3LuZuBMhS-GVobaeiMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
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

Hi Christophe,

On Sat, Jun 11, 2022 at 4:49 PM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
> Then you have:
>
> arch/powerpc/platforms/powernv/powernv.h
> arch/powerpc/platforms/pseries/pseries.h
>
> and you can add
>
> arch/powerpc/platforms/microwatt/microwatt.h

Oh, terrific, thanks. I'll do that.

Jason
