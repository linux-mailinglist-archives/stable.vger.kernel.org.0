Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4304CB502
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 03:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiCCCdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 21:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiCCCdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 21:33:12 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADCF13E81;
        Wed,  2 Mar 2022 18:32:27 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.41.243])
        by gnuweeb.org (Postfix) with ESMTPSA id 121D27E216;
        Thu,  3 Mar 2022 02:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646274746;
        bh=TUzitEj4aBUgL+Bsby3W+X8ST/3/o4WMlq2+CFaMLXc=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=V/yQ/RvNucXD536SfA72fKV1ZavNrFL3JskOc6rzZ4JeAVnJKjFgrUhmWgXrHn9OZ
         /LqDbtCdRLJgeLXxpr8h9rJafDc018OJ7E1OeSc3xzdA86Poh4aK39XkaRnNTNaa8u
         4DoB5b3yOzFc48YJT3EkxRBl6oLIp9iWtwDuCPADZXTgUaAUAkOYt9amDHixCDTDI+
         aj78JdonuLchwVUgUhiQHbqHFj6EFpsAmcyPdZgRbgKJWVHs8TuzQKm/vvxvfbUPlJ
         e3EpTdFpG1a0KP37WiWKUL793vefDKYlm4z+dkGgy/ukehmfOZE3G2p1wvuXRjP0HJ
         CiK7bZ5leNs4A==
Message-ID: <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
Date:   Thu, 3 Mar 2022 09:32:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
 <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
 <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
 <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
In-Reply-To: <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/22 9:07 AM, Ammar Faizi wrote:
> On 3/3/22 8:58 AM, Alviro Iskandar Setiawan wrote:
>> hi sir, i think this can be improved again, we can avoid calling
>> this_cpu_read(mce_num_banks) twice if we pass the numbanks as an
>> argument, plz review the changes below
> 
> OK, nice improvement. I will fold this in...
> 

It looks like this now. Yazen, Alviro, please review the
following patch. If you think it looks good, I will submit
it for the v5.

 From 91a447f837d502b7a040cd68f333fb98f4b941d9 Mon Sep 17 00:00:00 2001
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date: Thu, 3 Mar 2022 09:22:17 +0700
Subject: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails

In mce_threshold_create_device(), if threshold_create_bank() fails, the
@bp will be leaked, because mce_threshold_remove_device() will not free
the @bp. It only frees the @bp when we've already written the @bp to
the @threshold_banks per-CPU variable, but at the point, we haven't.

Fix this by extracting the cleanup part into a new static function
_mce_threshold_remove_device(), then use it from create/remove device
function. Also, eliminate the "goto out_err". Just early return inside
the loop if we fail.

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
  arch/x86/kernel/cpu/mce/amd.c | 32 +++++++++++++++++++-------------
  1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 9f4b508886dd..e492efab68a2 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1293,10 +1293,23 @@ static void threshold_remove_bank(struct threshold_bank *bank)
  	kfree(bank);
  }
  
+static void _mce_threshold_remove_device(struct threshold_bank **bp,
+					 unsigned int numbanks)
+{
+	unsigned int bank;
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
@@ -1307,13 +1320,7 @@ int mce_threshold_remove_device(unsigned int cpu)
  	 */
  	this_cpu_write(threshold_banks, NULL);
  
-	for (bank = 0; bank < numbanks; bank++) {
-		if (bp[bank]) {
-			threshold_remove_bank(bp[bank]);
-			bp[bank] = NULL;
-		}
-	}
-	kfree(bp);
+	_mce_threshold_remove_device(bp, this_cpu_read(mce_num_banks));
  	return 0;
  }
  
@@ -1350,15 +1357,14 @@ int mce_threshold_create_device(unsigned int cpu)
  		if (!(this_cpu_read(bank_map) & (1 << bank)))
  			continue;
  		err = threshold_create_bank(bp, cpu, bank);
-		if (err)
-			goto out_err;
+		if (err) {
+			_mce_threshold_remove_device(bp, numbanks);
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

