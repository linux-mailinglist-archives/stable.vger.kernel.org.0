Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F713621D78
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 21:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiKHUOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 15:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiKHUOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 15:14:40 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A88F627D2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:14:39 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id m22so4302958eji.10
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 12:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u17pHj0ChltDJ0D7lR/YzqX+TvSRsW0jbRS1U9lK73c=;
        b=Ekbtiq+u5vZ33TKYFeiyykEfG/k2WG03QNInCOKnhJHvL40cpVYDu+KouEa/FVWFX2
         FkYpe3Pvs73yUDEwDP9wI4zfCAN8+pT70TYsm8KvRt17pC7YBaYdD4XvILJuBXVrkPj+
         9QvcZPGMohVO2tb0IkqrHlcEbGB4Tc4l8EJWm4mXcXVRw+uwizwLsRYwrfh4CG58hpDo
         sFlpSxoNktbIrR79V196av1N53ABUaQA7ytfS4o+/p7RmZOMNsRWSZ438hD6V/ZNdj9d
         5Nrn6+uzNu9UhnL7sNxs5Pq2L3bKjKq7uRMoTu9Yp3RB8PK3zkBKSnTlm3wK/95pAM0y
         TnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u17pHj0ChltDJ0D7lR/YzqX+TvSRsW0jbRS1U9lK73c=;
        b=zZnO7F5GY7HL/iDLKgOpMKnQGholEqGm9aS6TucTntpBl9sikJBGXtbohMvd7UcU4N
         6Y0Q/30IRb0NsDiQikGhO2uRw6+oH4sF+EZKQhf0lQ0XlZhuzzxs6DhJ2kIPuWsmb9ML
         0fjVtysls/pu1OFUDIT56ogCk/E5l+K+3m8ZKk9egjueBCXLxA16EGqh5Bk6K9/NeYGZ
         piqrZSOxm3j12TulOYPJuCgwCjGns5RUhT3XSBXKMscfwJU8L+iHA3qsJcpDv2/mZKiT
         0WJ4RWJ0ENlQFUjPpTcyCmhMYjNpTs46d8Nz491VnPe+HlC9s8WQVI1w4OJ5/MBJMbAD
         E17Q==
X-Gm-Message-State: ACrzQf01FtnR2Qy5mw85SDVj9aemqU08gAeEHiWVRmmwpnZZXaf7Q+pc
        9yIl2aj8zWwlmlVsI9f/wbnaQldgHBxvQyym8PBV+wxrrmE=
X-Google-Smtp-Source: AMsMyM7tH4y/W66k6uVPP2QuiuNld4WkKliXIdH3vkHSuRWLqcfdhprHYp74pblMG6J8HHOj0SB3Ot7mm/0XVEOpwZY=
X-Received: by 2002:a17:906:4c4b:b0:7ad:a197:b58e with SMTP id
 d11-20020a1709064c4b00b007ada197b58emr55561181ejw.203.1667938477589; Tue, 08
 Nov 2022 12:14:37 -0800 (PST)
MIME-Version: 1.0
References: <20221108123755.207438-1-Jason@zx2c4.com>
In-Reply-To: <20221108123755.207438-1-Jason@zx2c4.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 8 Nov 2022 21:14:26 +0100
Message-ID: <CACRpkdaxO_1w-7JqpVCcf0rt_J8xjw5Wx=NdnPsDZJR6aKvJmQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: ux500: do not directly dereference __iomem
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        olof@lixom.net, soc@kernel.org, linux@armlinux.org.uk,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 8, 2022 at 1:38 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:

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

Patch applied!
Sorry for taking so long!

Yours,
Linus Walleij
