Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FE2417F8
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 10:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgHKIJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 04:09:20 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:39300 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728145AbgHKIJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 04:09:18 -0400
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A4EA62E1560;
        Tue, 11 Aug 2020 11:09:15 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Ic8suh4s6f-9Dv8QIqa;
        Tue, 11 Aug 2020 11:09:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1597133355; bh=1rDvWS4FPy7fEoXzbZP539373TA80MVbBCwAExvzFCA=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=TAlUvJe5XGIxkc/QXsbsTofLWa9iegMBbKAPlYYRCUy7uSUKKt+lUHeDGJsEPHzuI
         CQ5rCA8KTL6gqjN/3KMeyK2MT9+Lrpu9W2H27TjsAbiSYTqpLaXVxG3EAaEwlsKbwn
         ZR0ViSYTBq7M/ib1HYiTsx22+IoYyFx21jP+TicY=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:515::1:2])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TRp7LRXae0-9Dl04lAf;
        Tue, 11 Aug 2020 11:09:13 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Date:   Tue, 11 Aug 2020 11:09:12 +0300
From:   Dima Stepanov <dimastep@yandex-team.ru>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, bjorn@helgaas.com
Subject: Re: [PATCH 4.19.y] PCI: Probe bridge window attributes once at
 enumeration-time
Message-ID: <20200811080910.GA6094@dimastep-nix>
References: <1597069182-5075-1-git-send-email-dimastep@yandex-team.ru>
 <20200810145450.GC3869733@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810145450.GC3869733@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 04:54:50PM +0200, Greg KH wrote:
> On Mon, Aug 10, 2020 at 05:19:42PM +0300, Dima Stepanov wrote:
> > From: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > commit 51c48b310183ab6ba5419edfc6a8de889cc04521 upstream.
> > 
> > pci_bridge_check_ranges() determines whether a bridge supports the optional
> > I/O and prefetchable memory windows and sets the flag bits in the bridge
> > resources.  This *could* be done once during enumeration except that the
> > resource allocation code completely clears the flag bits, e.g., in the
> > pci_assign_unassigned_bridge_resources() path.
> > 
> > The problem with pci_bridge_check_ranges() in the resource allocation path
> > is that we may allocate resources after devices have been claimed by
> > drivers, and pci_bridge_check_ranges() *changes* the window registers to
> > determine whether they're writable.  This may break concurrent accesses to
> > devices behind the bridge.
> > 
> > Add a new pci_read_bridge_windows() to determine whether a bridge supports
> > the optional windows, call it once during enumeration, remember the
> > results, and change pci_bridge_check_ranges() so it doesn't touch the
> > bridge windows but sets the flag bits based on those remembered results.
> > 
> > Link: https://lore.kernel.org/linux-pci/1506151482-113560-1-git-send-email-wangzhou1@hisilicon.com
> > Link: https://lists.gnu.org/archive/html/qemu-devel/2018-12/msg02082.html
> > Reported-by: Yandong Xu <xuyandong2@huawei.com>
> > Tested-by: Yandong Xu <xuyandong2@huawei.com>
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Sagi Grimberg <sagi@grimberg.me>
> > Cc: Ofer Hayut <ofer@lightbitslabs.com>
> > Cc: Roy Shterman <roys@lightbitslabs.com>
> > Cc: Keith Busch <keith.busch@intel.com>
> > Cc: Zhou Wang <wangzhou1@hisilicon.com>
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208371
> > Signed-off-by: Dima Stepanov <dimastep@yandex-team.ru>
> > ---
> >  drivers/pci/probe.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/pci/setup-bus.c | 45 ++++--------------------------------------
> >  include/linux/pci.h     |  3 +++
> >  3 files changed, 59 insertions(+), 41 deletions(-)
> 
> Why is this now needed in 4.19.y?  What changed to require it and what
> prevents the users from just using 5.4.y instead?
> 
> A bit of an explaination when backporting patches that are not obvious
> "fixes" to much older kernels is always appreciated :)
> 
> thanks,
> 
> greg k-h

Hi Greg,

Sorry, was not sure how to make it properly.
So i'll try to describe the history of this issue:
- in 2017:
  https://lore.kernel.org/linux-pci/1506151482-113560-1-git-send-email-wangzhou1@hisilicon.com
- in 2018:
  https://lists.gnu.org/archive/html/qemu-devel/2018-12/msg02082.html
- in 2019 it was fixed:
  commit: 51c48b310183ab6ba5419edfc6a8de889cc04521
  And there was a small idea to add this patch to stable, if a bugzilla
  report will be added: https://lkml.org/lkml/2019/2/5/600. But as i
  understand there were some problems with reproducing.
- and we hit it again in 2020 and filed a bug for it with the steps to
  reproduce:
  https://bugzilla.kernel.org/show_bug.cgi?id=208371
Because of it, i thought that it really looks like an issue that
sometimes triggered.
And some words about motivation:
- What changed to require it? We filed a bugzilla bug and tried to prove
  that it is a real issue (not the possibility).
- In general nothing prevents users from using 5.4.y. But in big
  complicated environments (clouds) it is not obvious that exactly
  this issue leads to such behaviour. Also users can rely on default
  distribution kernels.

Sorry again, for a little confusion, not very familiar with the process,
but hope that this description helps. What do you think about it?

Thanks, Dima.
