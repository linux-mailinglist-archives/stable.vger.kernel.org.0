Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF569B8B6
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 01:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbfHWXGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 19:06:44 -0400
Received: from ale.deltatee.com ([207.54.116.67]:37440 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfHWXGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 19:06:44 -0400
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.89)
        (envelope-from <logang@deltatee.com>)
        id 1i1Idf-0004su-T5; Fri, 23 Aug 2019 17:06:36 -0600
To:     Nadav Amit <namit@vmware.com>, Joerg Roedel <joro@8bytes.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20190820085317.29458-1-namit@vmware.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <e0700e76-c8c5-7052-cf17-81cc7ad76d04@deltatee.com>
Date:   Fri, 23 Aug 2019 17:06:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820085317.29458-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: jacob.jun.pan@linux.intel.com, dwmw2@infradead.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, joro@8bytes.org, namit@vmware.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iommu/vt-d: Fix wrong analysis whether devices share the
 same bus
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019-08-20 2:53 a.m., Nadav Amit wrote:
> set_msi_sid_cb() is used to determine whether device aliases share the
> same bus, but it can provide false indications that aliases use the same
> bus when in fact they do not. The reason is that set_msi_sid_cb()
> assumes that pdev is fixed, while actually pci_for_each_dma_alias() can
> call fn() when pdev is set to a subordinate device.
> 
> As a result, running an VM on ESX with VT-d emulation enabled can
> results in the log warning such as:
> 
>   DMAR: [INTR-REMAP] Request device [00:11.0] fault index 3b [fault reason 38] Blocked an interrupt request due to source-id verification failure
> 
> This seems to cause additional ata errors such as:
>   ata3.00: qc timeout (cmd 0xa1)
>   ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> 
> These timeouts also cause boot to be much longer and other errors.
> 
> Fix it by checking comparing the alias with the previous one instead.
> 
> Fixes: 3f0c625c6ae71 ("iommu/vt-d: Allow interrupts from the entire bus for aliased devices")
> Cc: stable@vger.kernel.org
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>

This looks good to me.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks!

Logan
