Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417C315D4AD
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 10:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgBNJ0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 04:26:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:56730 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgBNJ0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 04:26:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 01:26:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,440,1574150400"; 
   d="scan'208";a="434725986"
Received: from mylly.fi.intel.com (HELO [10.237.72.54]) ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2020 01:26:37 -0800
Subject: Re: [PATCH] i2c: designware-pci: Fix BUG_ON during device removal
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Cc:     linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
References: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
 <20200213161854.GA5929@ninjato> <20200213171102.GC10400@smile.fi.intel.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <a3ddc7c3-5cd5-e338-d776-a98b7deae9d2@linux.intel.com>
Date:   Fri, 14 Feb 2020 11:26:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200213171102.GC10400@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 7:11 PM, Andy Shevchenko wrote:
> On Thu, Feb 13, 2020 at 05:18:54PM +0100, Wolfram Sang wrote:
>> On Thu, Feb 13, 2020 at 05:15:03PM +0200, Jarkko Nikula wrote:
>>> Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
>>> pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
>>> enabled device since the driver has not released the requested IRQ before
>>> calling the pci_free_irq_vectors().
>>>
>>> Here driver requests an IRQ using devm_request_irq() but automatic
>>> release happens only after remove callback. Fix this by explicitly
>>> freeing the IRQ before calling pci_free_irq_vectors().
>>
>> Does it make sense to keep devm for irq handling, then?
> 
I thought about it and decided devm still saves one line of code in 
drivers/i2c/busses/i2c-designware-platdrv.c: dw_i2c_plat_remove().

> Only for sake of better error handling in error path in the ->probe().
> 
Yeah, that too.

-- 
Jarkko
