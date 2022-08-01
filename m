Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB375862DB
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 04:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbiHAC4f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 31 Jul 2022 22:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiHAC4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 22:56:34 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE97DE89
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 19:56:32 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Lx2kM4ZW5z1M8Tw;
        Mon,  1 Aug 2022 10:53:31 +0800 (CST)
Received: from dggpeml100022.china.huawei.com (7.185.36.176) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 1 Aug 2022 10:56:30 +0800
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpeml100022.china.huawei.com (7.185.36.176) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 1 Aug 2022 10:56:30 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Mon, 1 Aug 2022 10:56:30 +0800
From:   "chenjun (AM)" <chenjun102@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "xuqiang (M)" <xuqiang36@huawei.com>,
        Xiujianfeng <xiujianfeng@huawei.com>
Subject: Re: [PATCH stable 4.19 4.14 0/2] add fix patch for CVE-2021-3365
Thread-Topic: [PATCH stable 4.19 4.14 0/2] add fix patch for CVE-2021-3365
Thread-Index: AQHYpNouY5MPc/WW0kGqOZnsUDVyHA==
Date:   Mon, 1 Aug 2022 02:56:30 +0000
Message-ID: <263b30ce605b4dbbb3d7018188511f50@huawei.com>
References: <20220729031140.21806-1-chenjun102@huawei.com>
 <YuZ3WAOVRqmcyvHQ@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.43]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/7/31 20:37, Greg KH 写道:
> On Fri, Jul 29, 2022 at 03:11:38AM +0000, Chen Jun wrote:
>> refer to https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
>> 3 patches are provided to fix CVE-2021-3365 (When sending malicous data
>> to kernel by ioctl cmd FBIOPUT_VSCREENINFO,kernel will write memory out
>> of bounds. https://nvd.nist.gov/vuln/detail/CVE-2021-33655) in mainline.
>>
>> But only
>> commit 65a01e601dbb ("fbcon: Disallow setting font bigger than screen size")
>> was backported to stable (4.19,4.14).
>>
>> without other two commit
>> commit e64242caef18 ("fbcon: Prevent that screen size is smaller than font size")
>> commit 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
>> The problem still exists.
>>
>> static long do_fb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
>> 	fb_set_var(info, &var);
>> 		fb_notifier_call_chain(evnt, &event); // evnt = FB_EVENT_MODE_CHANGE
>>
>> static int fbcon_event_notify(struct notifier_block *self,
>> 			      unsigned long action, void *data)
>> 	fbcon_modechanged(info);
>> 		updatescrollmode(p, info, vc);
>> 			...
>> 			p->vrows = vyres/fh;
>> 			if (yres > (fh * (vc->vc_rows + 1)))
>> 				p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
>> 			if ((yres % fh) && (vyres % fh < yres % fh))
>> 				p->vrows--;	[1]
>> [1]: p->vrows could be -1, like what CVE-2021-3365 described.
>>
>> I think, the two commits should be backported to 4.19 and 4.14.
>>
>> Helge Deller (2):
>>    fbcon: Prevent that screen size is smaller than font size
>>    fbmem: Check virtual screen sizes in fb_set_var()
>>
>>   drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
>>   drivers/video/fbdev/core/fbmem.c | 20 +++++++++++++++++---
>>   include/linux/fbcon.h            |  4 ++++
>>   3 files changed, 49 insertions(+), 3 deletions(-)
>>
>> -- 
>> 2.17.1
>>
> 
> This breaks the build on 4.14.y, did you test it there?
> 
> The error is:
> 	ERROR: "is_console_locked" [drivers/video/fbdev/core/fb.ko] undefined!
> 

if CONFIG_FRAMEBUFFER_CONSOLE = M,
"d48de54a9dab printk: Export is_console_locked"  is needed, which merged 
in 4.19.

I will sent the patch.

> Can you please fix this up and also do a 4.9.y version?
> 

ok, I will do it.

> thanks,
> 
> greg k-h
> 


-- 
Regards
Chen Jun
