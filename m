Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6416E22A444
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387546AbgGWBEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733221AbgGWBEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 21:04:38 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2304A2086A;
        Thu, 23 Jul 2020 01:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595466277;
        bh=vuI1DM19pqZiO1W8ggE5LH1WTZ2Zpcgqkw+bo5G96Ck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MpOL3ZEwKycICyUmrC1pWvUtYaPqBRrm/poJm+Ttw+ilyCs2OunPnbiK0/+5wn6GA
         iSX9250ee4qncolPYrWXRTazw378B+mZOYLVwC6ST85WE6hdohzUUcDhbCzYnSjxVD
         7+Q7zIhhuaxjOKax49rs2eFqF0bQfD3akrbJvs1o=
Date:   Wed, 22 Jul 2020 20:04:35 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Robert Hancock <hancockrwd@gmail.com>
Cc:     linux-pci@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Puranjay Mohan <puranjay12@gmail.com>
Subject: Re: [PATCH] PCI: Disallow ASPM on ASMedia ASM1083/1085 PCIe-PCI
 bridge
Message-ID: <20200723010435.GA1334095@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADLC3L0b8zqJoHt7aA6z6hb3cYC2z-32vmQsQ3tR0gGduC8+-Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 06:46:06PM -0600, Robert Hancock wrote:
> On Wed, Jul 22, 2020 at 11:40 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Tue, Jul 21, 2020 at 08:18:03PM -0600, Robert Hancock wrote:
> > > Recently ASPM handling was changed to no longer disable ASPM on all
> > > PCIe to PCI bridges. Unfortunately these ASMedia PCIe to PCI bridge
> > > devices don't seem to function properly with ASPM enabled, as they
> > > cause the parent PCIe root port to cause repeated AER timeout errors.
> > > In addition to flooding the kernel log, this also causes the machine
> > > to wake up immediately after suspend is initiated.
> >
> > Hi Robert, thanks a lot for the report of this problem
> > (https://lore.kernel.org/r/CADLC3L1R2hssRjxHJv9yhdN_7-hGw58rXSfNp-FraZh0Tw+gRw@mail.gmail.com
> > and https://bugzilla.redhat.com/show_bug.cgi?id=1853960).
> >
> > I'm pretty sure Linux ASPM support is missing some things.  This
> > problem might be a hardware problem where a quirk is the right
> > solution, but it could also be that it's a result of a Linux defect
> > that we should fix.
> >
> > Could you collect the dmesg log and "sudo lspci -vvxxxx" output
> > somewhere (maybe a bugzilla.kernel.org issue)?  I want to figure out
> > whether this L1 PM substates are enabled on this link, and whether
> > that's configured correctly.
> 
> Created a Bugzilla entry and added dmesg and lspci output:
> https://bugzilla.kernel.org/show_bug.cgi?id=208667
> 
> As I noted in that report, I subsequently found this page on ASMedia's
> site: https://www.asmedia.com.tw/eng/e_show_products.php?cate_index=169&item=114
> which indicates this ASM1083 device has "No PCIe ASPM support".

How nice.  According to your lspci, the device itself claims to
support ASPM:

  02:00.0 ... ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge
    LnkCap: ... ASPM L0s L1 ...

but the web page claims otherwise.  That would mean the device is
defective for claiming something that's not true.  Or possibly those
capability bits can be set by BIOS.

> It's not clear why this problem isn't occurring on Windows however -
> either it is not enabling ASPM, somehow it doesn't cause issues with
> the PCIe link, or it is causing issues and just doesn't notify the
> user in any way. I can try and check if this bridge device is ending
> up with ASPM enabled under Windows 10 or not..

If Windows *does* manage to enable ASPM, that would be interesting.  I
don't know whether Windows has a similar quirk mechanism.  I suppose
they must have *some* way to work around defective devices.

Bjorn
