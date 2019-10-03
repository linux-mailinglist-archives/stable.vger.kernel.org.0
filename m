Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961E0C9D8B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfJCLlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:41:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:53112 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729820AbfJCLlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 07:41:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 04:41:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,252,1566889200"; 
   d="scan'208";a="391916973"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by fmsmga005.fm.intel.com with ESMTP; 03 Oct 2019 04:41:19 -0700
Date:   Thu, 3 Oct 2019 14:41:19 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191003114119.GF8933@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1570024819.4999.119.camel@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 10:00:19AM -0400, Mimi Zohar wrote:
> On Thu, 2019-09-26 at 20:16 +0300, Jarkko Sakkinen wrote:
> > Only the kernel random pool should be used for generating random numbers.
> > TPM contributes to that pool among the other sources of entropy. In here it
> > is not, agreed, absolutely critical because TPM is what is trusted anyway
> > but in order to remove tpm_get_random() we need to first remove all the
> > call sites.
> 
> At what point during boot is the kernel random pool available?  Does
> this imply that you're planning on changing trusted keys as well?

Well trusted keys *must* be changed to use it. It is not a choice
because using a proprietary random number generator instead of defacto
one in the kernel can be categorized as a *regression*.

Also, TEE trusted keys cannot use the TPM option.

If it was not initialized early enough we would need fix that too.

I don't think there should be a problem anyway since encrypted keys is
already using get_random_bytes().

/Jarkko
