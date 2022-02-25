Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF24C44A5
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbiBYMdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiBYMdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:33:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF045D5D0
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 04:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A095A61B10
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 12:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDACC340E7;
        Fri, 25 Feb 2022 12:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645792352;
        bh=dmTCjKNVflSTooN35orpknsgDljzklvhKoP8k+T4C5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jL7aeZQRzHwBiWH2yU3PFyUsPhF8X1CghgPdu3xxYVCbEqlGqfM5RR2ah1kIyF3gI
         vze7q41gQaN/N5aKP1QcWDLhRrg59JLLPVvqoK+T1uVPPd87EhxSbukPNiGfryV4z+
         uFvv/KexmLBsHoAQY2YXALEerEFT3cTfeHTiUZOA=
Date:   Fri, 25 Feb 2022 13:32:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Alessandro B Maurici <abmaurici@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.4] lan743x: fix deadlock in
 lan743x_phy_link_status_change()
Message-ID: <YhjMXVSaIaEIVic7@kroah.com>
References: <20220223231432.186725-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223231432.186725-1-dann.frazier@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 04:14:32PM -0700, dann frazier wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [ Upstream commit ddb826c2c92d461f290a7bab89e7c28696191875 ]
> 
> Usage of phy_ethtool_get_link_ksettings() in the link status change
> handler isn't needed, and in combination with the referenced change
> it results in a deadlock. Simply remove the call and replace it with
> direct access to phydev->speed. The duplex argument of
> lan743x_phy_update_flowcontrol() isn't used and can be removed.
> 
> Fixes: c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for consistency")
> Reported-by: Alessandro B Maurici <abmaurici@gmail.com>
> Tested-by: Alessandro B Maurici <abmaurici@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Link: https://lore.kernel.org/r/40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [dannf: adjust context]
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> ---
> 
> The patch this Fixes: was applied back through 5.4.y. But this fix for it
> was only applied back through 5.10.y. It did require some minor context
> adjustment for 5.4.y, perhaps that is why? At any rate, this looks to
> be a fix for a problem one of our users reported on our 5.4-based kernel.

Now queued up, thanks.

greg k-h
