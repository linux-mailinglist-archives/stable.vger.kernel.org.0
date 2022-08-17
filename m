Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AE15974BD
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiHQRDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 13:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbiHQRDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 13:03:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF9D9BB40;
        Wed, 17 Aug 2022 10:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED81BB81E43;
        Wed, 17 Aug 2022 17:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58909C433D6;
        Wed, 17 Aug 2022 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660755776;
        bh=HlzVrPwIlIGzj2nu9TwVvh5tZSLO33lhBKPSWBotLeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SgwgMKTuoBp/XNMoiOCu5YUgy4S5M52HwT629mq+5UGrWUf75yeMTTqlBMXt0phH7
         a/p8jYnHiaUJqK8yPzfOjs3X6HUSDdkYBUzpYJ7+rR5ioCieQEhfhb24pjjFjW47tu
         idvbnN9iSjeoRI7PrjfKBTt0l3iBU/Wm0nEcaKtU=
Date:   Wed, 17 Aug 2022 19:02:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andri Yngvason <andri@yngvason.is>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] HID: multitouch: Add memory barriers
Message-ID: <Yv0fPZ4pr/meJ+Ti@kroah.com>
References: <20220817113247.3530979-1-andri@yngvason.is>
 <YvzYIm21ZKYpUApA@kroah.com>
 <CAFNQBQyLtqA+yFDoqREguAK3q7qdKbacju=XKeUDTxsjXfFnJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFNQBQyLtqA+yFDoqREguAK3q7qdKbacju=XKeUDTxsjXfFnJg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 04:14:20PM +0000, Andri Yngvason wrote:
> Hi Greg,
> 
> mið., 17. ágú. 2022 kl. 11:59 skrifaði Greg KH <gregkh@linuxfoundation.org>:
> >
> > On Wed, Aug 17, 2022 at 11:32:48AM +0000, Andri Yngvason wrote:
> > > This fixes a race with the release-timer by adding acquire/release
> > > barrier semantics.
> >
> > What race?
> >
> 
> The race is between the release timer and processing of hid input. It
> is quite certain that these atomic checks are broken as is because
> they're lacking memory barriers and this patch does fix an actual
> problem for me.

Perhaps you should say that in this changelog then.

> 
> I must admit that I don't know exactly where the execution reordering
> occurs and I haven't checked the generated assembly code, but if you
> look at e.g. mt_expired_timeout(), you'll see that there's nothing to
> keep the compiler or CPU from hoisting the test_bit() call above the
> test_and_set_bit() call.
> 
> > >
> > > I noticed that contacts were sometimes sticking, even with the "sticky
> > > fingers" quirk enabled. This fixes that problem.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Andri Yngvason <andri@yngvason.is>
> > > ---
> > >  drivers/hid/hid-multitouch.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> > > index 2e72922e36f5..91a4d3fc30e0 100644
> > > --- a/drivers/hid/hid-multitouch.c
> > > +++ b/drivers/hid/hid-multitouch.c
> > > @@ -1186,7 +1186,7 @@ static void mt_touch_report(struct hid_device *hid,
> > >       int contact_count = -1;
> > >
> > >       /* sticky fingers release in progress, abort */
> > > -     if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
> > > +     if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
> >
> > So this is now a lock?
> >
> > Why not just use a real lock instead?
> >
> 
> I don't know. This stuff was introduced in
> 9609827458c37d7b2c37f2a9255631c603a5004c by Benjamin Tissoires.

Then this needs a "Fixes:" tag?

thanks,

greg k-h
