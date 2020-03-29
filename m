Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F102196BA6
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgC2HdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 03:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgC2HdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Mar 2020 03:33:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA18206E6;
        Sun, 29 Mar 2020 07:33:08 +0000 (UTC)
Date:   Sun, 29 Mar 2020 09:33:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Kelsey Skunberg <skunberg.kelsey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        rbilovol@cisco.com, stable <stable@vger.kernel.org>,
        ddutile@redhat.com, ruslan.bilovol@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, bodong@mellanox.com
Subject: Re: [Linux-kernel-mentees] [PATCH v2] PCI: sysfs: Change bus_rescan
 and dev_rescan to rescan
Message-ID: <20200329073304.GA3911175@kroah.com>
References: <20200326063524.GA922107@kroah.com>
 <20200328200633.GA102137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200328200633.GA102137@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 28, 2020 at 03:06:33PM -0500, Bjorn Helgaas wrote:
> On Thu, Mar 26, 2020 at 07:35:24AM +0100, Greg KH wrote:
> > On Wed, Mar 25, 2020 at 05:10:33PM -0500, Bjorn Helgaas wrote:
> > > -static DEVICE_ATTR_WO(dev_rescan);
> > > +static struct device_attribute dev_attr_dev_rescan = __ATTR(rescan, 0200, NULL,
> > > +							    dev_rescan_store);
> > 
> > Oops, this should just be DEVICE_ATTR(), no need for __ATTR() as this
> > isn't a kobject-only file.
> > 
> > So how about:
> > 
> > static DEVICE_ATTR(rescan, 0200, NULL, dev_rescan_store);
> 
> I don' think DEVICE_ATTR() works in this case because it uses the
> first argument ("rescan") to build both the C symbol for the
> device_attribute struct and the sysfs filename.
> 
> There are two instances in this file.  The two sysfs "rescan" files
> are not a problem, but the two "dev_attr_rescan_name" C symbols *are*.
> We could resolve that by putting the bus attributes in a different
> source file than the dev attributes, but it doesn't seem worth it now.
> 
> I tentatively have the patch below on pci/misc.  I dropped the
> tested-by and reviewed-by because I didn't want to put words in your
> mouths :)

Ah, yeah, you are right __ATTR() is what you need to use here.

Your patch looks good:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
