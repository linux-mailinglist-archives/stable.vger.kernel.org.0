Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A146612D5A
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 23:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJ3WbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 18:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3WbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 18:31:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9431BB84A;
        Sun, 30 Oct 2022 15:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 036FDB8107A;
        Sun, 30 Oct 2022 22:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE9C43141;
        Sun, 30 Oct 2022 22:31:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M6/I1lYi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667169058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2GywG6lpAcDd2WsRAalzjYGY0rwGZbzqQE+CzF75DyA=;
        b=M6/I1lYioMp78g9EprBJHMzqnlaUr8Dat8eOyruKK268TUj0GyOB7uGahU9fvCAUL9AItC
        x60Rz2VX5F+Jht5oXNM5vDXzGI1RpoRNT1MAcLwey0c/+ihJ0Drv62i5CBTHrsvR5U2IPd
        49MulGAvpWO8WJpMEvhac5Jkt4yI618=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id da1bbd9c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 30 Oct 2022 22:30:58 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id d3so4494561uan.4;
        Sun, 30 Oct 2022 15:30:58 -0700 (PDT)
X-Gm-Message-State: ACrzQf2GGyj9mqov7yfnZe442ZUZIIyvLecHKCRwXaNiu/9t88ZPunP2
        JGahNKtiBPjwk0CWMj8v8EiRYIpyT1DFto6HWhc=
X-Google-Smtp-Source: AMsMyM4qXkyU9YfS8ehFIM5GvFzOTT0BoG6vK3j4Fb6gaYwGvGQze6sEZWrNYOSFOdf07k/lYZpPiQHPslGbzjnwCDU=
X-Received: by 2002:ab0:4862:0:b0:40e:c43c:f59 with SMTP id
 c31-20020ab04862000000b0040ec43c0f59mr3585891uad.65.1667169057293; Sun, 30
 Oct 2022 15:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221023195711.52515-1-Jason@zx2c4.com>
In-Reply-To: <20221023195711.52515-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 30 Oct 2022 23:30:46 +0100
X-Gmail-Original-Message-ID: <CAHmME9pDrV1P7GVg74xHTbUaVT5Lq8urvyYCgbu=sJLApwHHNw@mail.gmail.com>
Message-ID: <CAHmME9pDrV1P7GVg74xHTbUaVT5Lq8urvyYCgbu=sJLApwHHNw@mail.gmail.com>
Subject: Re: [PATCH] soc: ux500: do not directly dereference __iomem
To:     linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

On Sun, Oct 23, 2022 at 9:57 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Sparse reports that calling add_device_randomness() on `uid` is a
> violation of address spaces. And indeed the next usage uses readl()
> properly, but that was left out when passing it toadd_device_
> randomness(). So instead copy the whole thing to the stack first.
>
> Fixes: 4040d10a3d44 ("ARM: ux500: add DB serial number to entropy pool")
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/202210230819.loF90KDh-lkp@intel.com/
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Just thought I'd follow up on this.


Jason
