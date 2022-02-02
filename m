Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2F94A78CB
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiBBTgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 14:36:16 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:40881 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiBBTgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 14:36:15 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id DD70E300002AA;
        Wed,  2 Feb 2022 20:36:13 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D0014D7C0; Wed,  2 Feb 2022 20:36:13 +0100 (CET)
Date:   Wed, 2 Feb 2022 20:36:13 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Joseph Bao <joseph.bao@intel.com>
Subject: Re: [PATCH 5.16 0873/1039] PCI: pciehp: Use
 down_read/write_nested(reset_lock) to fix lockdep errors
Message-ID: <20220202193613.GB18800@wunner.de>
References: <20220124184154.642601971@linuxfoundation.org>
 <20220125122323.GA1597465@bhelgaas>
 <Ye/wPpOrCfmKYCEj@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye/wPpOrCfmKYCEj@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 01:42:38PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 25, 2022 at 06:23:23AM -0600, Bjorn Helgaas wrote:
> > On Mon, Jan 24, 2022 at 07:44:22PM +0100, Greg Kroah-Hartman wrote:
> > > From: Hans de Goede <hdegoede@redhat.com>
> > > 
> > > commit 085a9f43433f30cbe8a1ade62d9d7827c3217f4d upstream.
> > 
> > I would hold off on backporting the pciehp changes until we resolve
> > this regression in v5.17-rc1:
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=215525
> 
> Thanks, I will drop it from all queues now.  If it gets resolved, please
> email stable@vger and we will be glad to add it back, along with the
> fix.

This turned out not to be an actual regression.  According to Bjorn,
"it was arguably a bug that it *did* work before", see:

https://lore.kernel.org/linux-pci/20220202164308.GA17822@bhelgaas/

Also, the culprit was not pciehp, but rather a change to _OSC handling
for VMD devices in commit 04b12ef163d1.

Thus, please consider re-adding these upstream commits to the stable queues:

  085a9f43433f30cbe8a1ade62d9d7827c3217f4d  (5.16, 5.15, 5.10)
  23584c1ed3e15a6f4bfab8dc5a88d94ab929ee12  (5.16, 5.15, 5.10, 5.4)

The release numbers in parentheses are the ones you originally queued the
commits up for.

Thanks!

Lukas
