Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BB73135E4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhBHPBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231781AbhBHPBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:01:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E88E64E27;
        Mon,  8 Feb 2021 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612796427;
        bh=zGX5GtXakCRE/MyD6c9tsu3nSt9nLv++IN2LNAvchk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6VP1KJ0MWeCaAlH9E564MxHxasiBITo1xkJ9Ier1j3zuYPDdQRMEf3KI2RxFJbhv
         lLVspdmShBjiHCIdvpIfZGi4I65CBpQLA6hynv1XacfexK8ihOCQbN2JajuUnnd8sS
         p6lRNmC/qNkQ3fjz8Kyhayq9HxcMpISLQj+gMrwsOwNEcqkN+Yoi9oEMFdf1t4ixZz
         hJtiGLoLbp5mlWmGp7Zjxo8GFafYyGFskF8rdcrhyLR8l69+rSuD0qAO3RZx85KVan
         K6m02ZUsB7bWocb/SqqMu8Ei7515pA9S+jC7f3VaW+49vXIa3zBZiinpAZ3Fb5e/Yl
         /78hCPAZuFtUg==
Received: by pali.im (Postfix)
        id C8D449E0; Mon,  8 Feb 2021 16:00:24 +0100 (CET)
Date:   Mon, 8 Feb 2021 16:00:24 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <20210208150024.56itcicj46idkqf3@pali>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
 <YCEPdBfsxpWSdSar@kroah.com>
 <20210208110709.2ce5h3fdm3ftipcf@pali>
 <20210208143705.xi4jjy6unz5ueph4@pali>
 <YCFQkt2XRYa+zE0f@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YCFQkt2XRYa+zE0f@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 08 February 2021 15:54:10 Greg KH wrote:
> On Mon, Feb 08, 2021 at 03:37:05PM +0100, Pali Rohár wrote:
> > On Monday 08 February 2021 12:07:09 Pali Rohár wrote:
> > > On Monday 08 February 2021 11:16:20 Greg KH wrote:
> > > > On Mon, Feb 08, 2021 at 11:09:52AM +0100, Greg KH wrote:
> > > > > On Sun, Feb 07, 2021 at 04:56:21PM +0100, Pali Rohár wrote:
> > > > > > On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> > > > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > > tree, then please email the backport, including the original git commit
> > > > > > > id to <stable@vger.kernel.org>.
> > > > > > > 
> > > > > > > thanks,
> > > > > > > 
> > > > > > > greg k-h
> > > > > > ...
> > > > > > > Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> > > > > > > Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> > > > > > > Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
> > > > > > 
> > > > > > Hello Greg! Seems that you have forgot to apply some dependency patches.
> > > > > 
> > > > > You are right, I had one, not the other, now fixed up...
> > > > 
> > > > Nope, of_phy_put(phy) is not present in 5.4, so it needs a "real"
> > > > backport.
> > > > 
> > > > Can you do that?
> > > 
> > > Ok, I will look at it.
> > 
> > Now I have backported this patch to 5.4 version and tested it with old
> > arm trusted firmware (for which this patch is fixing support) and also
> > with the new arm trusted firmware. It is working fine in both cases.
> > 
> > Still this patch depends on two mentioned commits which are required.
> 
> This worked, thanks!
> 
> greg k-h

Perfect!

Just to note for other people, I have tested this backported patch on
linux 5.4 on Espressobin v5 board with "old arm trusted firmware"
version 2017.03-armada-17.10 from http://espressobin.net/tech-spec/

And on 5.4 kernel finally usb 3.0 port started working!

(of course with new arm trusted firmware compiled from source code there
is no such issue, but Espressobin comes with burned above old firmware
version)
