Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8425B6C61
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiIMLaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiIMLaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:30:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F8F3054D
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3B3BB80E45
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA208C433B5;
        Tue, 13 Sep 2022 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663068602;
        bh=SZGtHScuuk+SM3kltV2PH9TPsK+FuWMZO82WIWu6YXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPwOkzO6OfJky+UM8CTdnPNoknJL83tE/2jI7Cc6ippAhs1KBdkd3Ph4C2Jtd4XIv
         OcSMq9LZkKyhg+C8TwaB1P5vap4zYh2Za2dLkb72Ae+e7Gl1Iv85S5z6DMroqeED/L
         gewdZ9iUfxJb0J6ymRnbuAr2E4Qv+Y+VPz96wutY=
Date:   Tue, 13 Sep 2022 13:30:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     stable@vger.kernel.org, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3] net: dp83822: disable rx error interrupt
Message-ID: <YyBp0mhD2cWibBB9@kroah.com>
References: <1223536756.162378.1662977228581.JavaMail.zimbra@savoirfairelinux.com>
 <20220913081747.39198-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913081747.39198-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 10:17:48AM +0200, Enguerrand de Ribaucourt wrote:
> Some RX errors, notably when disconnecting the cable, increase the RCSR
> register. Once half full (0x7fff), an interrupt flood is generated. I
> measured ~3k/s interrupts even after the RX errors transfer was
> stopped.
> 
> Since we don't read and clear the RCSR register, we should disable this
> interrupt.
> 
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [backport of 5.10 commit 0e597e2affb90d6ea48df6890d882924acf71e19]

Backport to what?  This is already in 5.10, where do you want this
commit applied to?

thanks,

greg k-h
