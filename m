Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D1B11BAE3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 19:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfLKSAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 13:00:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:47202 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730578AbfLKSAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 13:00:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 10:00:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="220507774"
Received: from cmclough-mobl.ger.corp.intel.com (HELO localhost) ([10.251.85.152])
  by fmsmga001.fm.intel.com with ESMTP; 11 Dec 2019 10:00:46 -0800
Date:   Wed, 11 Dec 2019 20:00:45 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Tadeusz Struk <tadeusz.struk@intel.com>
Cc:     peterz@infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jgg@ziepe.ca, mingo@redhat.com,
        jeffrin@rajagiritech.edu.in, linux-integrity@vger.kernel.org,
        will@kernel.org, peterhuewe@gmx.de
Subject: Re: [PATCH] tpm: fix WARNING: lock held when returning to user space
Message-ID: <20191211180045.GN4516@linux.intel.com>
References: <34e5340f-de75-f20e-7898-6142eac45c13@intel.com>
 <157601267151.12904.7408818232910113434.stgit@tstruk-mobl1>
 <20191211175119.GI4516@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211175119.GI4516@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 07:52:02PM +0200, Jarkko Sakkinen wrote:
> On Tue, Dec 10, 2019 at 01:17:51PM -0800, Tadeusz Struk wrote:
> > When an application sends TPM commands in NONBLOCKING mode
> > the driver holds chip->tpm_mutex returning from write(),
> > which triggers WARNING: lock held when returning to user space!
> > To silence this warning the driver needs to release the mutex
> > and acquire it again in tpm_dev_async_work() before sending
> > the command.
> 
> This commit message is nonsense ATM. The code leaves locks held,
> which is unacceptable.
> 
> Silencing warnings is worst possible rationale for a code change
> that I can think of starting from the fact that is straight out
> wrong and malicious.

The code change, however, seems to be doing the right thing.

Please bundle it with the test and fix the commit message
appropriately.

/Jarkko
