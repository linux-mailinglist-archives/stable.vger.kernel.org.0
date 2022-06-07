Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FFC53FA62
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbiFGJxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240205AbiFGJwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A948FEBA97
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432FF612CB
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8458EC385A5
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:51:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="C0+kztxR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654595495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3p4Nk9KSnlkfChs/rJ0t+Q9EqL4Q5WWEJkuz+r4YbyI=;
        b=C0+kztxR0qseKzV6GnnYDisPaNYY5AhOhzqNvaPOXI9RMJDMH4VxYns5Aw1+Y6x1kLY8w6
        AtfvlR/ekPR4+NSu6+LtFkwMlywbeQS2Xkb4JPMGGiD854+MSwysSwiErkfUr1KC4UUdjT
        e5H36actjKRdbcnBgpabTjoSvxUnir4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ecdf8e6b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Tue, 7 Jun 2022 09:51:35 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-30c143c41e5so169466217b3.3
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 02:51:35 -0700 (PDT)
X-Gm-Message-State: AOAM531p/7kIBnolmvsv7FCVURom6bWWWYsPO7r1TfcWfly8s4g7LOGb
        v2HRIISdQ8fNm5/SFSr5CHpQbiphVq5R36UfcnE=
X-Google-Smtp-Source: ABdhPJzER0MH2k/zjLzHUWc5gtugPHFvxBSYp5tsSAIW+RrOEC4Rg4wOR7i3DBAK7J70u7z081jjvcGRX2Z+xoWBw7Y=
X-Received: by 2002:a81:6c89:0:b0:30c:4c36:f9c7 with SMTP id
 h131-20020a816c89000000b0030c4c36f9c7mr30499230ywc.485.1654595495077; Tue, 07
 Jun 2022 02:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220604062503.396762-1-Jason@zx2c4.com> <Yp2kn+lzTL7RTaoD@kroah.com>
 <CAHmME9pPvdAS1fqDpaDVq6T9=cch2M_UhRJwNEBntG-dYfhU0g@mail.gmail.com> <Yp8fOOdQdSFC3beA@kroah.com>
In-Reply-To: <Yp8fOOdQdSFC3beA@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jun 2022 11:51:23 +0200
X-Gmail-Original-Message-ID: <CAHmME9pkWz_DBww8YOTzKtbxbjRgNkjDTRfxy2Hr-pur0dVA0A@mail.gmail.com>
Message-ID: <CAHmME9pkWz_DBww8YOTzKtbxbjRgNkjDTRfxy2Hr-pur0dVA0A@mail.gmail.com>
Subject: Re: [PATCH stable 5.10 5.15 5.17 5.18] arm64: Initialize jump labels
 before setup_machine_fdt()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
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

On Tue, Jun 7, 2022 at 11:49 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 07, 2022 at 10:56:21AM +0200, Jason A. Donenfeld wrote:
> > You can actually drop this in favor of
> > https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
> > rather than playing whack-a-mole by architectures that may have been
> > broken by it.
>
> So I need to drop this as well?  Or is it ok to keep for now now that I
> have queued up the other commit?

The other commit ("Revert "random: use static branch for
crng_ready()"") fixes this problem on all architectures. This commit
fixes the problem on arm64. There's probably no harm in keeping this
commit, if you want it, but it's also no longer necessary, because
"Revert "random: use static branch for crng_ready()"" addresses the
issue more comprehensively.

Jason
