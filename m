Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBA236042F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 10:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhDOIWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 04:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhDOIWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 04:22:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6D9C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 01:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mzdZB4W4tK1YoIpVXqrIlcRVaBOWBGFtglH23yBLCYQ=; b=PqxpC1HoBQMfT7UhjbGe6NyvPo
        NQIo1S+c0inu2jcPBThF7xynKpRd9S+WvWGGEiSzbyo5UXcEawSEDUW+Z0Jy6b5w9TKFUkzr4nMxz
        ZNpH8FlfQCBwSWkrWl2sxso2IBd61ERyj5kzX/ZdmqXC2lkjxEKjz4OCv6zwmOds8WAI9GaynVOrX
        qDCf5Lml34Fjlqbh1ega0RUv8VgmWNf+RemIeq0XLvhHFk1vQjJOOqZD9jHPleVOM/3cdpnXkq/y/
        VX56hlcc3A7TmVYVqycTJbZiwk+MAWnbS6KkCMu3A9ng5yM+xH1RNBDIEubiFWMOM9lLoYtE2P1eP
        WKygqKpg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWxFB-008Hiw-Bc; Thu, 15 Apr 2021 08:21:00 +0000
Date:   Thu, 15 Apr 2021 09:20:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org,
        stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210415082057.GA1973565@infradead.org>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A cover letter for the series would be really nice.

On Thu, Apr 15, 2021 at 11:52:04AM +0800, Prike Liang wrote:
> The NVME device pluged in some AMD PCIE root port will resume timeout
> from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> This issue can be workaround by using PCIe power set with simple
> suspend/resume process path instead of APST. In the onwards ASIC will
> try do the NVME shutdown save and restore in the BIOS and still need PCIe
> power setting to resume from RTD3 for s2idle.
> 
> In this preparation patch add a PCIe quirk for the AMD.

The above looks very hard to understand to me.  It uses some AMD
specific terms, and also is overly specific to NVMe.  Any other PCIe
device not doing a runtime-D3 in these slots will have the same problem.

So I think you should generalize the flag name and description to
describe what broken behavior the AMD root port has here, and only
cursory refer to drivers that are broken by it.

I'd also much prefer if the flag is used on every pci_dev that is
affected by the broken behavior rather than requiring another lookup
in the driver.
