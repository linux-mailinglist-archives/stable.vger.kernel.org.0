Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125CE3600AF
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 05:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhDOD7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 23:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229450AbhDOD7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 23:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D8C6113B;
        Thu, 15 Apr 2021 03:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618459157;
        bh=Y9UrYPh7hOfgYdmdiFIrPbfr9C7EOIbuXP02917Z+6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MfYCY3t3cBYeTIta2d/4u2ALoyrcTZVUzgGfIscm8tMY2g3VnowGgUPfmdZX41uLV
         C5lcVQfDt1vt8jYLIjBe830yKBy4wSWqIaCU/i25kgchU3jcVPqLtFIKbB1VWyBl48
         ajzc+3B/sF8FiWrOYqoTu/5iEI+EbOtLtfPR2EIoC7wmxkPmgU61BOmWeS619P9fP5
         vgi8ANgBhRmiJOd/SO7PQfk21k44UVvq7xymDqkY1D7Auz8UgqKqIGeRdc4I8jT4X8
         WHEL3UxLdkkI1n1Hrrn27P+CvWFB+fa0cPXlGxAJNAI6dLhnQDj95MjfFqlrtrvlhB
         tkpVW+n/V2zsw==
Date:   Wed, 14 Apr 2021 20:59:15 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     "Liang, Prike" <Prike.Liang@amd.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Message-ID: <20210415035915.GA2450149@dhcp-10-100-145-180.wdc.com>
References: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
 <1618388281-15629-2-git-send-email-Prike.Liang@amd.com>
 <20210414162408.GC2448507@dhcp-10-100-145-180.wdc.com>
 <BYAPR12MB3238609A9A142C8A03AA587DFB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3238609A9A142C8A03AA587DFB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 03:22:52AM +0000, Liang, Prike wrote:
> > >
> > > +rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> >
> > Instead of assuming '0', shouldn't you use the domain of the NVMe PCI
> > device?
> Now we just add the NVMe shutdown quirk by checking the root complex ID instead of adding more and more variables endpoint NVMe device.

I understand what you are doing. I am just suggesting this quirk use the
RC of the device in question rather than assume the RC is in domain 0. I
realize a platform will probably align to your assumption. This is just
for correctness and should look like:

	rdev = pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus), 0, PCI_DEVFN(0, 0));
