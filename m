Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32EB6B93E1
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCNMe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCNMe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:34:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AA6B47B;
        Tue, 14 Mar 2023 05:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=T47L+dwmJ1yzRastsCGu6OG7Z1dr2ymeN6txeTWovGE=;
        t=1678797235; x=1680006835; b=HpRqCiFrEntgGYtFPf7eS+P4dp0653KuSY2NG/t+kp7hiQ/
        rVTfjRIZnl+A3MTpBvLvfrBJwUp51DYsRvdErWb4GJxjgkBfbsmamUgg7UGWOVfyVWB+9Vm4JLmE8
        z20+0HqNUjw8nKZeYLyk5qa6uO0fcCxMmHa3oNE5WB7d4IrX8Dma3nWbs8fxCAFTM1ye2HE7RVO0o
        XwoffFKbDndSO4USUscaX/r7OCn8g0g4WzIQeEVTMe0idvJEVLnFL5iUFoFVnEe5aRYndQDe8fqZb
        0g2vhCWj8B8l0rP392gv4rtGNDUQ5NZ04soJ4rN1AbMxuFg9P+TZ4c6gN1q8xlvA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pc3pV-003ABM-0m;
        Tue, 14 Mar 2023 13:32:37 +0100
Message-ID: <067780600cd56014c3c820117d139ddb1c352b28.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Felix Fietkau <nbd@nbd.name>,
        Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, Thomas Mann <rauchwolke@gmx.net>,
        stable@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Tue, 14 Mar 2023 13:32:36 +0100
In-Reply-To: <519b5bb9-8899-ae7c-4eff-f3116cdfdb56@nbd.name>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
         <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
         <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
         <519b5bb9-8899-ae7c-4eff-f3116cdfdb56@nbd.name>
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

On Tue, 2023-03-14 at 13:28 +0100, Felix Fietkau wrote:
> If you want to address this in the least invasive way, add [...],
> a global lock to iwlwifi
>=20

I'm already fixing this, see
https://lore.kernel.org/r/5674c40151267fea1333f0eda1701b141bbaa170.camel@si=
psolutions.net

> , and a=20
> per-AC lock inside ieee80211_handle_wake_tx_queue().

I'm not *entirely* sure per AC is sufficient given that you could
technically map two ACs to the same HW queue with vif->hw_queue[]?

But again, not really sure all that complexity is still worth it.

johannes
