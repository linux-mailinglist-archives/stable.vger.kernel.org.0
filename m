Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD06452C9A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 09:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhKPIZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 03:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhKPIZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 03:25:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 106FF63217;
        Tue, 16 Nov 2021 08:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637050946;
        bh=EwREHC3TsutkeJecn1dBhlG4iOj7S7tQGLDl8TYyHVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdWuqBP8YLewcu4YPstnTgoLdY1tGHCJfow5Oy8r93TVQRYw1pQGeUDStUG8Fa+6X
         75XoIhOwiY/VWFrvWtCqRLPzxRFHEDZI9RN/BR1Ggrp/d5y5+ohRTagVEq9Lu+3yym
         61di6r8yZVj7tLUpon4QObWBfShq/Gne+qMb03Tc=
Date:   Tue, 16 Nov 2021 09:22:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     stern@rowland.harvard.edu, kishon@ti.com, hdegoede@redhat.com,
        chris.chiu@canonical.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: hub: Fix usb enumeration issue due to address0 race
Message-ID: <YZNqQBd+pcXBQuAp@kroah.com>
References: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 12:16:30AM +0200, Mathias Nyman wrote:
> xHC hardware can only have one slot in default state with address 0
> waiting for a unique address at a time, otherwise "undefined behavior
> may occur" according to xhci spec 5.4.3.4
> 
> The address0_mutex exists to prevent this across both xhci roothubs.
> 
> If hub_port_init() fails, it may unlock the mutex and exit with a xhci
> slot in default state. If the other xhci roothub calls hub_port_init()
> at this point we end up with two slots in default state.
> 
> Make sure the address0_mutex protects the slot default state across
> hub_port_init() retries, until slot is addressed or disabled.
> 
> Note, one known minor case is not fixed by this patch.
> If device needs to be reset during resume, but fails all hub_port_init()
> retries in usb_reset_and_verify_device(), then it's possible the slot is
> still left in default state when address0_mutex is unlocked.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

What commit id does this "fix"?

thanks,

greg k-h
