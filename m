Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15F95FF2B1
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiJNQ7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJNQ7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:59:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30901D5874;
        Fri, 14 Oct 2022 09:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=e8QmQj/Zq/UfceewR+AjHaGQieTQyGwcfUHbCnFhFjA=;
        t=1665766775; x=1666976375; b=UllvAEIr0KvEQSbQywOZTU40OOq3GUyLo2A7S6O5B1CaCpw
        fURTJzGgbA4zOKEUuZcltrD5eZBlCpM24xPgRa8tkyCqCxNUa3DbKNEToQQ0RUsdTrc+ykdZdr6UT
        V6p+RH6Nxcqq2N5P8pbdYmBXE7vyDOgyQQJFot/6NqrICCgZny1nMdhqURbt/LGNgA6Wh2UKxwhlU
        gyegcR981XEJbdiC6B+d7V/Qw/0BoLeirVad8rF0CaS9xF1CUcH2XIAUy+7yRZ8F9aIbtC9cfeO0j
        8NeB31+XDz/wuQ0j2hYrXusBkdhjE7AT1b/upk8UUVTXNwPfVlgTXwk0XUzfA16A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojO21-006hEY-0D;
        Fri, 14 Oct 2022 18:59:34 +0200
Message-ID: <e879fc034013c4c87431bbfa5f3caad7c2d76527.camel@sipsolutions.net>
Subject: Re: [RFC v5.4 1/3] mac80211: mlme: find auth challenge directly
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Steve deRosier <steve.derosier@gmail.com>
Date:   Fri, 14 Oct 2022 18:59:18 +0200
In-Reply-To: <20221014164705.31486-2-johannes@sipsolutions.net>
References: <20221014164705.31486-1-johannes@sipsolutions.net>
         <20221014164705.31486-2-johannes@sipsolutions.net>
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

On Fri, 2022-10-14 at 18:47 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> There's no need to parse all elements etc. just to find the
> authentication challenge - use cfg80211_find_elem() instead.
> This also allows us to remove WLAN_EID_CHALLENGE handling
> from the element parsing entirely.



>  	pos =3D mgmt->u.auth.variable;
> -	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
> -			       mgmt->bssid, auth_data->bss->bssid);
>=20

And, I probably should've said that in the commit message, the multiple
BSSID element isn't valid in this frame either, so need to try to parse
it (last argument)

johannes
