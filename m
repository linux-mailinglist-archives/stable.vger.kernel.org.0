Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7224CB4A1
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 03:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiCCB72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 20:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiCCB70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 20:59:26 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B01C1D0E4;
        Wed,  2 Mar 2022 17:58:40 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 263627E216;
        Thu,  3 Mar 2022 01:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646272719;
        bh=4+k143TpGDWGZE7ivmqrV4mMaZsznJilER3TE6gUYVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZWdRa4iQq4fHPJE7c41QlUkjyxU/XUN/ZfMoYB976vroshgWVWfckORy71AeIEiX
         FWOQCqf031hwcaJwy970w2mS/pMkYVnR38L/WzZMeLwb8cn3gF/+bhHCYs89t6EKLD
         ghIq2Vgyz9QnW1JKAUJcRpy0duYZTC2V6nQfJXB0dfcR3Mif79HCf4EiqecMHsvS+P
         5IOZ6JBM/DjP+WcJ1v+Ct3rCDEAaII3PW5Bmz1LxCPQxEsYrTHSe0OjezrUMJPeL3w
         jzm+5XTXE3TENc47b1TxgXyvfZaRqUkLwio1EK6eF1BHvbncqIAyXb0uWRz/HoS+QT
         KMr1VyYTWmSCw==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
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
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails
Date:   Thu,  3 Mar 2022 01:58:26 +0000
Message-Id: <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org> <20220301094608.118879-3-ammarfaizi2@gnuweeb.org> <Yh+oyD/5M3TW5ZMM@yaz-ubuntu> <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org> <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Mar 2022 06:27:33 +0700, Ammar Faizi wrote:
> +static void _mce_threshold_remove_device(struct threshold_bank **bp)
> +{
> +	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
> +
> +	for (bank = 0; bank < numbanks; bank++) {
> +		if (bp[bank]) {
> +			threshold_remove_bank(bp[bank]);
> +			bp[bank] = NULL;
> +		}
> +	}
> +	kfree(bp);
> +}

hi sir, i think this can be improved again, we can avoid calling
this_cpu_read(mce_num_banks) twice if we pass the numbanks as an
argument, plz review the changes below

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

-- Viro
