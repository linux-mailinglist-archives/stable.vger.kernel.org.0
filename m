Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B8404015
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 22:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349865AbhIHUNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 16:13:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54378 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350785AbhIHUNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 16:13:06 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631131916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GeLJugmfwpo7jAlKKwyWt4ebo/kC1oROCE15+sKTgB0=;
        b=CL3+dpMT7kp6Odt14ryNcdM1/1524of/KqcM+/HlIdit0qXpFq8ZpZRa0k72QYK8K7S2Wa
        r/uqhQfN7H0bTsC08OLFy/qnwtoPBpdCX18+7R9XA74R9Y5Hs91TJHNwUcZig/RcniMgL5
        4T35c9RgvaNd0Dr8cQTIzlkAABYWZS5T2OQtn7XV9Ug3M/fTsexD1Qx5knA3rIPThUe5X6
        3GWSkxSnfCqFYuSv57+S1NgBp4rV7CH51hEol9LLwByh0MsKCJuHKADEzjg8fVEfVMU2fp
        M30b1C1wley3EBDEQXEK59ggEk/O8Wwwo1RIEftNabl/9A4zZnHmA/7LE3Je6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631131916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GeLJugmfwpo7jAlKKwyWt4ebo/kC1oROCE15+sKTgB0=;
        b=l7ieBzc7FjvI1f1Cmv8scw7WGxJNANq0JO3TYdREbLpVa6i85WWdL6kEDAipYWM7Mf0b/O
        5wwuOL25SOPiydBA==
To:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>
Cc:     Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [tip: timers/urgent] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <a4bbf640306c42429afda8a4fc396f98@AcuMS.aculab.com>
References: <AM6PR01MB541637BD6F336B8FFB72AF80EEC69@AM6PR01MB5416.eurprd01.prod.exchangelabs.com>
 <163111620295.25758.18154572095175068828.tip-bot2@tip-bot2>
 <a4bbf640306c42429afda8a4fc396f98@AcuMS.aculab.com>
Date:   Wed, 08 Sep 2021 22:11:55 +0200
Message-ID: <87zgsmesj8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David,

On Wed, Sep 08 2021 at 16:01, David Laight wrote:
>> +	if (ts->tv_sec <= KTIME_SEC_MIN)
>> +		return KTIME_MIN;
>> +
>>  	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
>>  }
>
> Adding tv_nsec can still overflow -  even if tv_nsec is bounded to +/- 1 second.
> This is no more 'garbage in' => 'garbage out' than the code without the
> multiply under/overflow check.

In kernel timespecs are always normalized:  0 < tv_nsec < 1e9 - 1

Let's do the math:

  KTIME_SEC_MAX = KTIME_MAX / NSEC_PER_SEC

  The overflow prevention does:

    if PSVAL >= KTIME_SEC_MAX:
       return KTIME_MAX

  so the largest positive seconds value which passes the above is:

    PSMAX = KTIME_SEC_MAX - 1

  ergo:

    PSMAX * NSEC_PER_SEC + (NSEC_PER_SEC - 1) < KTIME_SEC_MAX < KTIME_MAX

I leave the proof for negative values as an excercise for the reader.

Thanks,

        tglx
---
"Math is hard, let's go shopping!" - John Stultz
