Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892527DC5E
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 00:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgI2W6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 18:58:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:62972 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgI2W6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 18:58:45 -0400
IronPort-SDR: tvBJr29/btbKMWn+Rm+fW1z6k+0am/T0i0vt1G5kB7aHeIOO17+MeTfPSgxqii54NHTpHxpUKH
 uHwXkGW9Gi5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="161529615"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="161529615"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:58:45 -0700
IronPort-SDR: Uj9QCJcFJ5DlQ3q1dZ6+/KE7nBKWryO4CNTveA4wVwXU3Opvj6GUQDQYzenm3iJFYYKWNoV/xw
 omGIW1zPmSdA==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="493997635"
Received: from jwilliam-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.189])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:58:43 -0700
Date:   Wed, 30 Sep 2020 01:58:41 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KEYS: trusted: Reserve TPM for seal and unseal
 operations
Message-ID: <20200929225841.GA805025@linux.intel.com>
References: <20200929225141.804688-1-jarkko.sakkinen@linux.intel.com>
 <20200929225141.804688-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929225141.804688-2-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 01:51:41AM +0300, Jarkko Sakkinen wrote:
> When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
> the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
> which are used to take temporarily the ownership of the TPM chip. The
> ownership is only taken inside tpm_send(), but this is not sufficient,
> as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
> need to be done as a one single atom.
> 
> Fix this issue by introducting trusted_tpm_load() and trusted_tpm_new(),
> which wrap these operations, and take the TPM chip ownership before
> sending anything. Use tpm_transmit_cmd() to send TPM commands instead
> of tpm_send(), reverting back to the old behaviour.
> 
> Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
> Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Sumit Garg <sumit.garg@linaro.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I double checked that patches were in my BuildRoot rootfs and kernel.

I also did an update to tpm2-scripts:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/tpm2-scripts.git/

See the tip commit. That explains my ASN.1 testing issues. Now that test
script fully works again in all of my machines.

Lessons learned, or more like, how do we disclose this kind of testing
issue in future: I suggest that we migrate keyctl-smoke.sh (can be
possibly renamed) to the kernel selftests, and keep it up to date.

It would also degrade possible stability issues in trusted keys if
everyone has standard point of reference.

Thoughts?

/Jarkko
