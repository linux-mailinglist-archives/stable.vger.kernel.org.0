Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F876B93EA
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCNMfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbjCNMfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:35:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32751F90F;
        Tue, 14 Mar 2023 05:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=auMnBg7XTWQiq0svuj03l6i+FWQ5eryMOG/tYbzg5+c=;
        t=1678797266; x=1680006866; b=FQBQr0SS9/FbS04LoueLObjWBbINh5ZHe6pQsrU5CtuBI6V
        Nw72oaJI/15RlRtYsXzXExq98CF8gHEN7rATVZLcxgqffWJZYYd5qp3Cwg965yQQd4q6kVInBRRfT
        9eEHxp+BbHru6e0ZSJW2+slLcrpyHbdEK6kjaZDBj5iXgSReGCO9z+UzJIyTQHtLGimWA/GlgScis
        JcZcME6Y/Z9730TF2BkxBoHPf+c6e9QjlAWqbztjCNkCL43okIAyYEc3n14UjurZIa+s9rECB0tI7
        ZFGNRR/A84DAPz1nU1v94pkSVbNEKWM5+hewVeLnFg/EQ2niv1HT77d896PNaz5Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pc3fy-0039uC-12;
        Tue, 14 Mar 2023 13:22:46 +0100
Message-ID: <b057bd203e4c0aaf7434b1b52710b888767323aa.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Thomas Mann <rauchwolke@gmx.net>, stable@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Tue, 14 Mar 2023 13:22:45 +0100
In-Reply-To: <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
         <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
         <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, 2023-03-14 at 12:20 +0100, Alexander Wetzel wrote:
> On 13.03.23 21:33, Johannes Berg wrote:
> > On Mon, 2023-03-13 at 21:15 +0100, Alexander Wetzel wrote:
> > >=20
> > > While drivers with native iTXQ support are able to handle that,
> > >=20
> >=20
> > questionable. Looking at iwlwifi:
> >=20
> > void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
> >                                 struct ieee80211_txq *txq)
> > {
> >          struct iwl_mvm *mvm =3D IWL_MAC80211_GET_MVM(hw);
> > ...
> >          list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
> > ...
> > }
> >=20
> > which might explain some rare and hard to debug list corruptions in the
> > driver that we've seen reports of ...
> >=20
>=20
> Shall I change the scope of the fix from "only 6.2" to any stable kernel?
> 'Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue=20
> implementation")'
>=20
> Or is that a overreaction and we better stick to what we know for sure=
=20
> and keep the 'Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler=
=20
> for wake_tx_queue")'?

I think we stick with the latter. I already have a fix for iwlwifi (see
https://lore.kernel.org/r/20230314103840.30771-1-jtornosm@redhat.com)
and other drivers should be fine.

Also that means we should probably restrict the fix to actually be for
mac80211 only.

> > > To avoid what seems to be a not needed distinction between native and
> > > drivers using ieee80211_handle_wake_tx_queue(), the serialization is
> > > done for drv_wake_tx_queue() here.
> >=20
> > So probably no objection to that, at least for now, though in the commo=
n
> > path (what I showed above was the 'first use' path), iwlwifi actually
> > hits different HW resources, so it _could_ benefit from concurrent TX
> > after fixing that bug.
> >=20
>=20
> I could also directly add a driver a driver flag, allowing drivers to=20
> opt in to overlapping calls. And then set the flag for mt76, since Felix=
=20
> prefers to not change the behavior and knows this driver works with it.

Too much complexity. I change my position - let's fix mac80211 and
iwlwifi separately.

> Exactly. With the benefit that when we run uncontested the overhead is=
=20
> close to zero.
> But this should also be true for spinlocks. And when we spin on=20
> contention it even better... So I'll change it to use a spinlock instead.

Yeah that was kind of my thought process here too.


> > Since drivers are supposed to handle concurrent TX per AC, you could
> I assume you mean multiple drv_wake_tx_queue() can run in parallel, as=
=20
> long as they are serving different ACs?
> In a prior test patch I just blocked concurrent calls for the same ac.

No, I meant that drv_tx() was previously allowed concurrently for
different HW queues, which in practice means at least different ACs.

> While that may be enough for full iTXQ drivers I have doubts that this=
=20
> is sufficient for the ones using ieee80211_handle_wake_tx_queue.

No no, that's what I mean, it should've been sufficient for old-style
drivers.

> I at least was unable to identify any code in the rt2800usb driver which=
=20
> looked dangerous for concurrent execution. (Large parts are protected by=
=20
> a driver spinlock)

Indeed, that's not so clear.

> I ended up with the assumption, that the DMA handover - or something=20
> related to that - must cause the queue freezes. (Or my ability to detect=
=20
> critical calls is not good enough, yet.)

That part is protected by a per-queue lock in
rt2x00queue_write_tx_frame() though, but I don't see any problem either.

> The patch still fixed the issue, of course. All races in the examined=20
> regression are for IEEE80211_AC_BE, so it's sufficient fix when we=20
> decide that's save.

It seems to me it should be safe, again, since we previously assumed you
could do TX per HW queue concurrently. However, that's not precisely per
AC, so we might need to be careful, and maybe that's not worth it.

> Holding active_txq_lock[ac] all that time - it's normally acquired and=
=20
> released multiple times in between - seems to be a bit too daring for a=
=20
> "stable" patch.

Fair enough :)

> I also still would place the spinlock in drv_wake_tx_queue(). After all=
=20
> ieee80211_txq_schedule_start/end is kind of optional and e.g. iwlwifi is=
=20
> not using it.

True.

> What about handling it that way:
>=20
> Keep serializing drv_wake_tx_queue(). But use a new spinlock the drivers=
=20
> can opt out from.
>   1) No flag set:
>      drv_wake_tx_queue() can be running only once at any time
>=20
>   2) IEEE80211_HW_CONCURRENT_AC_TX
>      drv_wake_tx_queue() can be running once per AC at any time
>=20
>   3) IEEE80211_HW_CONCURRENT
>      current behavior.
>=20

I don't like the flags, to be honest.

Have you considered Felix's proposal of having a separate thread to
handle all the transmits? Or maybe that's too much for stable too?


I think my personal order of options would be:

1) for stable, just add a spinlock to ieee80211_handle_wake_tx_queue()

2) for later, maybe consider making ieee80211_handle_wake_tx_queue()
   just wake up a kthread or something, and handle the schedule loop
   there

However we may need to think more about 2), maybe we could even map to
hardware queues and do concurrency there, but better we just say screw
it and remove all that cruft instead ...

johannes
