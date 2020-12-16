Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F66F2DBC57
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 08:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgLPHtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 02:49:49 -0500
Received: from mail.loongson.cn ([114.242.206.163]:60884 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbgLPHtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 02:49:49 -0500
Received: from [10.130.0.97] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxNuDiu9lfUSsBAA--.3341S3;
        Wed, 16 Dec 2020 15:48:51 +0800 (CST)
Subject: Re: [PATCH v2] selftests/vm: Fix building protection keys test
To:     Harish <harish@linux.ibm.com>, shuah@kernel.org,
        akpm@linux-foundation.org, sandipan@linux.ibm.com,
        jhubbard@nvidia.com, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, bgeffon@google.com,
        almasrymina@google.com
References: <20201215100402.257376-1-harish@linux.ibm.com>
Cc:     linux-kselftest@vger.kernel.org, stable@vger.kernel.org
From:   suxingxing <suxingxing@loongson.cn>
Message-ID: <3794f496-57a7-5bbf-b5e1-a1b60a8feecf@loongson.cn>
Date:   Wed, 16 Dec 2020 15:48:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20201215100402.257376-1-harish@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9AxNuDiu9lfUSsBAA--.3341S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr15Xw17JrW7AFWxWF43GFg_yoW3WFgEyF
        Z2ywnruw45Zws7AFsxGr45AFWkG3y7uw1Uuryv9w43Xw1Yy39xWFykWryrZa12qryrtFZ5
        ZFWrur4ayrn2kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb-AYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
        c7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jYq2NUUUUU=
X-CM-SenderInfo: pvx0x0xj0l0wo6or00hjvr0hdfq/1tbiAQAMC13QvMwSZAABsM
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/2020 06:04 PM, Harish wrote:

> The patch d8cbe8bfa7d tries to include a ARCH check for powerpc,
> however ARCH is not defined in the Makefile before including
> lib.mk. This makes test building to skip on both x86 and powerpc.
> Fix the arch check by replacing it using machine type as it is
> already defined and used in the test.
>
> Fixes: d8cbe8bfa7d ("tools/testing/selftests/vm: fix build error")
> Signed-off-by: Harish <harish@linux.ibm.com>
> ---
>
>   
> -ifneq (,$(findstring $(ARCH),powerpc))
> +ifneq (,$(findstring $(MACHINE),ppc64))
>   TEST_GEN_FILES += protection_keys
>   endif

Reviewed-by: Xingxing Su <suxingxing@loongson.cn>

The findstring isn't really canonical, it's my fault,
you can replace findstring with filter like V1.

