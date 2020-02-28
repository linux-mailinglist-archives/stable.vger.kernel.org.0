Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F4517371F
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 13:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgB1MWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 07:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgB1MWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 07:22:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC4A24699;
        Fri, 28 Feb 2020 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582892562;
        bh=Wuw3bvUL29Jo42Nc55JCwqlCxD0ejzs3UCoKQSs9lGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8PVnIanWSuARmWWSGRKXAd5nhh2EKSu0UkoGAoN3SXZ6Wy9usn+CkcBTORMaJANl
         5A96sTi/Eb/KoiK8OmofVa5Qddj0i64ncUI0Hvze/+NFriRKEu2hViOC6o5EEjf/xO
         MxFPUDQfmCN4EbDdHx8NE3xCmrkMCLyLDqC5XJmc=
Date:   Fri, 28 Feb 2020 13:22:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andre Tomt <andre@tomt.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
Message-ID: <20200228122240.GA3012646@kroah.com>
References: <20200227132232.815448360@linuxfoundation.org>
 <d6212f9e-7e8d-95bd-18ca-8c44de224b28@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6212f9e-7e8d-95bd-18ca-8c44de224b28@tomt.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 01:06:00PM +0100, Andre Tomt wrote:
> On 27.02.2020 14:35, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.7 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> > Anything received after that time might be too late.
> 
> There is something going on with USB in this release. My AMD X570 board is
> constantly having ports stop working, while a older AMD X399 board seems
> fine (maybe, there is an ATEN USB extender involved on the X570 system)
> 
> I've only had time to do very rudimentary debugging, but reverting all usb
> and xhci related patches seems to have solved it, eg:
> 
> > usb-dwc2-fix-in-isoc-request-length-checking.patch
> > usb-gadget-composite-fix-bmaxpower-for-superspeedplus.patch
> > usb-dwc3-debug-fix-string-position-formatting-mixup-with-ret-and-len.patch
> > usb-dwc3-gadget-check-for-ioc-lst-bit-in-trb-ctrl-fields.patch
> > usb-dwc2-fix-set-clear_feature-and-get_status-flows.patch
> > usb-hub-fix-the-broken-detection-of-usb3-device-in-smsc-hub.patch
> > usb-hub-don-t-record-a-connect-change-event-during-reset-resume.patch
> > usb-fix-novation-sourcecontrol-xl-after-suspend.patch
> > usb-uas-fix-a-plug-unplug-racing.patch
> > usb-quirks-blacklist-duplicate-ep-on-sound-devices-usbpre2.patch
> > usb-core-add-endpoint-blacklist-quirk.patch
> > xhci-fix-memory-leak-when-caching-protocol-extended-capability-psi-tables-take-2.patch
> > xhci-apply-xhci_pme_stuck_quirk-to-intel-comet-lake-platforms.patch
> > xhci-fix-runtime-pm-enabling-for-quirky-intel-hosts.patch
> > xhci-force-maximum-packet-size-for-full-speed-bulk-devices-to-valid-range.patch
> > usb-serial-ch341-fix-receiver-regression.patch
> > usb-misc-iowarrior-add-support-for-the-100-device.patch
> > usb-misc-iowarrior-add-support-for-the-28-and-28l-devices.patch
> > usb-misc-iowarrior-add-support-for-2-oemed-devices.patch
> 
> I might be able to narrow it down in a day or two.

Narrowing it down would be good, try sticking with either the hub or
xhci patches.  And, 'git bisect' might make it easier.

Also, does Linus's current tree show the same problems for you?

thanks,

greg k-h
