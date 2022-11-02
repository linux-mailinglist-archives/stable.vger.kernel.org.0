Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AEC61623F
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 12:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiKBLyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiKBLxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 07:53:53 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5181D0CB;
        Wed,  2 Nov 2022 04:53:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VTo2zKq_1667390025;
Received: from 30.39.85.212(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VTo2zKq_1667390025)
          by smtp.aliyun-inc.com;
          Wed, 02 Nov 2022 19:53:47 +0800
Message-ID: <6eb3c5f4-2198-d501-7320-ea6209a63465@linux.alibaba.com>
Date:   Wed, 2 Nov 2022 19:53:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH] ACPI: APEI: set memory failure flags as
 MF_ACTION_REQUIRED on action required events
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "lenb@kernel.org" <lenb@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
References: <20221027042445.60108-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0hdgxsDiXqOmeqBQoZUQJ1RssM=3jpYpWt3qzy0n2eyaA@mail.gmail.com>
 <SJ1PR11MB60839264AEF656759C8C56D1FC329@SJ1PR11MB6083.namprd11.prod.outlook.com>
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB60839264AEF656759C8C56D1FC329@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/10/29 AM1:25, Luck, Tony 写道:
>>> cper_sec_mem_err::error_type identifies the type of error that occurred
>>> if CPER_MEM_VALID_ERROR_TYPE is set. So, set memory failure flags as 0
>>> for Scrub Uncorrected Error (type 14). Otherwise, set memory failure
>>> flags as MF_ACTION_REQUIRED.
> 
> On x86 the "action required" cases are signaled by a synchronous machine check
> that is delivered before the instruction that is attempting to consume the uncorrected
> data retires. I.e., it is guaranteed that the uncorrected error has not been propagated
> because it is not visible in any architectural state.

On arm, if a 2-bit (uncorrectable) error is detected, and the memory access has been
architecturally executed, that error is considered “consumed”. The CPU will take a
synchronous error exception, signaled as synchronous external abort (SEA), which is
analogously to MCE.

> 
> APEI signaled errors don't fall into that category on x86 ... the uncorrected data
> could have been consumed and propagated long before the signaling used for
> APEI can alert the OS.
> 
> Does ARM deliver APEI signals synchronously?
> 
> If not, then this patch might deliver a false sense of security to applications
> about the state of uncorrected data in the system.
> 

Well, it does not always. There are many APEI notification, such as SCI, GSIV, GPIO,
SDEI, SEA, etc. Not all APEI notifications are synchronously and it depends on
hardware signal. As far as I know, if a UE is detected and consumed, synchronous external
abort is signaled to firmware and firmware then performs a first-level triage and
synchronously notify OS by SDEI or SEA notification. On the other hand, if CE is
detected, a asynchronous interrupt will be signaled and firmware could notify OS
by GPIO or GSIV.

Best Regards,
Shuai


