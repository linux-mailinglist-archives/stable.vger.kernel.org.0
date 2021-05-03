Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FA53711E7
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 09:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhECHQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 03:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhECHP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 03:15:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADF4C06174A;
        Mon,  3 May 2021 00:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r3+bWFuh6BpobiX0nzWuylFbflLXDf37EtMjaGp93GE=; b=TLNC+76DerQfr/NL+2m7X/GSER
        uNvBpEDWThVt7XndOm7XxJHHjrELSCVyxrDDCIgHtY+U44JkKEk6s1/hX9mc0GO85CncaylbYfapK
        PzncFH7m2X8m+rx4bGhLefPDykOQM35bXTwQh0AXYIhBS74AUF9okmR29HxdR+imqnFU5+NV0wJXb
        dGYX6LzrgT67gSMyVQvtZid7xH5nv9H4w4WTkpWbV/aDxJ603s74JY3P52KKyMf5Gh1u7LlBmXtRy
        YyrXFXEe54aCiIlMAtU0H+974rld9xfgr4oUGdPN/dh37bb3RLrb7bV8CZ3AMMIEHATJOOdls386r
        Tu1bP3Jg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ldSmN-00EmJz-7Q; Mon, 03 May 2021 07:14:14 +0000
Date:   Mon, 3 May 2021 08:14:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Prike Liang <Prike.Liang@amd.com>, linux-nvme@lists.infradead.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org, stable@vger.kernel.org,
        Alexander.Deucher@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210503071407.GA3521294@infradead.org>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
 <20210430175049.GA664888@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430175049.GA664888@bjorn-Precision-5520>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 12:50:49PM -0500, Bjorn Helgaas wrote:
> This needs to be cc'd to linux-pci (I did it for you this time).

I did ask for that before.

> Sorry, I can't make any sense out of the commit log.  Is this a Root
> Port defect or an NVMe device defect?

It is a root port quirk, although it appears to be intentional as Intel
is doing the same thing on some platforms.

> Patch 2/2 only uses PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND in the nvme
> driver, so AFAICT there is no reason for the PCI core to keep track of
> the flag for you.
> 
> I see below that Christoph suggests it needs to be in the PCI core,
> but the reason needs to be explained in the commit log.

As far as I can tell this has nothing to do with NVMe except for the
fact that right now it mostly hits NVMe as the nvme drivers is one of
the few drivers not always doing a full device shutdown when the
system goes into the S3 power state.  But various x86 platforms now
randomly power done the link in that case.

> 
> I have not acked this patch.  Please don't merge it before clearing
> these things up.

I would never merge PCI core changes that haven't been reviewd by the
maintainer.
