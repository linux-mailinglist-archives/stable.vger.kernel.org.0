Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637DA67790D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 11:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjAWKWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 05:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjAWKWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 05:22:43 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB6E390;
        Mon, 23 Jan 2023 02:22:41 -0800 (PST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4P0mL63q7Hz6J6Y4;
        Mon, 23 Jan 2023 18:19:26 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 10:22:38 +0000
Date:   Mon, 23 Jan 2023 10:22:37 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>, <darwi@linutronix.de>,
        <elena.reshetova@intel.com>, <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        <stable@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Message-ID: <20230123102237.00006bfa@Huawei.com>
In-Reply-To: <Y80WtujnO7kfduAZ@kroah.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
        <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
        <Y8z7FPcuDXDBi+1U@unreal>
        <Y80WtujnO7kfduAZ@kroah.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 22 Jan 2023 11:57:58 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Jan 22, 2023 at 11:00:04AM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:  
> > > A malicious device can change its MSIX table size between the table
> > > ioremap() and subsequent accesses, resulting in a kernel page fault in
> > > pci_write_msg_msix().
> > > 
> > > To avoid this, cache the table size observed at the moment of table
> > > ioremap() and use the cached value. This, however, does not help drivers
> > > that peek at the PCIE_MSIX_FLAGS register directly.
> > > 
> > > Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/pci/msi/api.c | 7 ++++++-
> > >  drivers/pci/msi/msi.c | 2 +-
> > >  include/linux/pci.h   | 1 +
> > >  3 files changed, 8 insertions(+), 2 deletions(-)  
> > 
> > I'm not security expert here, but not sure that this protects from anything.
> > 1. Kernel relies on working and not-malicious HW. There are gazillion ways
> > to cause crashes other than changing MSI-X.  
> 
> Linux does NOT protect from malicious PCIe devices at this point in
> time, you are correct.  If we wish to change that model, then we can
> work on that with the explict understanding that most all drivers will
> need to change as will the bus logic for the busses involved.
> 
> To do piece-meal patches like this for no good reason is not a good idea
> as it achieves nothing in the end :(
> 
> thanks,
> 
> greg k-h

If you care enough about potential malicious PCIe devices, do device
attestation and reject any devices that don't support it (which means
rejecting pretty much everything today ;).
Or potentially limit what non attested devices are allowed to do.

+CC Lukas who is working on this.

Jonathan
