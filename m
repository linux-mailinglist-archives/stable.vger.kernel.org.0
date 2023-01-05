Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC90865E2B9
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 02:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjAEBzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 20:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjAEBzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 20:55:18 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBD5431BF;
        Wed,  4 Jan 2023 17:55:17 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NnTw26FcJzJq1V;
        Thu,  5 Jan 2023 09:51:14 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 5 Jan 2023 09:55:15 +0800
Message-ID: <9422ac46-1535-5a80-dc8e-4111c3a0c207@huawei.com>
Date:   Thu, 5 Jan 2023 09:55:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v4 0/3] ima: Fix IMA mishandling of LSM based rule during
Content-Language: en-US
From:   "Guozihua (Scott)" <guozihua@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <zohar@linux.ibm.com>
CC:     <paul@paul-moore.com>, <linux-integrity@vger.kernel.org>,
        <luhuaxin1@huawei.com>
References: <20230104075217.32746-1-guozihua@huawei.com>
In-Reply-To: <20230104075217.32746-1-guozihua@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/1/4 15:52, GUO Zihua wrote:
> Backports the following three patches to fix the issue of IMA mishandling
> LSM based rule during LSM policy update, causing a file to match an
> unexpected rule.
> 
> v4:
>   Make use of the exisiting ima_free_rule() instead of backported
> ima_lsm_free_rule(). Which resolves additional memory leak issues.
Using ima_free_rule() might cause an UAF on rule->fsname. Maybe using v3
would be better.
> 
> v3:
>   Backport "LSM: switch to blocking policy update notifiers" as well, as
> the prerequsite of "ima: use the lsm policy update notifier".
> 
> v2:
>   Re-adjust the bacported logic.
> 
> GUO Zihua (1):
>   ima: Handle -ESTALE returned by ima_filter_rule_match()
> 
> Janne Karhunen (2):
>   LSM: switch to blocking policy update notifiers
>   ima: use the lsm policy update notifier
> 
>  drivers/infiniband/core/device.c    |   4 +-
>  include/linux/security.h            |  12 +--
>  security/integrity/ima/ima.h        |   2 +
>  security/integrity/ima/ima_main.c   |   8 ++
>  security/integrity/ima/ima_policy.c | 136 ++++++++++++++++++++++------
>  security/security.c                 |  23 +++--
>  security/selinux/hooks.c            |   2 +-
>  security/selinux/selinuxfs.c        |   2 +-
>  8 files changed, 143 insertions(+), 46 deletions(-)
> 

-- 
Best
GUO Zihua

