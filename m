Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46C25FECD9
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJNLES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNLEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:04:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE88E1CA59F
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=I61UhvG7Yyw8wt++uBWRM2etbkoa4K/ewEHz21oDUUA=;
        t=1665745455; x=1666955055; b=Y84IsmzHoydaCdbNUT8Fa4p9a/4CqFJ5JmDJdtTQqiEg0Dz
        bG7W1RObaakfFGtcc6WxUtF4vEgLi599C0FNEwBwtDaNlkDswIs+AKHPUjKAywG5Ju+x9pLuQAxy9
        NyRZc8tySIGXoN8n7Y6n+iPOJ4XkVZ4OO2JKGK7ibFFeasHn++wNLXVSfGH/JJf6kzJG6Lg3haQh+
        FfkBcVrGpJfibAlWC5FOeJ9hlcEP2z9EzCH84INlIxGi1YVXYImo3iSSVKt4zvYgljV9f7I1YwYCo
        ZXvxkHpuBYKCYtJtAtzHQTE5l9lK5QiM7GzGMUkNbviErd17/S1UtVnN68NvruMA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojIU7-006Zsk-0a;
        Fri, 14 Oct 2022 13:04:11 +0200
Message-ID: <4c6490032936b50785015ea93bb88575e09a5c8c.camel@sipsolutions.net>
Subject: Re: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Felix Fietkau <nbd@nbd.name>, stable@vger.kernel.org
Date:   Fri, 14 Oct 2022 13:04:10 +0200
In-Reply-To: <Y0kyTNju0rwqojrH@quatroqueijos.cascardo.eti.br>
References: <20221013181601.5712-1-nbd@nbd.name>
         <Y0kLsThZoDPPENhI@kroah.com>
         <Y0kyTNju0rwqojrH@quatroqueijos.cascardo.eti.br>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-10-14 at 06:56 -0300, Thadeu Lima de Souza Cascardo wrote:
> On Fri, Oct 14, 2022 at 09:11:45AM +0200, Greg KH wrote:
> > On Thu, Oct 13, 2022 at 08:15:56PM +0200, Felix Fietkau wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > >=20
> > > commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.
> > >=20
> > > We currently pass the entire elements to the rx_bcn_presp()
> > > method, but only need mesh_config. Additionally, we use the
> > > length of the elements to calculate back the entire frame's
> > > length, but that's confusing - just pass the length of the
> > > frame instead.
> > >=20
> > > Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773=
a0fbae4453e1433c184678ca14e8df45@changeid
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > ---
> > >  net/mac80211/ieee80211_i.h |  7 +++----
> > >  net/mac80211/mesh.c        |  4 ++--
> > >  net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
> > >  3 files changed, 17 insertions(+), 20 deletions(-)
> >=20
> > Many thanks for this series.  Will this also work in 5.4.y and 5.10.y?
> >=20
>=20
> Not sure about 5.10, but that won't work as is on 5.4. We are considering=
 some
> other approach for 5.4, but not sure yet. But simply taking dozens of cle=
an
> cherry picks did not strike as a good option to me.
>=20

I'm thinking of just disabling multi-BSSID, it's not really used anyway
as far as I can tell.

johannes
