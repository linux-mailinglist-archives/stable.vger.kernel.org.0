Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E72614BCF
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 14:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiKANea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 09:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKANeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 09:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD61B1156;
        Tue,  1 Nov 2022 06:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52DB161452;
        Tue,  1 Nov 2022 13:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B09C433D6;
        Tue,  1 Nov 2022 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667309649;
        bh=lCCeOtXrB+VyAf+ZkJOVzx63oP7fC/Cq3ISVXHAAfr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REBbclWjlsoZUgfhWVDKwCSBCo0fV0NG/i6DrDr9xGymYY9glAxaevf5/z1nKtCkd
         6sBgfy/f6I+ouVqIyh7iG1Wm6IYrhczlEOMvtHfXYdCNVGuZ2AIltwceK5r81uRXvv
         sAgkvhQaUH95MJELg3ATeln9QH8ZPD4J+n1Hh9Cc=
Date:   Tue, 1 Nov 2022 14:35:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yongqin Liu <yongqin.liu@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Benjamin Copeland <ben.copeland@linaro.org>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 4.19 092/229] once: add DO_ONCE_SLOW() for sleepable
 contexts
Message-ID: <Y2Egh1LFMvOv6I7m@kroah.com>
References: <20221024112959.085534368@linuxfoundation.org>
 <20221024113002.025977656@linuxfoundation.org>
 <CAMSo37XApZ_F5nSQYWFsSqKdMv_gBpfdKG3KN1TDB+QNXqSh0A@mail.gmail.com>
 <Y2C74nuMI3RBroTg@kroah.com>
 <CAMSo37Vt4BMkY1AJTR5yaWPDaJSQQhbj7xhqnVqDo0Q_Sy6ycg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSo37Vt4BMkY1AJTR5yaWPDaJSQQhbj7xhqnVqDo0Q_Sy6ycg@mail.gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 08:00:03PM +0800, Yongqin Liu wrote:
> Hi, Greg
> 
> On Tue, 1 Nov 2022 at 14:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Nov 01, 2022 at 02:07:35PM +0800, Yongqin Liu wrote:
> > > Hello,
> > >
> > > As mentioned in the thread for the 5.4 version here[1], it causes a
> > > crash for the 4.19 kernel too.
> > > Just paste the log here for reference:
> >
> > Can you try this patch please:
> >
> >
> > diff --git a/include/linux/once.h b/include/linux/once.h
> > index bb58e1c3aa03..3a6671d961b9 100644
> > --- a/include/linux/once.h
> > +++ b/include/linux/once.h
> > @@ -64,7 +64,7 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
> >  #define DO_ONCE_SLOW(func, ...)                                                     \
> >         ({                                                                   \
> >                 bool ___ret = false;                                         \
> > -               static bool __section(".data.once") ___done = false;         \
> > +               static bool __section(.data.once) ___done = false;           \
> >                 static DEFINE_STATIC_KEY_TRUE(___once_key);                  \
> >                 if (static_branch_unlikely(&___once_key)) {                  \
> >                         ___ret = __do_once_slow_start(&___done);             \
> 
> 
> This change works, it does not cause kernel panic again after this
> change is applied.

Great, thanks!  Can I get a Tested-by: line for the changelog?

I'll queue this up in a bit and get it fixed in the next release.

thanks,

greg k-h
