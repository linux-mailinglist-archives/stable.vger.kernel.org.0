Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34C6B5BAF
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjCKMaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCKMaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:30:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7E3F6C4A;
        Sat, 11 Mar 2023 04:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 018CFCE2C53;
        Sat, 11 Mar 2023 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D02C433D2;
        Sat, 11 Mar 2023 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678537809;
        bh=2UnpI/uHgbFeseZ6WJQHzE4N7+CfviWl8IBFeSiIEiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uS6DLm5UPUhxRtPariV7SNAOO1a8pr1NgTwDTl8oE/XZrKVfIv4bRT8BSItVZhwPT
         PO4X5imccCh4TQZ52oXXSHDDz+AToomtjCJZfyG/fxUbUmbANKot4EGMf7A9Ez3Kxm
         3ODQ267kuCmBOIiHrUSHhXIcIrpjsnh6ZMJlkbmU=
Date:   Sat, 11 Mar 2023 13:30:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        johannes@sipsolutions.net, stable@vger.kernel.org,
        Asahi Linux <asahi@lists.linux.dev>, Ilya <me@0upti.me>,
        Janne Grunau <j@jannau.net>,
        LKML <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev
Subject: Re: [REGRESSION] Patch broke WPA auth: Re: [PATCH v2] wifi:
 cfg80211: Fix use after free for wext
Message-ID: <ZAx0TWRBlGfv7pNl@kroah.com>
References: <20230124141856.356646-1-alexander@wetzel-home.de>
 <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st>
 <02ba45eb-1970-791a-d922-7b325ea51146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02ba45eb-1970-791a-d922-7b325ea51146@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 12:03:44PM +0100, Hans de Goede wrote:
> Hi Hector,
> 
> On 3/11/23 10:55, Hector Martin wrote:
> > Hi,
> > 
> > This broke WPA auth entirely on brcmfmac (in offload mode) and probably
> > others, including on stable 6.2.3 and 6.3-rc1 (tested with iwd). Please
> > revert or fix. Notes below.
> > 
> > Reported-by: Ilya <me@0upti.me>
> > Reported-by: Janne Grunau <j@jannau.net>
> > 
> > #regzbot introduced: 015b8cc5e7c4d7
> > #regzbot monitor:
> > https://lore.kernel.org/linux-wireless/20230124141856.356646-1-alexander@wetzel-home.de/
> 
> I can confirm this bug, I was seeing broken wifi on brcmfmac with 6.3-rc1
> and I was about to start a git bisect for this this morning when I saw
> this email.
> 
> Reverting 015b8cc5e7c4d7 fixes the broken wifi. Hector, thank you, you
> just saved me from a bisect on somewhat slow hardware :)

Great, can someone submit the revert patch to the networking tree so we
can get this resolved quickly?

thanks,

greg k-h
