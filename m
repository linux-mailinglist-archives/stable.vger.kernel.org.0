Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31248CC5A9
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbfJDWLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:11:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35852 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730814AbfJDWLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:11:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id BF8928EE27D;
        Fri,  4 Oct 2019 15:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570227070;
        bh=TFG7caQVqFJ3Q80Ho7+LboXA24+IoJDY4nVR3w9xVPA=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=Uwvx5G6diQgxoXrkYxzNofLkC7dZbBYJ7FY7Bl7X8TbM7S9Fw0AQyTuLann8WLD+f
         4dwv/2uh7nVPESoJ6sFEX6rVIwdQTvRuJrgjubzytGhpktWOy0ywkuSGPpU0Qt0PEU
         hJTTm/jA7pFdR4PqqjUrDU2WJo2Mc6hCsfKgOmnU=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zsxd6MXkHfIz; Fri,  4 Oct 2019 15:11:10 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E4B318EE0EE;
        Fri,  4 Oct 2019 15:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570227070;
        bh=TFG7caQVqFJ3Q80Ho7+LboXA24+IoJDY4nVR3w9xVPA=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=Uwvx5G6diQgxoXrkYxzNofLkC7dZbBYJ7FY7Bl7X8TbM7S9Fw0AQyTuLann8WLD+f
         4dwv/2uh7nVPESoJ6sFEX6rVIwdQTvRuJrgjubzytGhpktWOy0ywkuSGPpU0Qt0PEU
         hJTTm/jA7pFdR4PqqjUrDU2WJo2Mc6hCsfKgOmnU=
Message-ID: <1570227068.17537.4.camel@HansenPartnership.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 04 Oct 2019 15:11:08 -0700
In-Reply-To: <20191004201134.nuesk6hxtxajnxh2@cantor>
References: <1570128827.5046.19.camel@linux.ibm.com>
         <20191003215125.GA30511@linux.intel.com>
         <20191003215743.GB30511@linux.intel.com>
         <1570140491.5046.33.camel@linux.ibm.com>
         <1570147177.10818.11.camel@HansenPartnership.com>
         <20191004182216.GB6945@linux.intel.com>
         <1570213491.3563.27.camel@HansenPartnership.com>
         <20191004183342.y63qdvspojyf3m55@cantor>
         <1570214574.3563.32.camel@HansenPartnership.com>
         <20191004200728.xoj6jlgbhv57gepc@cantor>
         <20191004201134.nuesk6hxtxajnxh2@cantor>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-10-04 at 13:11 -0700, Jerry Snitselaar wrote:
> On Fri Oct 04 19, Jerry Snitselaar wrote:
> > On Fri Oct 04 19, James Bottomley wrote:
> > > On Fri, 2019-10-04 at 11:33 -0700, Jerry Snitselaar wrote:
> > > > On Fri Oct 04 19, James Bottomley wrote:
> > > > > On Fri, 2019-10-04 at 21:22 +0300, Jarkko Sakkinen wrote:
> > > > > > On Thu, Oct 03, 2019 at 04:59:37PM -0700, James Bottomley
> > > > > > wrote:
> > > > > > > I think the principle of using multiple RNG sources for
> > > > > > > strong keys is a sound one, so could I propose a
> > > > > > > compromise:  We have a tpm subsystem random number
> > > > > > > generator that, when asked for <n> random bytes first
> > > > > > > extracts <n> bytes from the TPM RNG and places it into
> > > > > > > the kernel entropy pool and then asks for <n> random
> > > > > > > bytes from the kernel RNG? That way, it will always have
> > > > > > > the entropy to satisfy the request and in the worst case,
> > > > > > > where the kernel has picked up no other entropy sources
> > > > > > > at all it will be equivalent to what we have now (single
> > > > > > > entropy source) but usually it will be a much better
> > > > > > > mixed entropy source.
> > > > > > 
> > > > > > I think we should rely the existing architecture where TPM
> > > > > > is contributing to the entropy pool as hwrng.
> > > > > 
> > > > > That doesn't seem to work: when I trace what happens I see us
> > > > > inject 32 bytes of entropy at boot time, but never again.  I
> > > > > think the problem is the kernel entropy pool is push not pull
> > > > > and we have no triggering event in the TPM to get us to
> > > > > push.  I suppose we could set a timer to do this or perhaps
> > > > > there is a pull hook and we haven't wired it up correctly?
> > > > > 
> > > > > James
> > > > > 
> > > > 
> > > > Shouldn't hwrng_fillfn be pulling from it?
> > > 
> > > It should, but the problem seems to be it only polls the
> > > "current" hw rng ... it doesn't seem to have a concept that there
> > > may be more than one.  What happens, according to a brief reading
> > > of the code, is when multiple are registered, it determines what
> > > the "best" one is and then only pulls from that.  What I think it
> > > should be doing is filling from all of them using the entropy
> > > quality to adjust how many bits we get.
> > > 
> > > James
> > > 
> > 
> > Most of them don't even set quality, including the tpm, so they end
> > up at the end of the list. For the ones that do I'm not sure how
> > they determined the value. For example virtio-rng sets quality to
> > 1000.
> 
> I should have added that I like that idea though.

OK, so I looked at how others implement this.  It turns out there's
only one other: the atheros rng and this is what it does:

drivers/net/wireless/ath/ath9k/rng.c

so rather than redoing the entirety of the TPM rng like this, I thought
it's easier to keep what we have (direct hwrng device) and plug our
tpm_get_random() function into the kernel rng like the below.  

James

---

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 3d6d394a8661..0794521c0784 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -536,7 +536,7 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
 
-	return tpm_get_random(chip, data, max);
+	return __tpm_get_random(chip, data, max);
 }
 
 static int tpm_add_hwrng(struct tpm_chip *chip)
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d7a3888ad80f..14631cba000c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/random.h>
 #include <linux/tpm_eventlog.h>
 
 #include "tpm.h"
@@ -424,15 +425,11 @@ int tpm_pm_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
-/**
- * tpm_get_random() - get random bytes from the TPM's RNG
- * @chip:	a &struct tpm_chip instance, %NULL for the default chip
- * @out:	destination buffer for the random bytes
- * @max:	the max number of bytes to write to @out
- *
- * Return: number of random bytes read or a negative error value.
+/*
+ * Internal interface for tpm_get_random(): gets the random string
+ * directly from the TPM without mixing into the linux rng.
  */
-int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
+int __tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 {
 	int rc;
 
@@ -451,6 +448,38 @@ int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 	tpm_put_ops(chip);
 	return rc;
 }
+
+/**
+ * tpm_get_random() - get random bytes influenced by the TPM's RNG
+ * @chip:	a &struct tpm_chip instance, %NULL for the default chip
+ * @out:	destination buffer for the random bytes
+ * @max:	the max number of bytes to write to @out
+ *
+ * Uses the TPM as a source of input to the kernel random number
+ * generator and then takes @max bytes directly from the kernel.  In
+ * the worst (no other entropy) case, this will return the pure TPM
+ * random number, but if the kernel RNG has any entropy at all it will
+ * return a mixed entropy output which doesn't rely on a single
+ * source.
+ *
+ * Return: number of random bytes read or a negative error value.
+ */
+int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
+{
+	int rc;
+
+	rc = __tpm_get_random(chip, out, max);
+	if (rc <= 0)
+		return rc;
+	/*
+	 * assume the TPM produces pure randomness, so the amount of
+	 * entropy is the number of bits returned
+	 */
+	add_hwgenerator_randomness(out, rc, rc * 8);
+	get_random_bytes(out, rc);
+
+	return rc;
+}
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
 /**
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index a7fea3e0ca86..25f6b347b194 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -398,6 +398,7 @@ int tpm1_get_pcr_allocation(struct tpm_chip *chip);
 unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm_pm_suspend(struct device *dev);
 int tpm_pm_resume(struct device *dev);
+int __tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max);
 
 static inline void tpm_msleep(unsigned int delay_msec)
 {
