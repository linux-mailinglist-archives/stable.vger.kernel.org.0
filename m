Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F243872EC
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 09:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbhERHPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 03:15:54 -0400
Received: from verein.lst.de ([213.95.11.211]:33089 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241081AbhERHPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 03:15:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6379267373; Tue, 18 May 2021 09:14:34 +0200 (CEST)
Date:   Tue, 18 May 2021 09:14:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     helgaas@kernel.org, linux-pci@vger.kernel.org, kbusch@kernel.org,
        axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, Alexander.Deucher@amd.com,
        stable@vger.kernel.org, Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH v5 0/2] nvme-pci: add AMD PCIe quirk for NVMe simple
 suspend/resume
Message-ID: <20210518071434.GA8635@lst.de>
References: <1621304675-17874-1-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621304675-17874-1-git-send-email-Prike.Liang@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This looks ok to me now.

As a note to the people in AMD who came up with this scheme:  having
to shut down the controller every time s2i is entered not only generally
uses more power than using power states, but also means every time
s2i is entered the SSD needs to write to the media, which causes massive
endurance shortfalls.

On Tue, May 18, 2021 at 10:24:33AM +0800, Prike Liang wrote:
> Those patch series can handle NVMe can't suspend to D3 during s2idle
> entry on some AMD platform. In this case, can be settld by assigning and
> passing a PCIe bus flag to the armed device which need NVMe shutdown opt
> in s2idle suspend and then use PCIe power setting to put the NVMe device
> to D3.
> 
> Prike Liang (2):
>   PCI: add AMD PCIe quirk for nvme shutdown opt
>   nvme-pci: add AMD PCIe quirk for simple suspend/resume
> 
>  drivers/nvme/host/pci.c | 2 ++
>  drivers/pci/probe.c     | 5 ++++-
>  drivers/pci/quirks.c    | 7 +++++++
>  include/linux/pci.h     | 2 ++
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> -- 
> 2.7.4
---end quoted text---
