Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17A2C1C22
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 09:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfI3HgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 03:36:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3233 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbfI3HgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 03:36:25 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EC41A3B0846FBE479BC4;
        Mon, 30 Sep 2019 15:36:22 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.202) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 30 Sep
 2019 15:36:17 +0800
Subject: Re: [PATCH 4.19 53/63] f2fs: fix to do sanity check on segment bitmap
 of LFS curseg
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135040.450358370@linuxfoundation.org>
 <20190930072157.GB22914@atrey.karlin.mff.cuni.cz>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <43edc2f2-5b42-0cd7-1573-af77fd9e6678@huawei.com>
Date:   Mon, 30 Sep 2019 15:36:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190930072157.GB22914@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On 2019/9/30 15:21, Pavel Machek wrote:
> Hi!
> 
> 
>> +		for (blkofs += 1; blkofs < sbi->blocks_per_seg; blkofs++) {
>> +			if (!f2fs_test_bit(blkofs, se->cur_valid_map))
>> +				continue;
>> +out:
>> +			f2fs_msg(sbi->sb, KERN_ERR,
>> +				"Current segment's next free block offset is "
>> +				"inconsistent with bitmap, logtype:%u, "
>> +				"segno:%u, type:%u, next_blkoff:%u, blkofs:%u",
>> +				i, curseg->segno, curseg->alloc_type,
>> +				curseg->next_blkoff, blkofs);
>> +			return -EINVAL;
>> +		}
> 
> So this is detecting filesystem corruption, right? Should it be
> -EUCLEAN?

Was fixed in another commit 10f966bbf521 ("f2fs: use generic
EFSBADCRC/EFSCORRUPTED"). :)

Thanks,

> 
> 									Pavel
> 
