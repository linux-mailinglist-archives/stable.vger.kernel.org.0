Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5325C2A61AD
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgKDKdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgKDKcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 05:32:15 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46947C0613D3;
        Wed,  4 Nov 2020 02:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rthagGeZr7BxtDl07Y9pYWCb/NLD6LNBksbUBb8wPnc=; b=rFnTYaktBfTd80yqUZq0DJTtQz
        MqdGxzv6Ck0RSiaUAAzrF3B9DuVOP8wZaVO4A42Bf38vl35emnmIZJsVPasGqcjHP9iEKaTBubIdu
        HoEv5qlZaXPlraYVML5pOW7nr1ZcKlOgHhERUqIMhz1jLMeWBvEy+r4nBP6E6mRRUV4vltiZz/Gsr
        2cGkDBlgq0v4hhZSWl1jcMEY3WqL6SwNG4NUwQaq0BCXemQvScnpin5rSAQvXH2VpIdJasP5Fvhgk
        H8i/oVjksrss9yPz8nsl2viGZTknHU3/v810WH6XokCkgfFoEIGz6ICMDX4eCcgSf2KdRYxRT4GkB
        8kyETbxg==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=kapsi.fi)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko@kernel.org>)
        id 1kaG5D-0005aU-3O; Wed, 04 Nov 2020 12:32:03 +0200
Date:   Wed, 4 Nov 2020 12:32:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        stable <stable@vger.kernel.org>,
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
Subject: Re: [PATCH v4 3/3,RESEND 2] KEYS: trusted: Reserve TPM for seal and
 unseal operations
Message-ID: <20201104103200.GA203745@kapsi.fi>
References: <20201013025156.111305-1-jarkko.sakkinen@linux.intel.com>
 <20201104011909.GD20387@kernel.org>
 <CAFA6WYO4HJThYHhBxbx0Tr97sF_JFvTBur9uTGSQTtyQaOKpig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYO4HJThYHhBxbx0Tr97sF_JFvTBur9uTGSQTtyQaOKpig@mail.gmail.com>
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jarkko@kernel.org
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 01:00:09PM +0530, Sumit Garg wrote:
> Hi Jarkko,
> 
> On Wed, 4 Nov 2020 at 06:49, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
> > the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
> > which are used to take temporarily the ownership of the TPM chip. The
> > ownership is only taken inside tpm_send(), but this is not sufficient,
> > as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
> > need to be done as a one single atom.
> >
> > Fix this issue by introducting trusted_tpm_load() and trusted_tpm_new(),
> > which wrap these operations, and take the TPM chip ownership before
> > sending anything.
> 
> I am not sure if we really need these new APIs in order to fix this
> issue, see below.

They are not API, as they are static functions. Not necessarily
disregarding the argument, just remarking a technical detail.

> > Use tpm_transmit_cmd() to send TPM commands instead
> > of tpm_send(), reverting back to the old behaviour.
> >
> > Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
> > Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > Cc: stable@vger.kernel.org
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > Cc: Sumit Garg <sumit.garg@linaro.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > ---
> >  drivers/char/tpm/tpm.h                    |  4 --
> >  include/linux/tpm.h                       |  5 +-
> >  security/keys/trusted-keys/trusted_tpm1.c | 78 +++++++++++++++--------
> >  security/keys/trusted-keys/trusted_tpm2.c |  6 +-
> >  4 files changed, 60 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index 947d1db0a5cc..283f78211c3a 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -164,8 +164,6 @@ extern const struct file_operations tpmrm_fops;
> >  extern struct idr dev_nums_idr;
> >
> >  ssize_t tpm_transmit(struct tpm_chip *chip, u8 *buf, size_t bufsiz);
> > -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
> > -                        size_t min_rsp_body_length, const char *desc);
> >  int tpm_get_timeouts(struct tpm_chip *);
> >  int tpm_auto_startup(struct tpm_chip *chip);
> >
> > @@ -194,8 +192,6 @@ static inline void tpm_msleep(unsigned int delay_msec)
> >  int tpm_chip_start(struct tpm_chip *chip);
> >  void tpm_chip_stop(struct tpm_chip *chip);
> >  struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
> > -__must_check int tpm_try_get_ops(struct tpm_chip *chip);
> > -void tpm_put_ops(struct tpm_chip *chip);
> >
> >  struct tpm_chip *tpm_chip_alloc(struct device *dev,
> >                                 const struct tpm_class_ops *ops);
> > diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> > index 8f4ff39f51e7..804a3f69bbd9 100644
> > --- a/include/linux/tpm.h
> > +++ b/include/linux/tpm.h
> > @@ -397,6 +397,10 @@ static inline u32 tpm2_rc_value(u32 rc)
> >  #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
> >
> >  extern int tpm_is_tpm2(struct tpm_chip *chip);
> > +extern __must_check int tpm_try_get_ops(struct tpm_chip *chip);
> > +extern void tpm_put_ops(struct tpm_chip *chip);
> > +extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
> > +                               size_t min_rsp_body_length, const char *desc);
> >  extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
> >                         struct tpm_digest *digest);
> >  extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
> > @@ -410,7 +414,6 @@ static inline int tpm_is_tpm2(struct tpm_chip *chip)
> >  {
> >         return -ENODEV;
> >  }
> > -
> >  static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
> >                                struct tpm_digest *digest)
> >  {
> > diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
> > index 7a937c3c5283..20ca18e17437 100644
> > --- a/security/keys/trusted-keys/trusted_tpm1.c
> > +++ b/security/keys/trusted-keys/trusted_tpm1.c
> > @@ -950,6 +950,51 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
> >         return p;
> >  }
> >
> > +static int trusted_tpm_load(struct tpm_chip *chip,
> > +                           struct trusted_key_payload *payload,
> > +                           struct trusted_key_options *options)
> > +{
> > +       int ret;
> > +
> > +       if (tpm_is_tpm2(chip)) {
> > +               ret = tpm_try_get_ops(chip);
> 
> Can't we move this TPM 2.0 specific operation within
> tpm2_unseal_trusted() instead?
> 
> > +               if (!ret) {
> > +                       ret = tpm2_unseal_trusted(chip, payload, options);
> > +                       tpm_put_ops(chip);
> 
> Ditto.
> 
> > +               }
> > +       } else {
> > +               ret = key_unseal(payload, options);
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static int trusted_tpm_new(struct tpm_chip *chip,
> > +                          struct trusted_key_payload *payload,
> > +                          struct trusted_key_options *options)
> > +{
> > +       int ret;
> > +
> > +       ret = tpm_get_random(chip, payload->key, payload->key_len);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       if (ret != payload->key_len)
> > +               return -EIO;
> > +
> > +       if (tpm_is_tpm2(chip)) {
> > +               ret = tpm_try_get_ops(chip);
> 
> Same here, to move this within tpm2_seal_trusted() instead?
> 
> > +               if (!ret) {
> > +                       ret = tpm2_seal_trusted(chip, payload, options);
> > +                       tpm_put_ops(chip);
> 
> Ditto.

I think that would make sense anyhow, as not introducing new static
functions means less potential merge conflicts when backporting. And
yeah, also probably makes your life easier with the feature patch set
under review.

I can refine this.

> -Sumit

/Jarkko
