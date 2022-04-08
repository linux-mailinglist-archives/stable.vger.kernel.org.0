Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C55A4F9AC3
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiDHQie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 12:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiDHQic (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 12:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBF1ED917;
        Fri,  8 Apr 2022 09:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E1B620D1;
        Fri,  8 Apr 2022 16:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7FEC385A1;
        Fri,  8 Apr 2022 16:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649435786;
        bh=TkwBDUzJ9YyBhxYoCFRlqcRWI7UV6YLdvwfBWpDoxkM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qw7sf9W6lt3RpDJwysfpT+r6eWzmBjwOklM08kfvAxsH09zK9Z7N81LfuSqO+ZpW0
         bGff2jTH0wpqc4JIhk6m+W9Mx9dMriwrD2ZOh0okm75cNEy0C3Ko6G9JHkE5ynTPPa
         G6ZG/hFe/DwTMGEV++XWjEeQ+PwnEueReLLet6B/1x6ncqWyyjxWCQ6S9gF5wUFXC3
         BIHu0WSdmPsTuQtwIl5e8wGZfH/ss1IjXmMOHF6YPnQRhBEhJdzElF3LRxPL3mCTtt
         T3iTE/B+n6KkCzP9Hsil1j2iClbeu/gzW5GwClPeqtIQL8lWkxLFghr/LafkrN55L+
         yWG7NIGiQu5Uw==
Received: by mail-yb1-f180.google.com with SMTP id d138so16016866ybc.13;
        Fri, 08 Apr 2022 09:36:26 -0700 (PDT)
X-Gm-Message-State: AOAM531RDa7P4bN4bilrXJvBuBi0GjPqP7cLkZCpWp3gvl/NQIFlNiW6
        a7XgosQOD9rH+y78tbVf859yTrny6X2R57ixIHA=
X-Google-Smtp-Source: ABdhPJyQCzENX7aSD7Xm1y3IHarGAd00OfvNz3MtCITUYG2YdmOP0Yp14ZXNlGZXyEFfqNQOqZ916X9Txnh0PrLZPX4=
X-Received: by 2002:a25:d40e:0:b0:641:1842:ed4b with SMTP id
 m14-20020a25d40e000000b006411842ed4bmr1124711ybf.257.1649435785548; Fri, 08
 Apr 2022 09:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220408084715.26097-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220408084715.26097-1-xiam0nd.tong@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 8 Apr 2022 09:36:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4dTNShcoHGL1_t_=6f-+P3CSLTexSy+Mv2+HZSk8skOA@mail.gmail.com>
Message-ID: <CAPhsuW4dTNShcoHGL1_t_=6f-+P3CSLTexSy+Mv2+HZSk8skOA@mail.gmail.com>
Subject: Re: [PATCH v3] md: fix an incorrect NULL check in md_reload_sb
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     rgoldwyn@suse.com, Guoqing Jiang <guoqing.jiang@linux.dev>,
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

On Fri, Apr 8, 2022 at 1:47 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> The bug is here:
>         if (!rdev || rdev->desc_nr != nr) {
>
> The list iterator value 'rdev' will *always* be set and non-NULL
> by rdev_for_each_rcu(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> found (In fact, it will be a bogus pointer to an invalid struct
> object containing the HEAD). Otherwise it will bypass the check
> and lead to invalid memory access passing the check.
>
> To fix the bug, use a new variable 'iter' as the list iterator,
> while using the original variable 'pdev' as a dedicated pointer to
> point to the found element.
>
> Cc: stable@vger.kernel.org
> Fixes: 70bcecdb1534 ("md-cluster: Improve md_reload_sb to be less error prone")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Applied to md-next. Thanks!
