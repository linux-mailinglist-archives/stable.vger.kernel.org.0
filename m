Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB58337173F
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 16:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhECO56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 10:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhECO56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 10:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4286361166;
        Mon,  3 May 2021 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620053825;
        bh=p0BJIJlzuPFaUslj6JNmj+oFyieoiT8v0bTQp2hvdN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/UA0eyb+02UVZvNL8dDB23AVLWxGfiIjVubVS91qQzH6+tajahryxunpFMfhIbui
         Acspei0n4phlFOCUnWGJw3q1INAIl4/P4IQWDhRo2J41PQdKqD+2apsUZL3GA4/XbV
         IZWmL91YTlF9BdOD5TNihSEoqUZMhEWxlTR/FD99x+rKQakfFQpKDvkB6a0oijZV3m
         2RgDy1te17WFVO1HDGtnX29ULWu2truKh3T19Lo2iH/XxInRtNwr1cIUsCgTjDymNA
         8Xba/zT3COeJssiYrYXNII3loceZHWT1ptbZ/ztCbP6pLVdRGnsN/TFViHuu0ISRb+
         ww02CEda5Nbpg==
Date:   Mon, 3 May 2021 07:57:02 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Prike Liang <Prike.Liang@amd.com>,
        linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Alexander.Deucher@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210503145702.GC910137@dhcp-10-100-145-180.wdc.com>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
 <20210430175049.GA664888@bjorn-Precision-5520>
 <20210503071407.GA3521294@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503071407.GA3521294@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 08:14:07AM +0100, Christoph Hellwig wrote:
> On Fri, Apr 30, 2021 at 12:50:49PM -0500, Bjorn Helgaas wrote:
> > Patch 2/2 only uses PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND in the nvme
> > driver, so AFAICT there is no reason for the PCI core to keep track of
> > the flag for you.
> > 
> > I see below that Christoph suggests it needs to be in the PCI core,
> > but the reason needs to be explained in the commit log.
> 
> As far as I can tell this has nothing to do with NVMe except for the
> fact that right now it mostly hits NVMe as the nvme drivers is one of
> the few drivers not always doing a full device shutdown when the
> system goes into the S3 power state.  But various x86 platforms now
> randomly power done the link in that case.

Right, and the v5 of this series uses a generic name for the PCI quirk
without mentioning "NVME".
