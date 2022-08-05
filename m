Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B75C58A5D5
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 08:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiHEGWO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 5 Aug 2022 02:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHEGWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 02:22:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD47A5A2EC
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 23:22:09 -0700 (PDT)
Received: from kwepemi100011.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lzb5y2QLtzlVsG;
        Fri,  5 Aug 2022 14:19:18 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi100011.china.huawei.com (7.221.188.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 5 Aug 2022 14:22:03 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Fri, 5 Aug 2022 14:22:03 +0800
From:   "chenjun (AM)" <chenjun102@huawei.com>
To:     Cengiz Can <cengiz.can@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "xuqiang (M)" <xuqiang36@huawei.com>
Subject: Re: [PATCH stable 4.14 v3 2/3] fbcon: Prevent that screen size is
 smaller than font size
Thread-Topic: [PATCH stable 4.14 v3 2/3] fbcon: Prevent that screen size is
 smaller than font size
Thread-Index: AQHYqJHevjk/Lf6Xg0CLiLdyiY6P+Q==
Date:   Fri, 5 Aug 2022 06:22:03 +0000
Message-ID: <fdef7841f9474b108ced6e26afb0f21f@huawei.com>
References: <20220804122734.121201-1-chenjun102@huawei.com>
 <20220804122734.121201-3-chenjun102@huawei.com>
 <602ce75b5b6dba51bc24cace86c1ada27fb6b0e9.camel@canonical.com>
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

在 2022/8/5 14:09, Cengiz Can 写道:
> On Thu, 2022-08-04 at 12:27 +0000, Chen Jun wrote:
>> From: Helge Deller <deller@gmx.de>
>>
>> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
>>
>> We need to prevent that users configure a screen size which is smaller than the
>> currently selected font size. Otherwise rendering chars on the screen will
>> access memory outside the graphics memory region.
>>
>> This patch adds a new function fbcon_modechange_possible() which
>> implements this check and which later may be extended with other checks
>> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
>> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
>> for a too small screen size.
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> [Chen Jun: adjust context]
>> Signed-off-by: Chen Jun <chenjun102@huawei.com>
>> ---
>>   drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
>>   drivers/video/fbdev/core/fbmem.c | 10 +++++++---
>>   include/linux/fbcon.h            |  4 ++++
>>   3 files changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
>> index a97e94b1c84f..b84264e98929 100644
>> --- a/drivers/video/fbdev/core/fbcon.c
>> +++ b/drivers/video/fbdev/core/fbcon.c
>> @@ -2706,6 +2706,34 @@ static void fbcon_set_all_vcs(struct fb_info *info)
>>   		fbcon_modechanged(info);
>>   }
>>   
>> +/* let fbcon check if it supports a new screen resolution */
>> +int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
>> +{
>> +	struct fbcon_ops *ops = info->fbcon_par;
>> +	struct vc_data *vc;
>> +	unsigned int i;
>> +
>> +	WARN_CONSOLE_UNLOCKED();
>> +
>> +	if (!ops)
>> +		return 0;
>> +
>> +	/* prevent setting a screen size which is smaller than font size */
>> +	for (i = first_fb_vc; i <= last_fb_vc; i++) {
>> +		vc = vc_cons[i].d;
>> +		if (!vc || vc->vc_mode != KD_TEXT ||
>> +			   registered_fb[con2fb_map[i]] != info)
>> +			continue;
>> +
>> +		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres) ||
>> +		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres))
>> +			return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
>> +
>>   static int fbcon_mode_deleted(struct fb_info *info,
>>   			      struct fb_videomode *mode)
>>   {
>> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
>> index 9087d467cc46..264e8ca5efa7 100644
>> --- a/drivers/video/fbdev/core/fbmem.c
>> +++ b/drivers/video/fbdev/core/fbmem.c
>> @@ -1134,9 +1134,13 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>>   			console_unlock();
>>   			return -ENODEV;
>>   		}
>> -		info->flags |= FBINFO_MISC_USEREVENT;
>> -		ret = fb_set_var(info, &var);
>> -		info->flags &= ~FBINFO_MISC_USEREVENT;
>> +		ret = fbcon_modechange_possible(info, &var);
>> +		if (!ret) {
>> +			info->flags |= FBINFO_MISC_USEREVENT;
>> +			ret = fb_set_var(info, &var);
>> +			info->flags &= ~FBINFO_MISC_USEREVENT;
>> +		}
>> +		lock_fb_info(info);
>>   		unlock_fb_info(info);
> 
> Why do we lock and unlock here consecutively?
> 
> Can it be a leftover?
> 
> Because in upstream commit, lock encapsulates `fb_set_var`,
> `fbcon_modechange_possible` and `fbcon_update_vcs` calls, which makes
> sense.
> 
> Here, it doesn't.
> 

Thanks, lock_fb_info(info) is wrong here.

>>   		console_unlock();
>>   		if (!ret && copy_to_user(argp, &var, sizeof(var)))
>> diff --git a/include/linux/fbcon.h b/include/linux/fbcon.h
>> index f68a7db14165..39939d55c834 100644
>> --- a/include/linux/fbcon.h
>> +++ b/include/linux/fbcon.h
>> @@ -4,9 +4,13 @@
>>   #ifdef CONFIG_FRAMEBUFFER_CONSOLE
>>   void __init fb_console_init(void);
>>   void __exit fb_console_exit(void);
>> +int  fbcon_modechange_possible(struct fb_info *info,
>> +			       struct fb_var_screeninfo *var);
>>   #else
>>   static inline void fb_console_init(void) {}
>>   static inline void fb_console_exit(void) {}
>> +static inline int  fbcon_modechange_possible(struct fb_info *info,
>> +				struct fb_var_screeninfo *var) { return 0; }
>>   #endif
>>   
>>   #endif /* _LINUX_FBCON_H */
> 
> 


-- 
Regards
Chen Jun
