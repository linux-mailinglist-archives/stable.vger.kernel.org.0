Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6ED1398DD
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 19:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgAMS0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 13:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgAMS0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 13:26:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88FFD2075B;
        Mon, 13 Jan 2020 18:26:14 +0000 (UTC)
Date:   Mon, 13 Jan 2020 19:26:12 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Input: keyspan-remote: fix control-message timeouts
Message-ID: <20200113182612.GH411698@kroah.com>
References: <20200113171715.30621-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113171715.30621-1-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 06:17:15PM +0100, Johan Hovold wrote:
> The driver was issuing synchronous uninterruptible control requests
> without using a timeout. This could lead to the driver hanging on probe
> due to a malfunctioning (or malicious) device until the device is
> physically disconnected. While sleeping in probe the driver prevents
> other devices connected to the same hub from being added to (or removed
> from) the bus.
> 
> The USB upper limit of five seconds per request should be more than
> enough.
> 
> Fixes: 99f83c9c9ac9 ("[PATCH] USB: add driver for Keyspan Digital Remote")
> Cc: stable <stable@vger.kernel.org>     # 2.6.13
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/input/misc/keyspan_remote.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
