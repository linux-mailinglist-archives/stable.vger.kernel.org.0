Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DEE583742
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 05:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiG1DDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 23:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiG1DDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 23:03:18 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6572D5A3FC;
        Wed, 27 Jul 2022 20:03:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=dtcccc@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VKdMdjt_1658977393;
Received: from 30.97.49.29(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0VKdMdjt_1658977393)
          by smtp.aliyun-inc.com;
          Thu, 28 Jul 2022 11:03:14 +0800
Message-ID: <d6740ddd-c154-0cba-9ab3-34b55822402a@linux.alibaba.com>
Date:   Thu, 28 Jul 2022 11:03:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 373/575] selftests: bpf: Convert sk_lookup ctx access
 tests to PROG_TEST_RUN
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org, lmb@cloudflare.com,
        sashal@kernel.org, stable@vger.kernel.org
References: <20211115165356.685521944@linuxfoundation.org>
 <6258c4a1-0132-5afe-8dab-afa4ca3c49d6@linux.alibaba.com>
 <YuEPI/8xAMPl5XDw@kroah.com>
From:   Tianchen Ding <dtcccc@linux.alibaba.com>
In-Reply-To: <YuEPI/8xAMPl5XDw@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/7/27 18:10, Greg KH wrote:
> On Mon, Jul 25, 2022 at 10:53:38AM +0800, Tianchen Ding wrote:
>> Hi Greg.
>>
>> We found a compile error when building tools/testing/selftests/bpf/ on 5.10.
>>
>> tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1092:15: error: 'struct bpf_sk_lookup' has no member named 'cookie'
>>   1092 |  if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))
>>
>> It requires 7c32e8f8bc33 ("bpf: Add PROG_TEST_RUN support for sk_lookup programs") from upstream.
>>
>> Maybe the left patches of this patchset are needed for 5.10 LTS?
>> https://lore.kernel.org/bpf/20210303101816.36774-1-lmb@cloudflare.com/
> 
> If so, please submit them with the git commit ids so that I can fix this
> up.
> 
> thanks,
> 
> greg k-h

These 2 commits from upstream are necessary for bpf selftests build pass on 5.10.y:
607b9cc92bd7208338d714a22b8082fe83bcb177 bpf: Consolidate shared test timing code
7c32e8f8bc33a5f4b113a630857e46634e3e143b bpf: Add PROG_TEST_RUN support for sk_lookup programs

This commit does not impact building stage, but can avoid a test case failure (by skipping it):
b4f894633fa14d7d46ba7676f950b90a401504bb selftests: bpf: Don't run sk_lookup in verifier tests

Thanks.
