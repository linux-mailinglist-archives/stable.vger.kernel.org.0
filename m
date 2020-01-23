Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25251460AF
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 03:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAWCZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 21:25:02 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47698 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbgAWCZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 21:25:01 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 35ADC651C4DD263FBCD7;
        Thu, 23 Jan 2020 10:24:58 +0800 (CST)
Received: from [127.0.0.1] (10.133.219.224) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 23 Jan 2020
 10:24:55 +0800
Subject: Re: [PATCH] jffs2: Fix integer underflow in jffs2_rtime_compress
To:     Richard Weinberger <richard@nod.at>
CC:     <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20181215162350.12489-1-richard@nod.at>
 <cae86ca1-91f9-6728-df64-40580145220d@huawei.com>
 <2142335.HPRDAJu19m@blindfold>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <e727e81a-c633-60be-9b93-5b6dc9d1936a@huawei.com>
Date:   Thu, 23 Jan 2020 10:24:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <2142335.HPRDAJu19m@blindfold>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.224]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Richard,

On 2018/12/20 18:45, Richard Weinberger wrote:
> Am Donnerstag, 20. Dezember 2018, 11:43:08 CET schrieb Hou Tao:
>>
>> On 2018/12/16 0:23, Richard Weinberger wrote:
>>> The rtime compressor assumes that at least two bytes are
>>> compressed.
>>> If we try to compress just one byte, the loop condition will
>>> wrap around and an out-of-bounds write happens.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>  fs/jffs2/compr_rtime.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>> It seems that it doesn't incur any harm because the minimal allocated
>> size will be 8-bytes and jffs2_rtime_compress() will write 2-bytes into
>> the allocated buffer.
> 
> Are you sure about that? I saw odd kernel behavior and KASAN complained too.
> 

Sorry for the later reply.

Yes. KASAN complains but it doesn't incur any harm because the minimal allocated
size returned by kmalloc() will be 8-bytes.

But we better fix it, because it's bad to depend on the implementation of kmalloc().

It seems that mtd-utils has already fixed it years ago. Maybe we can use it directly ?

And your fix also looks good to me, so

Reviewed-by: Hou Tao <houtao1@huawei.com>

commit e8457f16306ad6e2c8708275bf42b5dfff40fffd
Author: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Date:   Thu Jun 24 15:02:40 2010 +0200

    mkfs.jffs2: fix integer underflow in jffs2_rtime_compress()

    When '*dstlen' is 0 or 1, comparison will return wrong result.  Reported
    by valgrind as

    ==5919== Invalid write of size 1
    ==5919==    at 0x40564E: jffs2_rtime_compress (compr_rtime.c:51)
    ==5919==    by 0x40676B: jffs2_compress (compr.c:246)
    ==5919==    by 0x403EE4: recursive_populate_directory (mkfs.jffs2.c:884)
    ==5919==  Address 0x4e1bdb1 is 0 bytes after a block of size 1 alloc'd
    ==5919==    at 0x4A0515D: malloc (vg_replace_malloc.c:195)
    ==5919==    by 0x40671C: jffs2_compress (compr.c:229)
    ==5919==    by 0x403EE4: recursive_populate_directory (mkfs.jffs2.c:884)

    Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/compr_rtime.c b/compr_rtime.c
index 131536c..5613963 100644
--- a/compr_rtime.c
+++ b/compr_rtime.c
@@ -32,7 +32,7 @@ static int jffs2_rtime_compress(unsigned char *data_in, unsigned char *cpage_out

        memset(positions,0,sizeof(positions));

-       while (pos < (*sourcelen) && outpos <= (*dstlen)-2) {
+       while (pos < (*sourcelen) && outpos+2 <= (*dstlen)) {
                int backpos, runlen=0;
                unsigned char value;



> Thanks,
> //richard




> 
> 
> 
> .
> 

