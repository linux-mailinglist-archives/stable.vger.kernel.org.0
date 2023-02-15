Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45FF697A4B
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 11:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjBOK6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 05:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjBOK6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 05:58:18 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E048E46A8;
        Wed, 15 Feb 2023 02:58:16 -0800 (PST)
Received: from kwepemm600011.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PGw3J6p47zRrxc;
        Wed, 15 Feb 2023 18:55:40 +0800 (CST)
Received: from [10.67.111.59] (10.67.111.59) by kwepemm600011.china.huawei.com
 (7.193.23.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 15 Feb
 2023 18:58:14 +0800
Message-ID: <e1daca8f-46d5-d5b0-8152-23b172d5e63a@huawei.com>
Date:   Wed, 15 Feb 2023 18:58:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   heyuqiang <heyuqiang1@huawei.com>
Subject: Re: [PATCH 5.10 88/91] arm64/kexec: Test page size support with new
 TGRAN range values
Reply-To: <20221102022057.553634951@linuxfoundation.org>
To:     <gregkh@linuxfoundation.org>, <anshuman.khandual@arm.com>,
        <catalin.marinas@arm.com>, <james.morse@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
        <stable@vger.kernel.org>, <will@kernel.org>, <yuzenghui@huawei.com>
CC:     <nixiaoming@huawei.com>, <lijiahuan5@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.59]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600011.china.huawei.com (7.193.23.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is an error

tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git 
master
head: c911f03f8d444e623724fddd82b07a7e1af42338
commit: d5924531dd8ad012ad13eb4d6a5e120c3dadfc05 arm64/kexec: Test page 
size support with new TGRAN range values
# 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5924531dd8ad012ad13eb4d6a5e120c3dadfc05

When I compile the ko file, I add [-Werror=type-limits] compilation 
options, an error is reported during compilation.

The log is as follows:

./arch/arm64/include/asm/cpufeature.h: In function 
‘system_supports_4kb_granule’:
./arch/arm64/include/asm/cpufeature.h:653:14: error:
comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
return (val >= ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN) &&
^~
./arch/arm64/include/asm/cpufeature.h: In function 
‘system_supports_64kb_granule’:
./arch/arm64/include/asm/cpufeature.h:666:14: error:
comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
return (val >= ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN) &&
^~

"val" variable type is "u32"
"#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN 0x0"
"#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN 0x0"
comparison of val >= 0 is always true.

If you fix the issue, kindly add following tag where applicable
Reported-by: heyuqiang <heyuqiang1@huawei.com>

Thanks

