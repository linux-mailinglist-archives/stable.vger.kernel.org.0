Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFE35B5C59
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 16:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiILOis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 10:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiILOio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 10:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C821530F76
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 07:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E49161224
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB0DC433C1;
        Mon, 12 Sep 2022 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662993521;
        bh=Lv59OgvcD5DXBVqMpD+OY17FtFLv9K5OHgEX5/vsnB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wLAhHFpuHEWQmFD4UGRt7/Y5UsAL77RHwLYv9tC+IKjB48F0QxRgMMbFxnyfrw37B
         RwoHfHO1ZjXDPYitqD/jr7U6j9Q7AbeeTQk57RfQY83LV1dhnftn2BfAnxSZ+fl69c
         4eA8Jsh8g3QVlzrO5PXG0W+ve6BzxmhKKcklXeJk=
Date:   Mon, 12 Sep 2022 16:39:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 2/2] net: dp83822: disable rx error interrupt
Message-ID: <Yx9Eic7cZptbMfQY@kroah.com>
References: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220907104558.256807-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <Yxohrg//utRPoJYc@kroah.com>
 <1223536756.162378.1662977228581.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223536756.162378.1662977228581.JavaMail.zimbra@savoirfairelinux.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 06:07:08AM -0400, Enguerrand de Ribaucourt wrote:
> > From: "Greg KH" <gregkh@linuxfoundation.org>
> > To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > Cc: stable@vger.kernel.org, "Andrew Lunn" <andrew@lunn.ch>, "Jakub Kicinski" <kuba@kernel.org>
> > Sent: Thursday, September 8, 2022 7:09:02 PM
> > Subject: Re: [PATCH v3 2/2] net: dp83822: disable rx error interrupt
> 
> > On Wed, Sep 07, 2022 at 12:45:59PM +0200, Enguerrand de Ribaucourt wrote:
> > > Some RX errors, notably when disconnecting the cable, increase the RCSR
> > > register. Once half full (0x7fff), an interrupt flood is generated. I
> > > measured ~3k/s interrupts even after the RX errors transfer was
> > > stopped.
> 
> > > Since we don't read and clear the RCSR register, we should disable this
> > > interrupt.
> 
> > > Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
> >> Signed-off-by: Enguerrand de Ribaucourt
> > > <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > [backport of 5.10 commit 0e597e2affb90d6ea48df6890d882924acf71e19]
> > > ---
> > > drivers/net/phy/dp83822.c | 3 +--
> > > 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> > Does not apply to 5.4.y or 4.19.y :(
> 
> I could apply the patch with no problems on those versions. I also could cherry-pick
> the commit on the branch queue/5.4 from stable/linux-stable-rc.git without conflicts.
> 
> I can't reproduce the issue you seem to be facing when applying those patches. Would you
> mind helping me finding what's wrong with the patch on those branches?

I no longer have the original in my queue anywhere, can you just resend
the missing commits if you think it works properly?

thanks,

greg k-h
