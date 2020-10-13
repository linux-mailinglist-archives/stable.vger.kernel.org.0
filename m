Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA28F28C740
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 04:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgJMCrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 22:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgJMCrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 22:47:22 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D04121582;
        Tue, 13 Oct 2020 02:39:29 +0000 (UTC)
Date:   Tue, 13 Oct 2020 05:39:27 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     linux-integrity@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org,
        Sumit Garg <sumit.garg@linaro.org>,
        kernel test robot <lkp@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Alexey Klimov <aklimov@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>,
        "open list:SECURITY SUBSYSTEM" 
        <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KEYS: trusted: Reserve TPM for seal and unseal
 operations
Message-ID: <20201013023927.GA71954@linux.intel.com>
References: <20201013002815.40256-1-jarkko.sakkinen@linux.intel.com>
 <20201013002815.40256-4-jarkko.sakkinen@linux.intel.com>
 <b56dd2e9f3934e24f08005b9c5588c54b4837ff6.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b56dd2e9f3934e24f08005b9c5588c54b4837ff6.camel@HansenPartnership.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 05:58:04PM -0700, James Bottomley wrote:
> On Tue, 2020-10-13 at 03:28 +0300, Jarkko Sakkinen wrote:
> [...]
> > diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> > index 8f4ff39f51e7..f0ebce14d2f8 100644
> > --- a/include/linux/tpm.h
> > +++ b/include/linux/tpm.h
> > @@ -397,6 +397,10 @@ static inline u32 tpm2_rc_value(u32 rc)
> >  #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
> >  
> >  extern int tpm_is_tpm2(struct tpm_chip *chip);
> > +extern __must_check int tpm_try_get_ops(struct tpm_chip *chip);
> > +extern void tpm_put_ops(struct tpm_chip *chip);
> > +extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct
> > tpm_buf *buf,
> > +				size_t min_rsp_body_length, const char
> > *desc);
> >  extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
> >  			struct tpm_digest *digest);
> >  extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
> > @@ -410,7 +414,18 @@ static inline int tpm_is_tpm2(struct tpm_chip
> > *chip)
> >  {
> >  	return -ENODEV;
> >  }
> > -
> > +static inline int tpm_try_get_ops(struct tpm_chip *chip)
> > +{
> > +	return -ENODEV;
> > +}
> > +static inline void tpm_put_ops(struct tpm_chip *chip)
> > +{
> > +}
> > +static inline ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct
> > tpm_buf *buf,
> > +				       size_t min_rsp_body_length,
> > const char *desc)
> > +{
> > +	return -ENODEV;
> > +}
> >  static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
> 
> I don't think we want this, do we?  That's only for API access which
> should be available when the TPM isn't selected.  Given that get/put
> are TPM critical operations, they should only appear when inside code
> where the TPM has already been selected.  If they appear outside TPM
> selected code, I think we want the compile to fail, which is why we
> don't want these backup definitions.
> 
> James

OK, I'll change it.

Thanks.

/Jarkko
