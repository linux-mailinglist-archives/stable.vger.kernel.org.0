Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE102407E6
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHJOyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgHJOyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:54:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2309C2083B;
        Mon, 10 Aug 2020 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597071279;
        bh=RbAgEKU4BTgaaltGRGpTJshv45+bh5DMlkRg7PNl4rU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4LctFURVWcoDTbdDicjwVFvZnSmdbypikBrVdWqsDY4k8olAsMnnpy3aOCE0YFiw
         Bzwc85IrKiDhUX2UHkGtYPps2rmsDYssKV29g1g52fBBy1FxOdCGGEZ2Xs8wjb7tY2
         hh1pu41fqM2qAMq2zK+IWfMOOIiCoLhHEOHd+NsU=
Date:   Mon, 10 Aug 2020 16:54:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dima Stepanov <dimastep@yandex-team.ru>
Cc:     stable@vger.kernel.org, bjorn@helgaas.com
Subject: Re: [PATCH 4.19.y] PCI: Probe bridge window attributes once at
 enumeration-time
Message-ID: <20200810145450.GC3869733@kroah.com>
References: <1597069182-5075-1-git-send-email-dimastep@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597069182-5075-1-git-send-email-dimastep@yandex-team.ru>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:19:42PM +0300, Dima Stepanov wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> commit 51c48b310183ab6ba5419edfc6a8de889cc04521 upstream.
> 
> pci_bridge_check_ranges() determines whether a bridge supports the optional
> I/O and prefetchable memory windows and sets the flag bits in the bridge
> resources.  This *could* be done once during enumeration except that the
> resource allocation code completely clears the flag bits, e.g., in the
> pci_assign_unassigned_bridge_resources() path.
> 
> The problem with pci_bridge_check_ranges() in the resource allocation path
> is that we may allocate resources after devices have been claimed by
> drivers, and pci_bridge_check_ranges() *changes* the window registers to
> determine whether they're writable.  This may break concurrent accesses to
> devices behind the bridge.
> 
> Add a new pci_read_bridge_windows() to determine whether a bridge supports
> the optional windows, call it once during enumeration, remember the
> results, and change pci_bridge_check_ranges() so it doesn't touch the
> bridge windows but sets the flag bits based on those remembered results.
> 
> Link: https://lore.kernel.org/linux-pci/1506151482-113560-1-git-send-email-wangzhou1@hisilicon.com
> Link: https://lists.gnu.org/archive/html/qemu-devel/2018-12/msg02082.html
> Reported-by: Yandong Xu <xuyandong2@huawei.com>
> Tested-by: Yandong Xu <xuyandong2@huawei.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Ofer Hayut <ofer@lightbitslabs.com>
> Cc: Roy Shterman <roys@lightbitslabs.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Zhou Wang <wangzhou1@hisilicon.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208371
> Signed-off-by: Dima Stepanov <dimastep@yandex-team.ru>
> ---
>  drivers/pci/probe.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/setup-bus.c | 45 ++++--------------------------------------
>  include/linux/pci.h     |  3 +++
>  3 files changed, 59 insertions(+), 41 deletions(-)

Why is this now needed in 4.19.y?  What changed to require it and what
prevents the users from just using 5.4.y instead?

A bit of an explaination when backporting patches that are not obvious
"fixes" to much older kernels is always appreciated :)

thanks,

greg k-h
