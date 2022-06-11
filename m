Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0CE5475D3
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiFKOxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbiFKOx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:53:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E5CF0F;
        Sat, 11 Jun 2022 07:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE2060C20;
        Sat, 11 Jun 2022 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6AEC34116;
        Sat, 11 Jun 2022 14:53:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QXa8KogU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654959201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bKbSeBuOdlxWzcVReKbVmpA4lJrc6qzgy7XqD/6bAtw=;
        b=QXa8KogUbmnrgICN3mIIm8wPs35V15sU96OJDtVFHsctRC1k8Ogwr/yqw3wXdVHqZjDjmY
        UsNnupyvqNMVzsNmWNeY/PxXlVFmUQmOxc20onLXrCjbYy6bhS2sBnkLkH29WsF88NXR7J
        ab60omI0X6zWmRMVlT8TUz8xp73jQOM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e5c205e2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 14:53:21 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-30c143c41e5so15895497b3.3;
        Sat, 11 Jun 2022 07:53:21 -0700 (PDT)
X-Gm-Message-State: AOAM530ZJ2vBDuR84TCVEXVfWKTrTddFctKg0ZNBfoMJ6iNfV6zZC9/c
        Aqrp6zlEeH5eGkVvt8I0ZFjfFaqtM69mgkuwhP8=
X-Google-Smtp-Source: ABdhPJwVIznr3iPBOVShCFe6E/BZjiQuHFZfe/9f5Zu2mD9Vr+9h/iopjzg3V+juSXJQ+5DDeqF6O5Ha5SbJHQXwPrs=
X-Received: by 2002:a81:4887:0:b0:30c:40bd:3e7b with SMTP id
 v129-20020a814887000000b0030c40bd3e7bmr55918247ywa.396.1654959200598; Sat, 11
 Jun 2022 07:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220611100447.5066-1-Jason@zx2c4.com> <20220611100447.5066-4-Jason@zx2c4.com>
 <80cca718-d637-b48a-ddb3-e6931cd08c24@csgroup.eu>
In-Reply-To: <80cca718-d637-b48a-ddb3-e6931cd08c24@csgroup.eu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 11 Jun 2022 16:53:09 +0200
X-Gmail-Original-Message-ID: <CAHmME9ortseAax04+h1TVZAWEYN0uVDAkhzTrBZnQnWzj9xn6A@mail.gmail.com>
Message-ID: <CAHmME9ortseAax04+h1TVZAWEYN0uVDAkhzTrBZnQnWzj9xn6A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] powerpc/pseries: wire up rng during setup_arch
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

On Sat, Jun 11, 2022 at 4:45 PM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
> There must be a empty line between declarations and code.

Ack.

> Prototype has to go in a header file

Already voiced disagreement about this in the other thread.

> and should be pSeries maybe
> allthough camelCase in throw up on.

All the rng.c functions use pseries_ in lower case, so I'll stick with
that, as that's where the function is defined.

Jason
