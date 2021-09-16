Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F085040D4F5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 10:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhIPIuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 04:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhIPIuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 04:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36874611C4;
        Thu, 16 Sep 2021 08:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631782129;
        bh=XNlHT7SsRm0aHT+xH8JBSxeM0QmbStCHOez0rQuhyXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X9AncDACv15clITXSoMN8JlY/fHST1jd/e9N0jbnUiMkFQ1awv+Xz2BY1ebm4ROkU
         WtlLbobgOfRX4FhcODDSqIdImAlaK7bAoqify6yFBoJ/I3ijV4yfp3ZwLyraiLbeHb
         HPQBZM2OEKNtjeUBP9WROZ8co+97PxO3rKUl+Ymw=
Date:   Thu, 16 Sep 2021 10:48:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>
Subject: Re: [PATCH 5.10 157/236] Bluetooth: Move shutdown callback before
 flushing tx and rx queue
Message-ID: <YUME73+UUdOOHzMd@kroah.com>
References: <20210913131100.316353015@linuxfoundation.org>
 <20210913131105.720088593@linuxfoundation.org>
 <20210915111843.GA16198@duo.ucw.cz>
 <20210915143238.GA2403125@roeck-us.net>
 <YUKWK4EflIdFxFsp@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUKWK4EflIdFxFsp@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 08:56:11PM -0400, Sasha Levin wrote:
> On Wed, Sep 15, 2021 at 07:32:38AM -0700, Guenter Roeck wrote:
> > On Wed, Sep 15, 2021 at 01:18:43PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > [ Upstream commit 0ea53674d07fb6db2dd7a7ec2fdc85a12eb246c2 ]
> > > 
> > > Upstream commit is okay...
> > > 
> > > > So move the shutdown callback before flushing TX/RX queue to resolve the
> > > > issue.
> > > 
> > > ...but something went wrong in stable. This is not moving code, this
> > > is duplicating it:
> > > 
> > > > --- a/net/bluetooth/hci_core.c
> > > > +++ b/net/bluetooth/hci_core.c
> > > > @@ -1726,6 +1726,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> > > >  	hci_request_cancel_all(hdev);
> > > >  	hci_req_sync_lock(hdev);
> > > >
> > > > +	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > > > +	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > > > +	    test_bit(HCI_UP, &hdev->flags)) {
> > > > +		/* Execute vendor specific shutdown routine */
> > > > +		if (hdev->shutdown)
> > > > +			hdev->shutdown(hdev);
> > > > +	}
> > > > +
> > > >  	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
> > > >  		cancel_delayed_work_sync(&hdev->cmd_timer);
> > > >  		hci_req_sync_unlock(hdev);
> > > 
> > > And yes, we end up with 2 copies in 5.10.
> > > 
> > 
> > Same problem in v5.4.y, unfortunately.
> 
> Ugh, odd - it wasn't manually backported :/
> 
> I'll drop it.

Also now dropped from 5.13.y.

thanks,

greg k-h
