Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC1C6BC909
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjCPI0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCPI0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:26:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC64EEFA6
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 01:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1779BB82043
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 08:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C31BC433EF;
        Thu, 16 Mar 2023 08:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678955141;
        bh=C1Ao84YcqIRaFm0ZwPS5qK3qekB5Rv0xeJbQgePaQHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E2FzI4RDfteDkbG81prNK0mepPM+8piQWsnJyd07lszsL47HbfgG6TMtoy9nez8mm
         n59XfQjISkeTYYq31N0e2xBsWQsXwUTuw55qM7Y5EFCzzuY/2rIP7I6EYYml0RdESv
         VVpvCIPm8vT3GvjjCJRqhUzhU1O3o5ZgO0pdIV0o=
Date:   Thu, 16 Mar 2023 09:25:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: [PATCH for-6.1.y] Revert "ASoC: codecs: lpass: register mclk
 after runtime pm"
Message-ID: <ZBLSg0BI28Bq31EU@kroah.com>
References: <20230315181900.2107200-1-amit.pundir@linaro.org>
 <ZBINX5qbdmY5CQOD@kroah.com>
 <CAMi1Hd1VaEGcN6Z2v0_V4Msj+BddNLtfPggZpc2u1yKHRHueiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMi1Hd1VaEGcN6Z2v0_V4Msj+BddNLtfPggZpc2u1yKHRHueiQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 12:13:40AM +0530, Amit Pundir wrote:
> On Wed, 15 Mar 2023 at 23:54, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Mar 15, 2023 at 11:49:00PM +0530, Amit Pundir wrote:
> > > This reverts commit 7b642273438cf500d36cffde145b9739fa525c1d which is
> > > commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 upstream.
> > >
> > > This patch broke RB5 (Qualcomm SM8250) devboard. The device
> > > reboots into USB crash dump mode after following error:
> > >
> > >     qcom_q6v5_pas 17300000.remoteproc: fatal error received: \
> > >     ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, \
> > >     Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
> > >
> > > Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> > > ---
> > >  sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
> > >  sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
> > >  sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
> > >  sound/soc/codecs/lpass-wsa-macro.c |  9 +++++----
> > >  4 files changed, 23 insertions(+), 22 deletions(-)
> >
> > Is this also reverted in Linus's tree?  If not, why not?
> 
> I couldn't reproduce this crash on Linus's tree. It was first reported
> on android14-6.1 and then I could reproduce it on v6.1.19 as well,
> hence this revert.
> 
> A quick search points out that this patch is a part of a 8 patch
> series https://lore.kernel.org/lkml/20230209122806.18923-1-srinivas.kandagatla@linaro.org/
> while only 5 of them landed on v6.1.y. May be we need the remaining
> fixes on v6.1.y as well? I can give the remaining patches a quick shot
> tomorrow if that helps.

Yes please, we would much rather take whatever is in Linus's tree than a
special revert as that will keep the trees in sync better.  If you can
provide the missing git ids, I can just queue them up if you have tested
them.

thanks,

greg k-h
