Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6396AC5AE
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 16:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCFPlz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 6 Mar 2023 10:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCFPlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 10:41:55 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199162BED9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:41:25 -0800 (PST)
Received: (Authenticated sender: hadess@hadess.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 0D9784000F;
        Mon,  6 Mar 2023 15:40:26 +0000 (UTC)
Message-ID: <f23d6700b79500e2da9875964aee356c60a60529.camel@hadess.net>
Subject: Re: [PATCH 1/2] staging: rtl8723bs: Fix key-store index handling
From:   Bastien Nocera <hadess@hadess.net>
To:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-staging@lists.linux.dev, stable@vger.kernel.org
Date:   Mon, 06 Mar 2023 16:40:26 +0100
In-Reply-To: <20230306153512.162104-1-hdegoede@redhat.com>
References: <20230306153512.162104-1-hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-03-06 at 16:35 +0100, Hans de Goede wrote:
> There are 2 issues with the key-store index handling
> 
> 1. The non WEP key stores can store keys with indexes 0 -
> BIP_MAX_KEYID,
>    this means that they should be an array with BIP_MAX_KEYID + 1
>    entries. But some of the arrays where just BIP_MAX_KEYID entries
>    big. While one other array was hardcoded to a size of 6 entries,
>    instead of using the BIP_MAX_KEYID define.
> 
> 2. The rtw_cfg80211_set_encryption() and wpa_set_encryption()
> functions
>    index check where checking that the passed in key-index would fit
>    inside both the WEP key store (which only has 4 entries) as well
> as
>    in the non WEP key stores. This breaks any attempts to set non WEP
>    keys with index 4 or 5.
> 
> Issue 2. specifically breaks wifi connection with some access points
> which advertise PMF support. Without this fix connecting to these
> access points fails with the following wpa_supplicant messages:
> 
>  nl80211: kernel reports: key addition failed
>  wlan0: WPA: Failed to configure IGTK to the driver
>  wlan0: RSN: Failed to configure IGTK
>  wlan0: CTRL-EVENT-DISCONNECTED bssid=... reason=1
> locally_generated=1
> 
> Fix 1. by using the right size for the key-stores. After this 2. can
> safely be fixed by checking the right max-index value depending on
> the
> used algorithm, fixing wifi not working with some PMF capable APs.

Good job on both those patches.

Can you please also CC: the maintainer of r8188eu which looks like it
has similar code?

Cheers
