Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626EB40A323
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 04:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhINCOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 22:14:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15408 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbhINCOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 22:14:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7mxW5LDqzR5fC;
        Tue, 14 Sep 2021 10:09:19 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 10:13:25 +0800
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 10:13:24 +0800
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in
 __nbd_ioctl()
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        <lkft-triage@lists.linaro.org>, <llvm@lists.linux.dev>,
        Kees Cook <keescook@chromium.org>
References: <20210913131113.390368911@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com>
 <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
 <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
 <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
 <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com>
 <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com>
 <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com>
 <CAKwvOdmtX8Y8eWESYj4W-H-KF7cZx6w1NbSjoSPt5x5U9ezQUQ@mail.gmail.com>
 <CAHk-=whjhJgk7hD-ftUy-8+9cenhMDHqaNKXOyeNVoMxZRD-_A@mail.gmail.com>
 <CAKwvOdnFRhKDZ3XuePSGsuxhOpuS5RmZ1u+MeN=PRPPKSS3wFg@mail.gmail.com>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <db321a38-f5f6-34cd-2f4f-37fc82201798@huawei.com>
Date:   Tue, 14 Sep 2021 10:13:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnFRhKDZ3XuePSGsuxhOpuS5RmZ1u+MeN=PRPPKSS3wFg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/9/14 7:23, Nick Desaulniers 写道:
> On Mon, Sep 13, 2021 at 4:00 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Sep 13, 2021 at 2:15 PM Nick Desaulniers
>> <ndesaulniers@google.com> wrote:
>>> Sorry wrong diff:
>> Well, this second diff was seriously whitespace-damaged and hard to
>> read, but while it seems to be the same number of lines, it sure looks
>> a lot more readable in this format.
>>
>> Except I think that
>>
>>                  default: dividend / divisor);
>>
>> should really have parentheses around both of those macro arguments.
>>
>> That's a preexisting problem, but it should be fixed while at it.
> Ok, I'll send a revised v2 based on _Generic; Rasmus can help review
> when he's awake.
>
>> I'm also not sure why that (again, preexisting) BUILD_BUG_ON_MSG()
>> only checks the size of the dividend, not the divisor. Very strange.
>> But probably not worth worrying about.
> I sent a not-yet-applied diff of my not-yet-applied diff.  I was
> playing with this last week, and IIRC we had divisors that were less
> than 32b being promoted to int. But I'll test it some more.

How about deleting the check_mul_overflow in the __nbd_ioctl as follows?

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5170a630778d..f404e0540476 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1393,7 +1393,6 @@ static int __nbd_ioctl(struct block_device *bdev, 
struct nbd_device *nbd,
                        unsigned int cmd, unsigned long arg)
  {
         struct nbd_config *config = nbd->config;
-       loff_t bytesize;

         switch (cmd) {
         case NBD_DISCONNECT:
@@ -1408,9 +1407,10 @@ static int __nbd_ioctl(struct block_device *bdev, 
struct nbd_device *nbd,
         case NBD_SET_SIZE:
                 return nbd_set_size(nbd, arg, config->blksize);
         case NBD_SET_SIZE_BLOCKS:
-               if (check_mul_overflow((loff_t)arg, config->blksize, 
&bytesize))
+               if (arg && (LLONG_MAX / arg <= config->blksize))
                         return -EINVAL;
-               return nbd_set_size(nbd, bytesize, config->blksize);
+               return nbd_set_size(nbd, arg * config->blksize,
+                                   config->blksize);
         case NBD_SET_TIMEOUT:
                 nbd_set_cmd_timeout(nbd, arg);
                 return 0;
--
2.31.1

-- 
With Best Regards,
Baokun Li



