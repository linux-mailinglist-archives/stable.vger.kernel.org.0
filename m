Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3AD212E18
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 22:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgGBUsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 16:48:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:38767 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgGBUsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 16:48:08 -0400
IronPort-SDR: O0K8KrBmcXy/x1qYfOANVIUlLVuvrTFza5iKpPsuFKmNy36C8TPNaEbbIwAcQAWvlhHlaiLcrM
 d5KR5XDehUBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="147036098"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="147036098"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 13:48:06 -0700
IronPort-SDR: jLI2ussQiJcwVAQDoqzZVUjyRMEtKTn40kOahLEmA6pJw0olSDFbMrl6BwY1keBaWQt2cyBacV
 bHKvJ4fkLLyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="282073619"
Received: from frichard-mobl.ger.corp.intel.com (HELO localhost) ([10.249.44.59])
  by orsmga006.jf.intel.com with ESMTP; 02 Jul 2020 13:48:01 -0700
Date:   Thu, 2 Jul 2020 23:48:00 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of
 PAGE_SIZE
Message-ID: <20200702204800.GC31291@linux.intel.com>
References: <20200626143436.396889-1-jarkko.sakkinen@linux.intel.com>
 <35184081-6f01-e13c-1b87-7c7d83d075c0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35184081-6f01-e13c-1b87-7c7d83d075c0@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 12:47:02PM -0400, Stefan Berger wrote:
> On 6/26/20 10:34 AM, Jarkko Sakkinen wrote:
> > The size of the buffers for storing context's and sessions can vary from
> > arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> > maximum for PPC64). Define a fixed buffer size set to 16 kB. This should
> > be enough for most use with three handles (that is how many we allow at
> > the moment).
> > 
> > Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >   drivers/char/tpm/tpm2-space.c | 27 ++++++++++++++++-----------
> >   1 file changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> > index 982d341d8837..9bef646093d1 100644
> > --- a/drivers/char/tpm/tpm2-space.c
> > +++ b/drivers/char/tpm/tpm2-space.c
> > @@ -15,6 +15,8 @@
> >   #include <asm/unaligned.h>
> >   #include "tpm.h"
> > +#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
> > +
> >   enum tpm2_handle_types {
> >   	TPM2_HT_HMAC_SESSION	= 0x02000000,
> >   	TPM2_HT_POLICY_SESSION	= 0x03000000,
> > @@ -40,11 +42,11 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
> >   int tpm2_init_space(struct tpm_space *space)
> >   {
> > -	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +	space->context_buf = kzalloc(TPM2_SPACE_BUFFER_SIZE, GFP_KERNEL);
> >   	if (!space->context_buf)
> >   		return -ENOMEM;
> > -	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +	space->session_buf = kzalloc(TPM2_SPACE_BUFFER_SIZE, GFP_KERNEL);
> >   	if (space->session_buf == NULL) {
> >   		kfree(space->context_buf);
> >   		return -ENOMEM;
> > @@ -311,8 +313,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
> >   	       sizeof(space->context_tbl));
> >   	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
> >   	       sizeof(space->session_tbl));
> > -	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
> > -	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
> > +	memcpy(chip->work_space.context_buf, space->context_buf,
> > +	       TPM2_SPACE_BUFFER_SIZE);
> > +	memcpy(chip->work_space.session_buf, space->session_buf,
> > +	       TPM2_SPACE_BUFFER_SIZE);
> >   	rc = tpm2_load_space(chip);
> >   	if (rc) {
> > @@ -492,8 +496,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
> >   			continue;
> >   		rc = tpm2_save_context(chip, space->context_tbl[i],
> > -				       space->context_buf, PAGE_SIZE,
> > -				       &offset);
> > +				       space->context_buf,
> > +				       TPM2_SPACE_BUFFER_SIZE, &offset);
> >   		if (rc == -ENOENT) {
> >   			space->context_tbl[i] = 0;
> >   			continue;
> > @@ -509,9 +513,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
> >   			continue;
> >   		rc = tpm2_save_context(chip, space->session_tbl[i],
> > -				       space->session_buf, PAGE_SIZE,
> > -				       &offset);
> > -
> > +				       space->session_buf,
> > +				       TPM2_SPACE_BUFFER_SIZE, &offset);
> >   		if (rc == -ENOENT) {
> >   			/* handle error saving session, just forget it */
> >   			space->session_tbl[i] = 0;
> > @@ -557,8 +560,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
> >   	       sizeof(space->context_tbl));
> >   	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
> >   	       sizeof(space->session_tbl));
> > -	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
> > -	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
> > +	memcpy(space->context_buf, chip->work_space.context_buf,
> > +	       TPM2_SPACE_BUFFER_SIZE);
> > +	memcpy(space->session_buf, chip->work_space.session_buf,
> > +	       TPM2_SPACE_BUFFER_SIZE);
> 
> 
> work_space.session_buf and context_buf also need allocation changes,
> otherwise we read from a smaller buffer here. See comment to other patch
> about tpm-chip.c .

Thank you, a good catch. I'll send an update.

/Jarkko
