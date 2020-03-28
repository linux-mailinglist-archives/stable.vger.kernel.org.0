Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34F196912
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 21:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgC1UGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 16:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgC1UGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 16:06:36 -0400
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A103206E6;
        Sat, 28 Mar 2020 20:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585425995;
        bh=B6FtBp+Kqnrr1x0jjJQnixnajydww8BM+vQDsjzdV4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Qd/zSnxFEl0abPfcWo6gRSzrSZZkcwrZmB6C9HPDpLawRVL+DDjkVJC8Cpmt5WF6w
         4QGFmMCNE6+pf6T24if73Y1YLHiQSGisuKL1fBO6cwd/gwNTw12A1BMejm113uK/eU
         JlTxFv2R3UEtRiNGE7C50UFi2CQZ6EOfornWg3Sg=
Date:   Sat, 28 Mar 2020 15:06:33 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Kelsey Skunberg <skunberg.kelsey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        rbilovol@cisco.com, stable <stable@vger.kernel.org>,
        ddutile@redhat.com, ruslan.bilovol@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, bodong@mellanox.com
Subject: Re: [Linux-kernel-mentees] [PATCH v2] PCI: sysfs: Change bus_rescan
 and dev_rescan to rescan
Message-ID: <20200328200633.GA102137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326063524.GA922107@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 07:35:24AM +0100, Greg KH wrote:
> On Wed, Mar 25, 2020 at 05:10:33PM -0500, Bjorn Helgaas wrote:
> > -static DEVICE_ATTR_WO(dev_rescan);
> > +static struct device_attribute dev_attr_dev_rescan = __ATTR(rescan, 0200, NULL,
> > +							    dev_rescan_store);
> 
> Oops, this should just be DEVICE_ATTR(), no need for __ATTR() as this
> isn't a kobject-only file.
> 
> So how about:
> 
> static DEVICE_ATTR(rescan, 0200, NULL, dev_rescan_store);

I don' think DEVICE_ATTR() works in this case because it uses the
first argument ("rescan") to build both the C symbol for the
device_attribute struct and the sysfs filename.

There are two instances in this file.  The two sysfs "rescan" files
are not a problem, but the two "dev_attr_rescan_name" C symbols *are*.
We could resolve that by putting the bus attributes in a different
source file than the dev attributes, but it doesn't seem worth it now.

I tentatively have the patch below on pci/misc.  I dropped the
tested-by and reviewed-by because I didn't want to put words in your
mouths :)

Bjorn

commit bce34ce1806e ("PCI: sysfs: Revert "rescan" file renames")
Author: Kelsey Skunberg <kelsey.skunberg@gmail.com>
Date:   Wed Mar 25 09:17:08 2020 -0600

    PCI: sysfs: Revert "rescan" file renames
    
    We changed these sysfs filenames:
    
      .../pci_bus/<domain:bus>/rescan  ->  .../pci_bus/<domain:bus>/bus_rescan
      .../<domain:bus:dev.fn>/rescan   ->  .../<domain:bus:dev.fn>/dev_rescan
    
    and Ruslan reported [1] that this broke a userspace application.
    
    Revert these name changes so both files are named "rescan" again.
    
    Note that we have to use __ATTR() to assign custom C symbols, i.e.,
    "struct device_attribute <symbol>".
    
    [1] https://lore.kernel.org/r/CAB=otbSYozS-ZfxB0nCiNnxcbqxwrHOSYxJJtDKa63KzXbXgpw@mail.gmail.com
    
    [bhelgaas: commit log, use __ATTR() both places so we don't have to rename
    the attributes]
    Fixes: 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
    Fixes: 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
    Link: https://lore.kernel.org/r/20200325151708.32612-1-skunberg.kelsey@gmail.com
    Signed-off-by: Kelsey Skunberg <kelsey.skunberg@gmail.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Cc: stable@vger.kernel.org	# v5.4+

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 13f766db0684..335dd6fbf039 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -464,7 +464,8 @@ static ssize_t dev_rescan_store(struct device *dev,
 	}
 	return count;
 }
-static DEVICE_ATTR_WO(dev_rescan);
+static struct device_attribute dev_attr_dev_rescan = __ATTR(rescan, 0200, NULL,
+							    dev_rescan_store);
 
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
@@ -501,7 +502,8 @@ static ssize_t bus_rescan_store(struct device *dev,
 	}
 	return count;
 }
-static DEVICE_ATTR_WO(bus_rescan);
+static struct device_attribute dev_attr_bus_rescan = __ATTR(rescan, 0200, NULL,
+							    bus_rescan_store);
 
 #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
 static ssize_t d3cold_allowed_store(struct device *dev,
