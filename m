Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312491456C6
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgAVNaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgAVNa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:30:29 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B410205F4;
        Wed, 22 Jan 2020 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699827;
        bh=rFF9R6k/DGZmUW30gr3bVUAty7o9u1eYYaO+Lr9Mkrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1s9+hYaTq9mPNWAZKnkbtgLFMKls4rLTNgxxihMXRYrxn+XtaUjMstlZ8dTJ+qsg/
         VBiadds+RsZRfCIbxOgCt6f4S9b0zsxoxeGgBMaU03FK+Dcgzsvnq8wl8lQAXgPdEd
         gmchTEm7j814B7768ihYUgO/Oy71hJ5WvmrVHld4=
Date:   Wed, 22 Jan 2020 14:25:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/5] USB: serial: ir-usb: fix IrLAP framing
Message-ID: <20200122132542.GC3580@kroah.com>
References: <20200122101530.29176-1-johan@kernel.org>
 <20200122101530.29176-4-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122101530.29176-4-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 11:15:28AM +0100, Johan Hovold wrote:
> Commit f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
> switched to using the generic write implementation which may combine
> multiple write requests into larger transfers. This can break the IrLAP
> protocol where end-of-frame is determined using the USB short packet
> mechanism, for example, if multiple frames are sent in rapid succession.
> 
> Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
> Cc: stable <stable@vger.kernel.org>     # 2.6.35
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/ir-usb.c | 113 +++++++++++++++++++++++++++++-------
>  1 file changed, 91 insertions(+), 22 deletions(-)

Ah, nice fix, sorry about that :(

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
