Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43914F9AC5
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiDHQiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 12:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiDHQiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 12:38:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9E0E886C;
        Fri,  8 Apr 2022 09:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FDDDB82A1D;
        Fri,  8 Apr 2022 16:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263C7C385A3;
        Fri,  8 Apr 2022 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649435766;
        bh=K5Kb3Xp0nCtSmnffNpkwtXLSVOyZuSrWwz3IcdaEMsg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WoNz2bF6JO0f/m2ru+xTXSU2mwhtzBKkDAtQZn+Uaryd6WxxDeiYxn0a+MGIN4e+0
         1F22ktcK6ICMlzaCXccBwbv79SK3QJdLiapBugH9E6tgGfD3EKmD+w5jqopJ73GCve
         EyMxOp0ckbP6T19dkF3aKe7HpIegg0x/+dFEi4PaZpi2gaQ9HdLNEg5fixdSNwam4T
         ddYGwQXQ5aHe9+BHkEjg/12Dw6YuZWerS9t0U23OsoDQarHu1pqd2FTzIz1gbhgl4C
         e0rR/O9ZRq9yUxODI2O1CZ+2NZhyp6UuP4mVmcziWVlvGnPWqnFQ181ih/jOXTSjJn
         TBt/gq1632CxQ==
Received: by mail-yb1-f172.google.com with SMTP id w134so16029149ybe.10;
        Fri, 08 Apr 2022 09:36:06 -0700 (PDT)
X-Gm-Message-State: AOAM531FUb+y9ivPz2iB9PXHfGgol2+GUNbHuzv8t3TtjKJ5KMI7VjEk
        FM1XZ7qkwLi/rYKBpX2TqnGJr6W1Uo3ped+/1H0=
X-Google-Smtp-Source: ABdhPJyKLjZmpdguSVpuN09IKlc04KncOOIfRxhBm2fII7mzd2UxjW7i6caa6tBWW95cP9i+gMEge8We3t1NQBHRysw=
X-Received: by 2002:a25:6909:0:b0:63d:afc8:8b01 with SMTP id
 e9-20020a256909000000b0063dafc88b01mr14441952ybc.561.1649435765226; Fri, 08
 Apr 2022 09:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220408083728.25701-1-xiam0nd.tong@gmail.com> <20220408122348.bt7lkaumwhv36a2q@fiona>
In-Reply-To: <20220408122348.bt7lkaumwhv36a2q@fiona>
From:   Song Liu <song@kernel.org>
Date:   Fri, 8 Apr 2022 09:35:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5qZiE4z0j_+pJbiHQ+zK9oVw3DLgEXdSQ0m=m5ULX1Mw@mail.gmail.com>
Message-ID: <CAPhsuW5qZiE4z0j_+pJbiHQ+zK9oVw3DLgEXdSQ0m=m5ULX1Mw@mail.gmail.com>
Subject: Re: [PATCH v3] md: fix an incorrect NULL check in does_sb_need_changing
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 8, 2022 at 5:23 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> On 16:37 08/04, Xiaomeng Tong wrote:
> > The bug is here:
> >       if (!rdev)
> >
> > The list iterator value 'rdev' will *always* be set and non-NULL
> > by rdev_for_each(), so it is incorrect to assume that the iterator
> > value will be NULL if the list is empty or no element found.
> > Otherwise it will bypass the NULL check and lead to invalid memory
> > access passing the check.
> >
> > To fix the bug, use a new variable 'iter' as the list iterator,
> > while using the original variable 'rdev' as a dedicated pointer to
> > point to the found element.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 2aa82191ac36 ("md-cluster: Perform a lazy update")
> > Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> > Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
>
> Also safeguards from reading sb from a faulty device if all devices are
> faulty.
>
> Acked-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied to md-next. Thanks!
