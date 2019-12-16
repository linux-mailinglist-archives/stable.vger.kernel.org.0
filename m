Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6FA1215CF
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbfLPSYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:24:41 -0500
Received: from vps.xff.cz ([195.181.215.36]:50976 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731857AbfLPSSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1576520330; bh=tjqUrdJQ+sFgrpyy8lo3o0DQkqIgbuLDl4dG18ldaN8=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=IsTeoXfpkpmEZzVR08Zfbp3ADTbHFdfCoVooeSxmGpvkjHWi9Gow2l5pVe4fRRImx
         nUONHluXxUA1z06PAmzN7v7+3krXu3N+ZzlMVDOM6ivwFvoVaxUdb3GLM3kM0wsDXM
         3m9RynybKjigDIgnv5V81lhvvif8XiZThyi+rpPw=
Date:   Mon, 16 Dec 2019 19:18:50 +0100
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 133/350] Bluetooth: hci_bcm: Fix RTS handling
 during startup
Message-ID: <20191216181850.oyqjof6rgeofkou7@core.my.home>
Mail-Followup-To: Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-94-sashal@kernel.org>
 <20191216131512.c5x5ltndmdambdf4@core.my.home>
 <20191216132750.GA1646935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216132750.GA1646935@kroah.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:27:50PM +0100, Greg KH wrote:
> On Mon, Dec 16, 2019 at 02:15:12PM +0100, Ondřej Jirman wrote:
> > Hi,
> > 
> > On Tue, Dec 10, 2019 at 04:03:58PM -0500, Sasha Levin wrote:
> > > From: Stefan Wahren <wahrenst@gmx.net>
> > > 
> > > [ Upstream commit 3347a80965b38f096b1d6f995c00c9c9e53d4b8b ]
> > > 
> > > The RPi 4 uses the hardware handshake lines for CYW43455, but the chip
> > > doesn't react to HCI requests during DT probe. The reason is the inproper
> > > handling of the RTS line during startup. According to the startup
> > > signaling sequence in the CYW43455 datasheet, the hosts RTS line must
> > > be driven after BT_REG_ON and BT_HOST_WAKE.
> > > 
> > > Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> > > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/bluetooth/hci_bcm.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
> > > index 7646636f2d183..0f73f6a686cb7 100644
> > > --- a/drivers/bluetooth/hci_bcm.c
> > > +++ b/drivers/bluetooth/hci_bcm.c
> > > @@ -445,9 +445,11 @@ static int bcm_open(struct hci_uart *hu)
> > >  
> > >  out:
> > >  	if (bcm->dev) {
> > > +		hci_uart_set_flow_control(hu, true);
> > >  		hu->init_speed = bcm->dev->init_speed;
> > >  		hu->oper_speed = bcm->dev->oper_speed;
> > >  		err = bcm_gpio_set_power(bcm->dev, true);
> > > +		hci_uart_set_flow_control(hu, false);
> > >  		if (err)
> > >  			goto err_unset_hu;
> > >  	}
> > 
> > This causes bluetooth breakage (degraded bluetooth performance, due to failure to
> > switch to higher baudrate) for Orange Pi 3 board:
> > 
> > [    3.839134] Bluetooth: hci0: command 0xfc18 tx timeout
> > [   11.999136] Bluetooth: hci0: BCM: failed to write update baudrate (-110)
> > [   12.004613] Bluetooth: hci0: Failed to set baudrate
> > [   12.123187] Bluetooth: hci0: BCM: chip id 130
> > [   12.128398] Bluetooth: hci0: BCM: features 0x0f
> > [   12.154686] Bluetooth: hci0: BCM4345C5
> > [   12.157165] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0000
> > [   15.343684] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0038
> > 
> > I suggest not pushing this to stable.
> 
> Is it being fixed in Linus's tree?

No. This patch broke it there as well, and no response yet from the author.

regards,
	o.

> thanks,
> 
> greg k-h
