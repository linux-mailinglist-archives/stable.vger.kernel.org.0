Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6383A2561
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 09:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhFJHZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 03:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhFJHZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 03:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE849613BC;
        Thu, 10 Jun 2021 07:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623309836;
        bh=B1IcCG+KuCmNUwhkJc/FlqjT5JB0FoFOqKtap1NCQGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvB/prxQbCJKSHWv2x4oW6qS1FGMfOp2qrszKhQYI4iWt1ya5aYNn6i33UhSOpn53
         uxAQ04UlfPxfmTgsq9jEwQhFFY2LsuSFQOLpMpzdjC68x1bv3fp0E9Mdw9tQWDQbVd
         ssQQ/LBNgTh0x2+FTm+B/ub2A9ygUEwIt+zB7xqRBu8dA55rydMZ5wpbePNTO6860s
         PuaPbQJ/YV6ToJZdrFOHkvILBTBJLJ2gaJaCq/9x3yyXJXrBAZBsHcnujmDkmFvww3
         6f8YKKM3SkKei8AT6jo+wYoAyMPU+RcIefyGfx4ivj71cpaoHHtNYQF3eAvMNtzDH6
         KFC3uj/22gh+g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lrF2b-00030X-7l; Thu, 10 Jun 2021 09:23:50 +0200
Date:   Thu, 10 Jun 2021 09:23:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Alex =?utf-8?B?VmlsbGFjw61z?= Lasso <a_villacis@palosanto.com>
Cc:     David Frey <dpfrey@gmail.com>, linux-usb@vger.kernel.org,
        Pho Tran <pho.tran@silabs.com>,
        Tung Pham <tung.pham@silabs.com>, Hung.Nguyen@silabs.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: cp210x: fix CP2102N-A01 modem control
Message-ID: <YMG+Be220/sZ4QIC@hovoldconsulting.com>
References: <YL87Na0MycRA6/fW@hovoldconsulting.com>
 <20210609161509.9459-1-johan@kernel.org>
 <22113673-a359-f783-166f-acbe5dbc9298@palosanto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22113673-a359-f783-166f-acbe5dbc9298@palosanto.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 12:00:36PM -0500, Alex Villacís Lasso wrote:
> El 9/6/21 a las 11:15, Johan Hovold escribió:
> > CP2102N revision A01 (firmware version <= 1.0.4) has a buggy
> > flow-control implementation that uses the ulXonLimit instead of
> > ulFlowReplace field of the flow-control settings structure (erratum
> > CP2102N_E104).
> >
> > A recent change that set the input software flow-control limits
> > incidentally broke RTS control for these devices when CRTSCTS is not set
> > as the new limits would always enable hardware flow control.
> >
> > Fix this by explicitly disabling flow control for the buggy firmware
> > versions and only updating the input software flow-control limits when
> > IXOFF is requested. This makes sure that the terminal settings matches
> > the default zero ulXonLimit (ulFlowReplace) for these devices.
> >
> > Reported-by: David Frey <dpfrey@gmail.com>
> > Reported-by: Alex Villacís Lasso <a_villacis@palosanto.com>
> > Fixes: f61309d9c96a ("USB: serial: cp210x: set IXOFF thresholds")
> > Cc: stable@vger.kernel.org      # 5.12
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >   drivers/usb/serial/cp210x.c | 64 ++++++++++++++++++++++++++++++++++---
> >   1 file changed, 59 insertions(+), 5 deletions(-)
> >
> > David and Alex,
> >
> > Would you mind testing this one with your CP2108N-A01? I've verified it
> > against a CP2108N-A02 (fw 1.0.8) here.

I meant CP2102N here of course. It had been a long day...

> Applied patch and tested with ESP32 board under kernel 5.12.9:

> jun 09 11:56:00 karlalex-asus kernel: cp210x 1-9:1.0: 
> cp210x_get_fw_version - 1.0.4

> $ miniterm.py /dev/ttyUSB0 115200
> <successful connect>
> 
> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
> cp210x_change_speed - setting baud rate to 9600
> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
> cp210x_set_flow_control - ctrl = 0x00, flow = 0x00
> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
> cp210x_tiocmset_port - control = 0x0303
> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
> cp210x_change_speed - setting baud rate to 115384
> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
> cp210x_tiocmset_port - control = 0x0101
> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
> cp210x_tiocmset_port - control = 0x0202
> 
> At least in my case, this patch fixes the regression for my workflow.

Thanks for confirming. Can I add a "Tested-by" tag for you as well?

And again, thanks for the detailed report, bisection and thorough
testing throughout.

Johan
