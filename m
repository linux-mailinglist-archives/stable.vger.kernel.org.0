Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF1D4CB2FE
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 00:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiCBXqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 18:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiCBXqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 18:46:01 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD6D239D5C;
        Wed,  2 Mar 2022 15:43:54 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.41.243])
        by gnuweeb.org (Postfix) with ESMTPSA id 1DEAD7E6A5;
        Wed,  2 Mar 2022 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646263662;
        bh=A0wJxlPbC6L5g/52O5FkT+betn2pvQrCWGTRFCIy5gg=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=TfZn8Kq++xUqI9AHW+rba3Ml8VA1cFtpJ/+y9jbgAdML//eyjZyT0eIgzQf2AR677
         xtQes501LvCiOoVx2OS2LSkTS6+xHOdawqZoF4Z06cJQSMDg8D8S4K3+Nt+8h00nCM
         cce/fHLpJUg2RJa9xktbajVJjTqkNdiBuVLrKAMIoo3wXrvCjw6GvCe4jkKd6wMxcy
         jxp8b56394wTwg0mS5VE5/TDSrTQk/2T9ADCCkRLF/ZO53une4ImRGKTRXO5q7CSUH
         bpsAFuxdbSXLMEfWcQWdd4RvOTj65JM2ObXz/Fo3iXaWpQfvB+xB1EQmIZa2ruD09r
         19BF0Q3n/Cjdg==
Message-ID: <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
Date:   Thu, 3 Mar 2022 06:27:33 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
In-Reply-To: <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/22 6:20 AM, Ammar Faizi wrote:
> On 3/3/22 12:26 AM, Yazen Ghannam wrote:
>> Hi Ammar,
> 
> Hi Yazen,
> 
>> ...
>> The threshold interrupt handler uses this pointer. I think the goal here is to
>> set this pointer when the list is fully formed and clear this pointer before
>> making any changes to the list. Otherwise, the interrupt handler will operate
>> on incomplete data if an interrupt comes in the middle of these updates.
>>
>> The changes below should deal with memory leak issue while avoiding a race
>> with the threshold interrupt. What do you think?
> 
> Thanks for taking a look into this. I didn't notice that before. The
> changes look good to me, extra improvements:
> 
> 1) _mce_threshold_remove_device() should be static as we don't use it
>     in another translation unit.
> 2) Minor cleanup, we don't need "goto out_err", just early return
>     directly.
> 
> I will fold them in...
> 

Please review the patch below, if you think it looks good, I will
send this for the v5 series. I added your sign-off.

 From cae3965734a67d11a5286c612dfddf52398defc8 Mon Sep 17 00:00:00 2001
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date: Thu, 3 Mar 2022 05:07:38 +0700
Subject: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails

In mce_threshold_create_device(), when threshold_create_bank() fails,
the @bp will be leaked, because mce_threshold_remove_device() will
not free the @bp. It only frees the @bp when we've already written
the @bp to the @threshold_banks per-CPU variable, but at the point,
we haven't.

Fix this by extracting the cleanup part into a new static function
_mce_threshold_remove_device(), then use it from create and remove
device function.

Also, eliminate the "goto out_err". Just early return inside the loop
when we fail.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v5.8+
Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-authored-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
  arch/x86/kernel/cpu/mce/amd.c | 31 ++++++++++++++++++-------------
  1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 9f4b508886dd..ac7246a4de08 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1293,10 +1293,22 @@ static void threshold_remove_bank(struct threshold_bank *bank)
  	kfree(bank);
  }
  
+static void _mce_threshold_remove_device(struct threshold_bank **bp)
+{
+	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
+
+	for (bank = 0; bank < numbanks; bank++) {
+		if (bp[bank]) {
+			threshold_remove_bank(bp[bank]);
+			bp[bank] = NULL;
+		}
+	}
+	kfree(bp);
+}
+
  int mce_threshold_remove_device(unsigned int cpu)
  {
  	struct threshold_bank **bp = this_cpu_read(threshold_banks);
-	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
  
  	if (!bp)
  		return 0;
@@ -1307,13 +1319,7 @@ int mce_threshold_remove_device(unsigned int cpu)
  	 */
  	this_cpu_write(threshold_banks, NULL);
  
-	for (bank = 0; bank < numbanks; bank++) {
-		if (bp[bank]) {
-			threshold_remove_bank(bp[bank]);
-			bp[bank] = NULL;
-		}
-	}
-	kfree(bp);
+	_mce_threshold_remove_device(bp);
  	return 0;
  }
  
@@ -1350,15 +1356,14 @@ int mce_threshold_create_device(unsigned int cpu)
  		if (!(this_cpu_read(bank_map) & (1 << bank)))
  			continue;
  		err = threshold_create_bank(bp, cpu, bank);
-		if (err)
-			goto out_err;
+		if (err) {
+			_mce_threshold_remove_device(bp);
+			return err;
+		}
  	}
  	this_cpu_write(threshold_banks, bp);
  
  	if (thresholding_irq_en)
  		mce_threshold_vector = amd_threshold_interrupt;
  	return 0;
-out_err:
-	mce_threshold_remove_device(cpu);
-	return err;
  }

-- 
Ammar Faizi
