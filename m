Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ECE3A9E68
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhFPPDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhFPPDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:03:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5053610CA;
        Wed, 16 Jun 2021 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623855670;
        bh=CvzB6YXq0zFjxl+eL59ikCItN4dVitj7mdueIdkgDsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HOzOdSVb9+wEFDyPgvS79vvYYLty7xFKAYG63yg+L9a6rvjiOI/TXlTqEb+0LDHd3
         48Bt8A9i4Ur9XR37CBO4MWxFmPIA8csQMR33QdfOA5O3GvJLVtWMeX8DGxi4nnUFr3
         St0yfTejCT0aADvu4y8jTBeVP2Sn6bbUjKlf73HA=
Date:   Wed, 16 Jun 2021 17:01:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent UAF of
 hdev object
Message-ID: <YMoSNLmNfBq0YVVW@kroah.com>
References: <20210608175935.254388043@linuxfoundation.org>
 <20210608175936.584233292@linuxfoundation.org>
 <def3c8d4-a787-8536-e743-adf90a0c5352@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def3c8d4-a787-8536-e743-adf90a0c5352@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 04:15:02PM +0200, Eric Dumazet wrote:
> 
> 
> On 6/8/21 8:27 PM, Greg Kroah-Hartman wrote:
> > From: Lin Ma <linma@zju.edu.cn>
> > 
> > commit e305509e678b3a4af2b3cfd410f409f7cdaabb52 upstream.
> > 
> > The hci_sock_dev_event() function will cleanup the hdev object for
> > sockets even if this object may still be in used within the
> > hci_sock_bound_ioctl() function, result in UAF vulnerability.
> > 
> > This patch replace the BH context lock to serialize these affairs
> > and prevent the race condition.
> > 
> > Signed-off-by: Lin Ma <linma@zju.edu.cn>
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/bluetooth/hci_sock.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- a/net/bluetooth/hci_sock.c
> > +++ b/net/bluetooth/hci_sock.c
> > @@ -755,7 +755,7 @@ void hci_sock_dev_event(struct hci_dev *
> >  		/* Detach sockets from device */
> >  		read_lock(&hci_sk_list.lock);
> >  		sk_for_each(sk, &hci_sk_list.head) {
> > -			bh_lock_sock_nested(sk);
> > +			lock_sock(sk);
> >  			if (hci_pi(sk)->hdev == hdev) {
> >  				hci_pi(sk)->hdev = NULL;
> >  				sk->sk_err = EPIPE;
> > @@ -764,7 +764,7 @@ void hci_sock_dev_event(struct hci_dev *
> >  
> >  				hci_dev_put(hdev);
> >  			}
> > -			bh_unlock_sock(sk);
> > +			release_sock(sk);
> >  		}
> >  		read_unlock(&hci_sk_list.lock);
> >  	}
> > 
> > 
> 
> 
> This patch is buggy.
> 
> lock_sock() can sleep.
> 
> But the read_lock(&hci_sk_list.lock) two lines before is not going to allow the sleep.
> 
> Hmmm ?
> 
> 

Odd, Lin, did you see any problems with your testing of this?


