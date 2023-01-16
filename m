Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B0766C080
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjAPOAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjAPOA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:00:26 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA71D21A16;
        Mon, 16 Jan 2023 06:00:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A16613765F;
        Mon, 16 Jan 2023 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673877603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z97s89bx2ilPOW9UqwgUScH5OfS1ybbn2p0m+3QWpCU=;
        b=XWq7RGyfYnE0B+M0Wv2lkFIM7N6yXS4lZd16Jlcv464CBESPPCxOOSjg45mv82oukVoFsH
        JvMSPIU1U3d3aOZtKuRode0Tmq0sb5l3lykGk8z0ISEzZ1mjAemF5avshQJ2zutG4C6PF/
        gZ5BxmN7+hN9mZrqhmFtf/rp0ZzMcGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673877603;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z97s89bx2ilPOW9UqwgUScH5OfS1ybbn2p0m+3QWpCU=;
        b=Rc2krZfWcSlw2BqRt9aOe+ckPIlATBAlcERNETTAUfGGDhzHhcO2QinpDpuG7UVmprkb2f
        lnJZWtKtjULKegCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 72B14138FE;
        Mon, 16 Jan 2023 14:00:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gx9PG2NYxWNFUgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 16 Jan 2023 14:00:03 +0000
Message-ID: <af2e5a17-514b-8759-2464-7ebb384a17ba@suse.cz>
Date:   Mon, 16 Jan 2023 15:00:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM suspend
 fails
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <Y7dPV5BK6jk1KvX+@zx2c4.com>
 <20230106030156.3258307-1-Jason@zx2c4.com> <Y8U4kwTPpMet13Ks@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y8U4kwTPpMet13Ks@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 12:44, Jarkko Sakkinen wrote:
> On Fri, Jan 06, 2023 at 04:01:56AM +0100, Jason A. Donenfeld wrote:
>> TPM 1 is sometimes broken across system suspends, due to races or
>> locking issues or something else that haven't been diagnosed or fixed
>> yet, most likely having to do with concurrent reads from the TPM's
>> hardware random number generator driver. These issues prevent the system
>> from actually suspending, with errors like:
>> 
>>   tpm tpm0: A TPM error (28) occurred continue selftest
>>   ...
> 
> <REMOVE>
> 
>>   tpm tpm0: A TPM error (28) occurred attempting get random
>>   ...
>>   tpm tpm0: Error (28) sending savestate before suspend
>>   tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
>>   tpm_tis 00:08: PM: dpm_run_callback(): pnp_bus_suspend+0x0/0x10 returns 28
>>   tpm_tis 00:08: PM: failed to suspend: error 28
>>   PM: Some devices failed to suspend, or early wake event detected
> 
> </REMOVE>
> 
> Unrelated to thix particular fix.

Not sure I understand.
AFAIK this is not a proper fix, but a workaround for when laptop suspend no
longer works because TPM fails to suspend. The error messages quoted above
are very much related to the problem of suspend not working, and this patch
did work as advertised at least for me. I see errors but they don't prevent
suspend anymore:

https://lore.kernel.org/all/58d7a42c-9e6b-ab2a-617f-d5e373bf63cb@suse.cz/

>> This issue was partially fixed by 23393c646142 ("char: tpm: Protect
>> tpm_pm_suspend with locks"), in a last minute 6.1 commit that Linus took
>> directly because the TPM maintainers weren't available. However, it
>> seems like this just addresses the most common cases of the bug, rather
>> than addressing it entirely. So there are more things to fix still,
>> apparently.
>> 
>> In lieu of actually fixing the underlying bug, just allow system suspend
>> to continue, so that laptops still go to sleep fine. Later, this can be
>> reverted when the real bug is fixed.
>> 
>> Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
>> Cc: stable@vger.kernel.org # 6.1+
>> Reported-by: Vlastimil Babka <vbabka@suse.cz>
>> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> ---
>> This is basically untested and I haven't worked out if there are any
>> awful implications of letting the system sleep when TPM suspend fails.
>> Maybe some PCRs get cleared and that will make everything explode on
>> resume? Maybe it doesn't matter? Somebody well versed in TPMology should
>> probably [n]ack this approach.
>> 
>>  drivers/char/tpm/tpm-interface.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index d69905233aff..6df9067ef7f9 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -412,7 +412,10 @@ int tpm_pm_suspend(struct device *dev)
>>  	}
>>  
>>  suspended:
>> -	return rc;
>> +	if (rc)
>> +		pr_err("Unable to suspend tpm-%d (error %d), but continuing system suspend\n",
>> +		       chip->dev_num, rc);
>> +	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(tpm_pm_suspend);
>>  
>> -- 
>> 2.39.0
>> 
> 
> This tpm_tis local issue, nothing to do with tpm_pm_suspend(). Executing
> the selftest as part of wake up, is TPM 1.2 dTPM specific requirement, and
> the call is located in tpm_tis_resume() [*].
> 
> [*] https://lore.kernel.org/lkml/Y8U1QxA4GYvPWDky@kernel.org/

Yes the changelog at the top does say "due to races or locking issues or
something else that haven't been diagnosed or fixed yet"

I don't know what causes the TPM to start returning error 28 on resume and
never recover from it. But it didn't happen before hwrng started using the
TPM. Before that, it was probably just the selftest ever doing anything with
the TPM, and on its own I don't recall it ever (before 6.1) failing and
preventing further suspend/resume.

> BR, Jarkko

