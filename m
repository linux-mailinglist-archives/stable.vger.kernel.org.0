Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7893D5365D5
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiE0QSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344731AbiE0QSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:18:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1179F8FD58
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=WQMVjaQfEqw24sfsJhDUpkGA1OkTIL2hpeoe6sGVVwk=;
        t=1653668285; x=1654877885; b=IJmhSYdVj95jA4cXGstup2UksbU/02VDVBd2DqVECp7U9FZ
        SHO8AFz2gvaLupRxh//buTWQTnXNMJ3uenpfLWraNxgy+khTicOSLoNKZIyIpYYlaq8QVLGeQvXeV
        LS7RNnURkJljPil9HWFiA4bZ8wxQ9glF8l1+gmxyLRMBgue2apJCXJhKLGv/HX6qoYViX+L15fW/l
        tE3PGo9wgVF7ZwqB5kcZpNOlOYbv/ZtH+tROJ67Fdc/JCf0QDKnQGiJPNe8Vp7PWKetuMom7oV8NK
        ldsRtzrnDNQluD3Cs97mFy98PVZxW4vcwFxN/8OUub7tFyi/36Ai9ZTPYY8h0c6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nucf2-0066MF-Mw;
        Fri, 27 May 2022 18:18:00 +0200
Message-ID: <a134637840677d99b83bf624c8e514f1d224948a.camel@sipsolutions.net>
Subject: Re: [PATCH 4.19] cfg80211: set custom regdomain after wiphy
 registration
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>
Date:   Fri, 27 May 2022 18:17:59 +0200
In-Reply-To: <YpD3k0yXx6d7So7W@kroah.com>
References: <20220527091151.45581-1-johannes@sipsolutions.net>
         <YpD3k0yXx6d7So7W@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-05-27 at 18:08 +0200, Greg KH wrote:
> On Fri, May 27, 2022 at 11:11:51AM +0200, Johannes Berg wrote:
> > From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> >=20
> > commit 1b7b3ac8ff3317cdcf07a1c413de9bdb68019c2b upstream.
> >=20
> > We used to set regulatory info before the registration of
> > the device and then the regulatory info didn't get set, because
> > the device isn't registered so there isn't a device to set the
> > regulatory info for. So set the regulatory info after the device
> > registration.
> > Call reg_process_self_managed_hints() once again after the device
> > registration because it does nothing before it.
> >=20
> > Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > Link: https://lore.kernel.org/r/iwlwifi.20210618133832.c96eadcffe80.I86=
799c2c866b5610b4cf91115c21d8ceb525c5aa@changeid
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/wireless/core.c | 7 ++++---
> >  net/wireless/reg.c  | 1 +
> >  2 files changed, 5 insertions(+), 3 deletions(-)
>=20
> What about versions for 5.4.y and 5.10.y as well?  We can't just fix an
> issue in an older kernel tree and ignore it in newer ones, right?
>=20

Huh, good point. I hadn't checked, people complained about it on 4.19.

johannes
