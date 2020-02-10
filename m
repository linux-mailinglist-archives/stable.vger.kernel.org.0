Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4376E157F50
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 17:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBJQAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 11:00:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:17025 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbgBJQAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 11:00:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 08:00:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,425,1574150400"; 
   d="scan'208";a="380144630"
Received: from dvolkov-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.14.103])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2020 08:00:20 -0800
Date:   Mon, 10 Feb 2020 18:00:19 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, James.Bottomley@HansenPartnership.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/8] tpm: Initialize crypto_id of allocated_banks to
 HASH_ALGO__LAST
Message-ID: <20200210160019.GA8146@linux.intel.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
 <20200210100048.21448-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210100048.21448-2-roberto.sassu@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 11:00:41AM +0100, Roberto Sassu wrote:
> chip->allocated_banks, an array of tpm_bank_info structures, contains the
> list of TPM algorithm IDs of allocated PCR banks. It also contains the
> corresponding ID of the crypto subsystem, so that users of the TPM driver
> can calculate a digest for a PCR extend operation.
> 
> However, if there is no mapping between TPM algorithm ID and crypto ID, the
> crypto_id field of tpm_bank_info remains set to zero (the array is
> allocated and initialized with kcalloc() in tpm2_get_pcr_allocation()).
> Zero should not be used as value for unknown mappings, as it is a valid
> crypto ID (HASH_ALGO_MD4).
> 
> Thus, initialize crypto_id to HASH_ALGO__LAST.
> 
> Cc: stable@vger.kernel.org # 5.1.x
> Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
