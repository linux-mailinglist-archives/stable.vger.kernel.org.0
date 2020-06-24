Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36042069A3
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 03:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbgFXBnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 21:43:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6312 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387780AbgFXBnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 21:43:00 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8AD91B060A5B3297B7E7;
        Wed, 24 Jun 2020 09:42:57 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 24 Jun
 2020 09:42:47 +0800
Subject: Re: [PATCH v2] erofs: fix partially uninitialized misuse in
 z_erofs_onlinepage_fixup
To:     Gao Xiang <hsiangkao@aol.com>, <linux-erofs@lists.ozlabs.org>
CC:     Chao Yu <chao@kernel.org>, Li Guifu <bluce.liguifu@huawei.com>,
        Fang Wei <fangwei1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Hongyu Jin <hongyu.jin@unisoc.com>, <stable@vger.kernel.org>
References: <20200618111936.19845-1-hsiangkao@aol.com>
 <20200618234349.22553-1-hsiangkao@aol.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <d9d2570a-ce51-79a7-6cc4-bd5e6f15cb4a@huawei.com>
Date:   Wed, 24 Jun 2020 09:42:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200618234349.22553-1-hsiangkao@aol.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/6/19 7:43, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Hongyu reported "id != index" in z_erofs_onlinepage_fixup() with
> specific aarch64 environment easily, which wasn't shown before.
> 
> After digging into that, I found that high 32 bits of page->private
> was set to 0xaaaaaaaa rather than 0 (due to z_erofs_onlinepage_init
> behavior with specific compiler options). Actually we only use low
> 32 bits to keep the page information since page->private is only 4
> bytes on most 32-bit platforms. However z_erofs_onlinepage_fixup()
> uses the upper 32 bits by mistake.
> 
> Let's fix it now.
> 
> Reported-by: Hongyu Jin <hongyu.jin@unisoc.com>
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
