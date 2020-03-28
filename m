Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD72196908
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 20:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgC1T7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 15:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbgC1T7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 15:59:35 -0400
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A06206E6;
        Sat, 28 Mar 2020 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585425574;
        bh=Qj/IrxEUrTlO01aVKjX/HLCY5OaDZhl6OPgn/ojV58k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ram8R/hVH3t8q4JC9mluTDr9CBxoglo0di72qnNIZtRoirOglWN8O6nWs7oK2JgiC
         nRbgMGdqri5yFMz0cvwDUcDyRinRKWUeNG286NCjrV6yP7aS9Gmaaz7U8x9f/vomgX
         Kj+VnbjVWjPKMiQbdf7WIt6hXEhiYwjMBuKKpUQw=
Date:   Sat, 28 Mar 2020 14:59:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kelsey <skunberg.kelsey@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org,
        Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        rbilovol@cisco.com, stable <stable@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Bodong Wang <bodong@mellanox.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2] PCI: sysfs: Change bus_rescan
 and dev_rescan to rescan
Message-ID: <20200328195932.GA96482@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFVqi1R0Cc4+wqwCr9-8HoTU+6cShzorD44YzDNyex+jv1dztA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 12:29:11AM -0600, Kelsey wrote:
> On Wed, Mar 25, 2020 at 4:10 PM Bjorn Helgaas <helgaas@kernel.org> wrote:

> > Thanks for taking care of this!  Two questions:
> >
> > 1) You supplied permissions of 0220, but DEVICE_ATTR_WO()
> > uses__ATTR_WO(), which uses 0200.  Shouldn't we keep 0200?
> >
> 
> Good catch. Before changing to DEVICE_ATTR_WO(), the permissions used
> was (S_IWUSR | S_IWGRP), which would be 0220. This means the
> permissions were mistakenly changed from 0220 to 0200 in the same
> patch:
> 
> commit 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
> 
> To verify DEVICE_ATTR_WO() is using __ATTR_WO() can be seen in
> /include/linux/device.h
> To verify permissions for __ATTR_WO() is 0200 can be seen in
> /inlcude/linux/sysfs.h
> 
> These attributes had permissions 0220 when first being introduced and
> before the above mentioned patch, so I'm on the side to believe that
> 0220 should be used.

I'm not sure it was a mistake that 4e2b79436e4f changed from 0220 to
200 or not.  I'd say __ATTR_WO (0200) is the "standard" one, and we
should have a special reason to use 0220.
