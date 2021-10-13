Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E37B42BB2A
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 11:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhJMJLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 05:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233922AbhJMJLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 05:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B58C860E05;
        Wed, 13 Oct 2021 09:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634116154;
        bh=lD0LBHnL4iuuiUUsO09L1GRdEIhu7jLM3NPLGnWow3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ot6OxZ8cYe7tjkTqNkGyU+HIjiBhFeyGiLN6l228HcABPkLxFk86UV3LOCunT8rGq
         BsbvdA4zkgOAxeOIos4uqViunjssasTJWvpsJvJm29oizyKywFzUXiF/lav9lXtPAC
         9L7ntKYzVG/bik9OWw1mW/Y7UZsHSxhKmtiKTFNw=
Date:   Wed, 13 Oct 2021 11:09:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     stable@vger.kernel.org, gor@linux.ibm.com
Subject: Re: [PATCH 5.10 STABLE] s390/pci: fix zpci_zdev_put() on reserve
Message-ID: <YWaiON5Hw8UnWLIK@kroah.com>
References: <16338613396828@kroah.com>
 <20211012093425.2247924-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093425.2247924-1-schnelle@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 11:34:25AM +0200, Niklas Schnelle wrote:
> [ Upstream commit a46044a92add6a400f4dada7b943b30221f7cc80 ]
> 
> Since commit 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> the reference count of a zpci_dev is incremented between
> pcibios_add_device() and pcibios_release_device() which was supposed to
> prevent the zpci_dev from being freed while the common PCI code has
> access to it. It was missed however that the handling of zPCI
> availability events assumed that once zpci_zdev_put() was called no
> later availability event would still see the device. With the previously
> mentioned commit however this assumption no longer holds and we must
> make sure that we only drop the initial long-lived reference the zPCI
> subsystem holds exactly once.
> 
> Do so by introducing a zpci_device_reserved() function that handles when
> a device is reserved. Here we make sure the zpci_dev will not be
> considered for further events by removing it from the zpci_list.
> 
> This also means that the device actually stays in the
> ZPCI_FN_STATE_RESERVED state between the time we know it has been
> reserved and the final reference going away. We thus need to consider it
> a real state instead of just a conceptual state after the removal. The
> final cleanup of PCI resources, removal from zbus, and destruction of
> the IOMMU stays in zpci_release_device() to make sure holders of the
> reference do see valid data until the release.

Same for the 5.14 patch, please submit the series that resolves this,
not changing individual patches a lot.

thanks,

greg k-h
