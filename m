Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367DD27003C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgIROwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 10:52:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50373 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726566AbgIROwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 10:52:32 -0400
Received: (qmail 1130178 invoked by uid 1000); 18 Sep 2020 10:52:31 -0400
Date:   Fri, 18 Sep 2020 10:52:31 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     linux-usb@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>, syzkaller@googlegroups.com,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 1/3] usbcore/driver: Fix specific driver selection
Message-ID: <20200918145231.GA1130146@rowland.harvard.edu>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <363eab9a-c32a-4c60-4d6b-14ae8d873c52@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <363eab9a-c32a-4c60-4d6b-14ae8d873c52@runbox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 05:31:26PM +0300, M. Vefa Bicakci wrote:
> Hello all,
> 
> I noticed that applying this patch on its own to the kernel causes the following
> unexpected behaviour: As soon as the usbip_host module is loaded, all of the
> USB devices are re-probed() by their drivers, and this causes the USB devices
> connected to my system to be momentarily unavailable. This happens because
> *without* the third patch in this patch set, the match function for the usbip_host
> device driver unconditionally returns true.
> 
> The third patch in this patch set [1] makes this unexpected behaviour go
> away, as it makes the usbip device driver's match function only match devices
> that were requested by user-space to be used with USB-IP.
> 
> Is this something to be concerned about? I was thinking of people who might be
> using git-bisect, who might encounter this issue in an unexpected manner.
> 
> As a potential solution, I can prepare another patch to revert commit
> 7a2f2974f2 ("usbip: Implement a match function to fix usbip") so that this
> unexpected behaviour will not be observed. This revert would be placed as
> the first patch in the patch series.

Yes, that sounds like a good solution.

Alan Stern
