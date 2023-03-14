Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B23C6B9C19
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjCNQuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCNQue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:50:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4D9A8E90;
        Tue, 14 Mar 2023 09:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=CZ/ymS/Xew0Y3Ze25l99rL9mFXExoWNLQPAKHjWb2eY=;
        t=1678812633; x=1680022233; b=G1UWaKDrBkMjI4f6i3HRsxpOpIj0skVgWEzJm6n/KcSISgE
        4u8e2BTCK5Jb4AkN2fOYuD1UMUg8mGSGu853bP3hVV7DlScLXA2Gz5AeJ30LhU+YOWh9HG1ZC7BBg
        8T+w8qsTytr0oYgC/eJ7u8uSMrE9INYp36B5EaDPbbIEVWohUhea413ShHlHrb2il9aphzcDgy1gl
        wYIbiMmT0zZS51tURRD8Nj4cY9A70n4FUSrH/QwvU9NTV5mUkfDRO5AtAz7/UO8J2c6OM0fVXuYat
        e1309xqdtxuqx307LEw3C+CqngZTUQvgJhREYJmL2bdk0KaLkjIy30sslpqRoyAw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pc7r3-003FRw-0s;
        Tue, 14 Mar 2023 17:50:29 +0100
Message-ID: <cb7445607128a6b9ed7c17fcdcf3679bfaf4aaea.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Thomas Mann <rauchwolke@gmx.net>, stable@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Tue, 14 Mar 2023 17:50:28 +0100
In-Reply-To: <82d5623b-8d21-a8c1-e835-e446adf96cde@wetzel-home.de>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
         <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
         <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
         <b057bd203e4c0aaf7434b1b52710b888767323aa.camel@sipsolutions.net>
         <82d5623b-8d21-a8c1-e835-e446adf96cde@wetzel-home.de>
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


On Tue, 2023-03-14 at 17:44 +0100, Alexander Wetzel wrote:
> >=20
> > Have you considered Felix's proposal of having a separate thread to
> > handle all the transmits? Or maybe that's too much for stable too?
>=20
> I was planning to respond to Felix mail, too.
> But guess it makes more sense here now and not have multiple concurrent=
=20
> discussions:-)

:-)

> For the immediate fix I do not like the kthread. Which simply may be due=
=20
> to the fact that I would need more time to delve into that.

Agree.

> Not so sure how we can get the queue wakes as cheap as they currently=20
> are, though. Each time we kick off the kthread it would have to check=20
> the scheduling lists for each AC. Or use one kthread per AC... (That=20
> from someone who knows close to nothing about kthread and needs do more=
=20
> reading...)

Yes it might not be as cheap, but a kthread could also handle multiple
packets together if there were many enqueued, so might be even be a net
win in a kind of high traffic case. Not sure.

> Generally it sounds like improvement for mac80211 roadmap. But nothing I=
=20
> would want to pickup right now.
> I first want to wrap up the migration to iTXQ. (Which now also redesigns=
=20
> how filtered and pending frames are handled, btw.)

Also agree with that.

> I'll just use per-ac spinlocks in ieee80211_handle_wake_tx_queue(),=20
> allowing multiple ACs to TX at the same time.

Not sure it's even worth splitting it across ACs?

> That's probably not able to prevent the stopped queue issue Thomas got=
=20
> with 6.2 kernels when mutliply ACs have concurrent TX.
> But it will bring back the driver to the level it operated on kernel=20
> <6.1. Which sounds acceptable for me.

Sure.

> Someone planning to fix the issue for ath10k?
> If not I'll look into that, too. (Since we don't have known issues for=
=20
> that it's not exactly a priority.)

Not me, already have my hands full with iwlwifi :-)

johannes
