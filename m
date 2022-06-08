Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D645428CD
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 10:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiFHH72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 03:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiFHH6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 03:58:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400071E224B;
        Wed,  8 Jun 2022 00:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C022B81B34;
        Wed,  8 Jun 2022 07:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D5CC34116;
        Wed,  8 Jun 2022 07:26:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="i5WuCreL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654673210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xy/dSaTkB1MEzXO6teAWxD6nuIOwQZ+wyMxL9CGuVac=;
        b=i5WuCreLPX3OvDS2aEN0rSVqXMlyM18E2T2/oSjh8PeGqrBpUNWEJUKqDd0GcOLd5f6hUS
        twxqhGLvtzSibXZ2pRzCXW0caczJn6gP0TCrZlX6jVGYsQPrWy7SI8JxJx0a8Z1MA3MNuK
        QQxS/QoGzxQTWT3A/S6qaMBDJ6YH/cs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fb4e7973 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jun 2022 07:26:50 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id p13so35051300ybm.1;
        Wed, 08 Jun 2022 00:26:49 -0700 (PDT)
X-Gm-Message-State: AOAM533J+z71AWgV+wqGVw+NhwyhZsFRFzdp/6MIxila6K7m8Rbj7eSK
        wGcz6AOlkklEUy/aF1trBbNP6Y58Euru0Ix6/hI=
X-Google-Smtp-Source: ABdhPJzmhFBMe6ueh331IGLDLj115e3CDB7Nh/74/+y0XiaEwrEsF3wXXxEAbW6hUVjApDax3EVT2qwT/s19uRgRHJw=
X-Received: by 2002:a25:4017:0:b0:664:524:210b with SMTP id
 n23-20020a254017000000b006640524210bmr1410230yba.235.1654673208978; Wed, 08
 Jun 2022 00:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164908.521895282@linuxfoundation.org> <20220607164908.572141803@linuxfoundation.org>
 <Yp+KxkkTctBDLJTA@arm.com> <CAMj1kXEtFVWgTgKh+vV2oi-mgqfzVJnqJpTneM9mwTEC3+Nasg@mail.gmail.com>
In-Reply-To: <CAMj1kXEtFVWgTgKh+vV2oi-mgqfzVJnqJpTneM9mwTEC3+Nasg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 8 Jun 2022 09:26:38 +0200
X-Gmail-Original-Message-ID: <CAHmME9p1k0-veubZD1647_35WA7PwhVbP8gCmgSRKCP-GJqANg@mail.gmail.com>
Message-ID: <CAHmME9p1k0-veubZD1647_35WA7PwhVbP8gCmgSRKCP-GJqANg@mail.gmail.com>
Subject: Re: [PATCH 5.10 001/452] arm64: Initialize jump labels before setup_machine_fdt()
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Stephen Boyd <swboyd@chromium.org>
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

Hi Ard,

This thread here is about stable review. Catalin mentioned to Greg
that the arm64 patch isn't required any more. I also mentioned the
same to Greg yesterday when it was in queue. Either way, what happens
in 5.19 no longer has any effect on stable any more, since it's been
reverted in stable. Therefore, I kindly ask you not to start yet
*another* thread about the same topic we've been discussing over the
last day. There are already 7 discussions about exactly the same
thing; no need to make another. Let's resume working on this all
today.

Jason
