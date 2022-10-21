Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF1460737F
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 11:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiJUJJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 05:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiJUJJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 05:09:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73621A3E2E;
        Fri, 21 Oct 2022 02:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA17AB82A2D;
        Fri, 21 Oct 2022 09:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE859C4314E;
        Fri, 21 Oct 2022 09:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666343340;
        bh=8Nfah4tp3bpy6ouB69Q6NueJyUc3gDXaer+xsnFlQjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KG/MTMXGS81AMSRLzUooIBhmVbT3ayzGSCeusacLu5ojMPBH1XB1hiU56qkPYXZ6Z
         Pmj1BD8LMmszwgMOZDbuoIpwrByIbQUTN+L9c7e1JrlXehMTnYGRRHCxy2ZxTpEvxj
         3g6zjK4bvf3VcnLXMJC3Gcf+ki1dT/YkGdUKLEHE=
Date:   Fri, 21 Oct 2022 11:08:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kevin Yang <kevin_yang@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 681/862] wifi: rtw88: phy: fix warning of possible
 buffer overflow
Message-ID: <Y1JhqYncRRKdwcwR@kroah.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083320.063888989@linuxfoundation.org>
 <1ab422def27d43e1866b470a3f9d24aa@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab422def27d43e1866b470a3f9d24aa@realtek.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 12:12:29AM +0000, Ping-Ke Shih wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Wednesday, October 19, 2022 4:33 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Kevin Yang
> > <kevin_yang@realtek.com>; Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo <kvalo@kernel.org>; Sasha Levin
> > <sashal@kernel.org>
> > Subject: [PATCH 6.0 681/862] wifi: rtw88: phy: fix warning of possible buffer overflow
> > 
> > From: Zong-Zhe Yang <kevin_yang@realtek.com>
> > 
> > [ Upstream commit 86331c7e0cd819bf0c1d0dcf895e0c90b0aa9a6f ]
> > 
> > reported by smatch
> > 
> > phy.c:854 rtw_phy_linear_2_db() error: buffer overflow 'db_invert_table[i]'
> > 8 <= 8 (assuming for loop doesn't break)
> > 
> > However, it seems to be a false alarm because we prevent it originally via
> >        if (linear >= db_invert_table[11][7])
> >                return 96; /* maximum 96 dB */
> > 
> > Still, we adjust the code to be more readable and avoid smatch warning.
> 
> Like Pavel mentioned [1], this patch is to avoid smatch warning, not a really
> bug. So, shouldn't take this patch. 
> 
> [1] https://lore.kernel.org/linux-wireless/20221018093921.GD1264@duo.ucw.cz/

Ok, will go drop now, thanks.

greg k-h
