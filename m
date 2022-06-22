Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A26554D9E
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 16:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357741AbiFVOjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 10:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbiFVOju (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 10:39:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC21A3CA7E;
        Wed, 22 Jun 2022 07:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=xrVLqZn3smz3cdHLMKk4h0o97FWoPeGavxghDvwr0II=; b=s6RFhew3VtvjzQz32SK5REER+0
        vu+BbHAtsQsWEu64uE6xrhf2UYXKmdxfdfYy4l+zwYaJOnlJi+VIbpYVnmciKWx+As95BF0j31QE3
        /IIONo1DhSc/9wh+E8GeqVGAwZ8XJVNqiO1+Q68VGwUYi4dt3rpXWnmkkMJyJ41b8rneXngWkBWn8
        7s26RpfnX0a9L2Bgrm9Ve3zcKRvoEFIeYaNGQzRsNAbYXX9+7jFGlhfAs1Ffx6+Z83TXqqZqMhN7s
        6wJ83aObhn9rwZeX/cNqVG/oHjWMCZDlqldMH2Pq6JNN9sDvoN3Yof6FCn49ktLVBYeKF8YM/N9y8
        XgCDWlRA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o41WD-0074Y2-RJ; Wed, 22 Jun 2022 14:39:46 +0000
Message-ID: <68507426-54bb-3902-a8b6-e11d25327d65@infradead.org>
Date:   Wed, 22 Jun 2022 07:39:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4.9 13/20] x86/speculation/mmio: Add mitigation for
 Processor MMIO Stale Data
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20220614183722.061550591@linuxfoundation.org>
 <20220614183725.181834522@linuxfoundation.org>
 <20220622114844.GA6854@duo.ucw.cz>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220622114844.GA6854@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/22/22 04:48, Pavel Machek wrote:
> Hi!
> 
> 
>> +static int __init mmio_stale_data_parse_cmdline(char *str)
>> +{
>> +	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
>> +		return 0;
>> +
>> +	if (!str)
>> +		return -EINVAL;
>> +
>> +	if (!strcmp(str, "off")) {
>> +		mmio_mitigation = MMIO_MITIGATION_OFF;
>> +	} else if (!strcmp(str, "full")) {
>> +		mmio_mitigation = MMIO_MITIGATION_VERW;
>> +	} else if (!strcmp(str, "full,nosmt")) {
>> +		mmio_mitigation = MMIO_MITIGATION_VERW;
>> +		mmio_nosmt = true;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> This is wrong, AFAICT. Returning 0 will pollute init's environment;
> Randy was cleaning those lately and we are even seeing them in
> -stable. See for example b793a01000122d2bd133ba451a76cc135b5e162c.
> 
> The early return 0 should disappear, too; we should validate the
> option even on non-buggy machines.

It's good to be on the lookout for such problems, but __setup()
functions (like I was cleaning) are the opposite (sad:(  of
early_param() functions, which this one is.

early_param() does return 0 on success and non-zero
on error, so this looks OK to me.

-- 
~Randy
