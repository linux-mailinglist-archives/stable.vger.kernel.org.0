Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C4615C935
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 18:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBMRLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 12:11:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:49263 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727690AbgBMRLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 12:11:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 09:11:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="227296925"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2020 09:11:00 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1j2I10-001Auk-Pw; Thu, 13 Feb 2020 19:11:02 +0200
Date:   Thu, 13 Feb 2020 19:11:02 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware-pci: Fix BUG_ON during device removal
Message-ID: <20200213171102.GC10400@smile.fi.intel.com>
References: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
 <20200213161854.GA5929@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213161854.GA5929@ninjato>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 05:18:54PM +0100, Wolfram Sang wrote:
> On Thu, Feb 13, 2020 at 05:15:03PM +0200, Jarkko Nikula wrote:
> > Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
> > pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
> > enabled device since the driver has not released the requested IRQ before
> > calling the pci_free_irq_vectors().
> > 
> > Here driver requests an IRQ using devm_request_irq() but automatic
> > release happens only after remove callback. Fix this by explicitly
> > freeing the IRQ before calling pci_free_irq_vectors().
> 
> Does it make sense to keep devm for irq handling, then?

Only for sake of better error handling in error path in the ->probe().

-- 
With Best Regards,
Andy Shevchenko


