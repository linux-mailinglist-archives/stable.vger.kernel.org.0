Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29EE065F80
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfGKSey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 14:34:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:27466 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728959AbfGKSey (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 14:34:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 11:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="341469281"
Received: from jolivell-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.138])
  by orsmga005.jf.intel.com with ESMTP; 11 Jul 2019 11:34:49 -0700
Date:   Thu, 11 Jul 2019 21:34:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        gregkh@linuxfoundation.org, sukhomlinov@google.com,
        Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations
Message-ID: <20190711183448.vqbr2nvyu5h237bb@linux.intel.com>
References: <20190711162919.23813-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711162919.23813-1-dianders@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> From: Vadim Sukhomlinov <sukhomlinov@google.com>
> 
> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> 
> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> future TPM operations. TPM 1.2 behavior was different, future TPM
> operations weren't disabled, causing rare issues. This patch ensures
> that future TPM operations are disabled.
> 
> Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> [dianders: resolved merge conflicts with mainline]
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> This is the backport of the patch referenced above to 4.19 as was done
> in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> presumably applies to some older kernels.  NOTE that the problem
> itself has existed for a long time, but continuing to backport this
> exact solution to super old kernels is out of scope for me.  For those
> truly interested feel free to reference the past discussion [1].
> 
> Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> chip power gating out of tpm_transmit()") and commit 719b7d81f204
> ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> seem like a good idea to backport 17 patches to avoid the conflict.

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
