Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80C0616347
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 14:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiKBNCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 09:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKBNCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 09:02:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A3C28724;
        Wed,  2 Nov 2022 06:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E8EDB82277;
        Wed,  2 Nov 2022 13:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DD0C433D6;
        Wed,  2 Nov 2022 13:02:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="izKgYJqe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667394161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ERy87H17Lc9B+vfjA9eb0LQyjvgV4mxrDrTgB+6Or0=;
        b=izKgYJqeePcg83rOd/yISsa+6+qPJ7b3yor2gGHnngTBoP0sJRrbdaZE0l1szestR3xOCj
        paUoUDEHOtYiILeboh+g+TKVMO4qpH3JtdlQIMqu9LoUzciNlb26X+HTScbeDrmLd7cj5l
        +wYCk+xYgCz9fGY0gZTH8xYIaS9V/Xk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 10e8115b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 2 Nov 2022 13:02:41 +0000 (UTC)
Date:   Wed, 2 Nov 2022 14:02:39 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Cc:     stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] soc: ux500: do not directly dereference __iomem
Message-ID: <Y2Jqb9n1jmLZRkXN@zx2c4.com>
References: <20221023195711.52515-1-Jason@zx2c4.com>
 <CAHmME9pDrV1P7GVg74xHTbUaVT5Lq8urvyYCgbu=sJLApwHHNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9pDrV1P7GVg74xHTbUaVT5Lq8urvyYCgbu=sJLApwHHNw@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC+ Arnd

On Sun, Oct 30, 2022 at 11:30:46PM +0100, Jason A. Donenfeld wrote:
> Hi Linus,
> 
> On Sun, Oct 23, 2022 at 9:57 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Sparse reports that calling add_device_randomness() on `uid` is a
> > violation of address spaces. And indeed the next usage uses readl()
> > properly, but that was left out when passing it toadd_device_
> > randomness(). So instead copy the whole thing to the stack first.
> >
> > Fixes: 4040d10a3d44 ("ARM: ux500: add DB serial number to entropy pool")
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/all/202210230819.loF90KDh-lkp@intel.com/
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> Just thought I'd follow up on this.
