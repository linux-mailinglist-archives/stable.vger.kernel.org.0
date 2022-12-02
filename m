Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D63640361
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 10:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiLBJdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 04:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiLBJcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 04:32:35 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA93112A;
        Fri,  2 Dec 2022 01:32:33 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p12PH-0003qq-OA; Fri, 02 Dec 2022 10:32:31 +0100
Message-ID: <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
Date:   Fri, 2 Dec 2022 10:32:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Content-Language: en-US, de-DE
To:     Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de
Cc:     stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20221128195651.322822-1-Jason@zx2c4.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20221128195651.322822-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1669973553;529cc8e0;
X-HE-SMSGID: 1p12PH-0003qq-OA
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 28.11.22 20:56, Jason A. Donenfeld wrote:

BTW, many thx for taking care of this Jason!

> From: Jan Dabros <jsd@semihalf.com>
> 
> Currently tpm transactions are executed unconditionally in
> tpm_pm_suspend() function, which may lead to races with other tpm
> accessors in the system. Specifically, the hw_random tpm driver makes
> use of tpm_get_random(), and this function is called in a loop from a
> kthread, which means it's not frozen alongside userspace, and so can
> race with the work done during system suspend:

Peter, Jarkko, did you look at this patch or even applied it already to
send it to Linus soon? Doesn't look like it from here, but maybe I
missed something.

Thing is: the linked regression afaics is overdue fixing (for details
see "Prioritize work on fixing regressions" in
https://www.kernel.org/doc/html/latest/process/handling-regressions.html
). Hence if this doesn't make any progress I'll likely have to point
Linus to this patch and suggest to apply it directly if it looks okay
from his perspective.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

> [    3.277834] tpm tpm0: tpm_transmit: tpm_recv: error -52
> [    3.278437] tpm tpm0: invalid TPM_STS.x 0xff, dumping stack for forensics
> [    3.278445] CPU: 0 PID: 1 Comm: init Not tainted 6.1.0-rc5+ #135
> [    3.278450] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
> [    3.278453] Call Trace:
> [    3.278458]  <TASK>
> [    3.278460]  dump_stack_lvl+0x34/0x44
> [    3.278471]  tpm_tis_status.cold+0x19/0x20
> [    3.278479]  tpm_transmit+0x13b/0x390
> [    3.278489]  tpm_transmit_cmd+0x20/0x80
> [    3.278496]  tpm1_pm_suspend+0xa6/0x110
> [    3.278503]  tpm_pm_suspend+0x53/0x80
> [    3.278510]  __pnp_bus_suspend+0x35/0xe0
> [    3.278515]  ? pnp_bus_freeze+0x10/0x10
> [    3.278519]  __device_suspend+0x10f/0x350
> 
> Fix this by calling tpm_try_get_ops(), which itself is a wrapper around
> tpm_chip_start(), but takes the appropriate mutex.
> 
> Signed-off-by: Jan Dabros <jsd@semihalf.com>
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Tested-by: Vlastimil Babka <vbabka@suse.cz>
> Link: https://lore.kernel.org/all/c5ba47ef-393f-1fba-30bd-1230d1b4b592@suse.cz/
> Cc: stable@vger.kernel.org
> Fixes: e891db1a18bf ("tpm: turn on TPM on suspend for TPM 1.x")
> [Jason: reworked commit message, added metadata]
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/tpm/tpm-interface.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 1621ce818705..d69905233aff 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -401,13 +401,14 @@ int tpm_pm_suspend(struct device *dev)
>  	    !pm_suspend_via_firmware())
>  		goto suspended;
>  
> -	if (!tpm_chip_start(chip)) {
> +	rc = tpm_try_get_ops(chip);
> +	if (!rc) {
>  		if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  			tpm2_shutdown(chip, TPM2_SU_STATE);
>  		else
>  			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
>  
> -		tpm_chip_stop(chip);
> +		tpm_put_ops(chip);
>  	}
>  
>  suspended:
