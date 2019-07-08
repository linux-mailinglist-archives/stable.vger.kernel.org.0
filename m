Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDF6208E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfGHOem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:34:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:14786 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbfGHOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 10:34:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 07:34:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="248833705"
Received: from jsakkine-mobl1.tm.intel.com ([10.237.50.189])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2019 07:34:39 -0700
Message-ID: <58070e5ee4e64b10df063b61612b021c23f0fc14.camel@linux.intel.com>
Subject: Re: [PATCH v2] tpm: Fix null pointer dereference on chip register
 error path
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 08 Jul 2019 17:34:42 +0300
In-Reply-To: <20190704072615.31143-1-gmazyland@gmail.com>
References: <20190703230125.aynx4ianvqqjt5d7@linux.intel.com>
         <20190704072615.31143-1-gmazyland@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-07-04 at 09:26 +0200, Milan Broz wrote:
> If clk_enable is not defined and chip initialization
> is canceled code hits null dereference.
> 
> Easily reproducible with vTPM init fail:
>   swtpm chardev --tpmstate dir=nonexistent_dir --tpm2 --vtpm-proxy
> 
> BUG: kernel NULL pointer dereference, address: 00000000
> ...
> Call Trace:
>  tpm_chip_start+0x9d/0xa0 [tpm]
>  tpm_chip_register+0x10/0x1a0 [tpm]
>  vtpm_proxy_work+0x11/0x30 [tpm_vtpm_proxy]
>  process_one_work+0x214/0x5a0
>  worker_thread+0x134/0x3e0
>  ? process_one_work+0x5a0/0x5a0
>  kthread+0xd4/0x100
>  ? process_one_work+0x5a0/0x5a0
>  ? kthread_park+0x90/0x90
>  ret_from_fork+0x19/0x24
> 
> Fixes: 719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
> Cc: stable@vger.kernel.org # v5.1+
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

Looks legit.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

