Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201FA5BA97A
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIPJet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIPJes (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:34:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C00836872
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 02:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C77B81EC8
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B4C433D6;
        Fri, 16 Sep 2022 09:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663320884;
        bh=69R+/gKmPde8ftjWPaCZWR69JJw374Mo193O8FQoVDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dpHgvGoek+uT7qFL0nCYPmDU8uvkSY8WH1+y9ZI4pOW+8Ei5gvHkQMJjRSC+8uKCp
         pBCdRIy47wT7PSfZZhZvDM8CtaAc5uozItA13BcjXCPS5n9Nx4F06Zq7I0Tzk7allB
         3eVS5Ckn8x6IVXvcTiA65x3A1iBqv9+5SuS3uGaQ=
Date:   Fri, 16 Sep 2022 11:35:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     stable <stable@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3] net: dp83822: disable rx error interrupt
Message-ID: <YyRDTT22caLQWaDg@kroah.com>
References: <1223536756.162378.1662977228581.JavaMail.zimbra@savoirfairelinux.com>
 <20220913081747.39198-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <YyBp0mhD2cWibBB9@kroah.com>
 <1021996164.282624.1663139220592.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1021996164.282624.1663139220592.JavaMail.zimbra@savoirfairelinux.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 03:07:00AM -0400, Enguerrand de Ribaucourt wrote:
> > From: "Greg KH" <gregkh@linuxfoundation.org>
> > To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > Cc: "stable" <stable@vger.kernel.org>, "Andrew Lunn" <andrew@lunn.ch>, "Jakub Kicinski" <kuba@kernel.org>
> > Sent: Tuesday, September 13, 2022 1:30:26 PM
> > Subject: Re: [PATCH v3] net: dp83822: disable rx error interrupt
> 
> > On Tue, Sep 13, 2022 at 10:17:48AM +0200, Enguerrand de Ribaucourt wrote:
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
> 
> > Backport to what? This is already in 5.10, where do you want this
> > commit applied to?
> 
> > thanks,
> 
> > greg k-h
> 
> Hi,
> 
> I would like this commit to be applied to 5.4. It should also apply to 4.19.

Now queued up, thanks.

greg k-h
