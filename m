Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099895EFFFB
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiI2WSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 18:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiI2WSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 18:18:01 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB03D149D1B
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 15:17:58 -0700 (PDT)
Received: from fsav119.sakura.ne.jp (fsav119.sakura.ne.jp [27.133.134.246])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28TMGQK1040782;
        Fri, 30 Sep 2022 07:16:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav119.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp);
 Fri, 30 Sep 2022 07:16:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28TMGPbe040774
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 30 Sep 2022 07:16:25 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <b4979f46-89e4-e0bd-e0f5-0754169ad4bb@I-love.SAKURA.ne.jp>
Date:   Fri, 30 Sep 2022 07:16:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Johannes Berg <johannes.berg@intel.com>,
        Hillf Danton <hdanton@sina.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <20220926100806.522017616@linuxfoundation.org>
 <CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com>
 <YzKyIfQUq9eRbomG@kroah.com>
 <CA+G9fYu1L_qwCQ9x0FukJ=0J5sg5z0ttejT9BT_bPAgCEtmAnQ@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CA+G9fYu1L_qwCQ9x0FukJ=0J5sg5z0ttejT9BT_bPAgCEtmAnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/09/30 0:43, Naresh Kamboju wrote:
> Anders bisected this reported problem [1] and found this commit caused
> deadlock on all arm64 devices.
> 
>> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>     workqueue: don't skip lockdep work dependency in cancel_work_sync()

My patch itself is correct; just started reporting possibility of deadlock.
You will see several reports like this, but that is an expected result.

> 
> 
> [1] https://lore.kernel.org/stable/CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com/

The line which causes this report will be removed by commit bb87672562f871ed
("Bluetooth: Remove update_scan hci_request dependancy").

