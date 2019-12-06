Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766C2114C40
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 07:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLFGCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 01:02:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:36170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbfLFGCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 01:02:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BCC37AD10;
        Fri,  6 Dec 2019 06:02:19 +0000 (UTC)
Subject: Re: FAILED - [PATCH v2 3/3] drm/mgag200: Add workaround for HW that
 does not support 'startadd'
To:     John Donnelly <john.p.donnelly@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Jos=c3=a9_Roberto_de_Souza?= <jose.souza@intel.com>,
        airlied@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Gerd Hoffmann <kraxel@redhat.com>
References: <20191126101529.20356-4-tzimmermann@suse.de>
 <20191128142337.1B32A217F5@mail.kernel.org>
 <53967A49-E729-409B-8FDD-019160FFF675@oracle.com>
 <68E1D255-8E73-4112-B966-AFE851389A34@oracle.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 mQENBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAG0J1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPokBVAQTAQgAPhYh
 BHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsDBQkDwmcABQsJCAcCBhUKCQgLAgQWAgMB
 Ah4BAheAAAoJEGgNwR1TC3ojR80H/jH+vYavwQ+TvO8ksXL9JQWc3IFSiGpuSVXLCdg62AmR
 irxW+qCwNncNQyb9rd30gzdectSkPWL3KSqEResBe24IbA5/jSkPweJasgXtfhuyoeCJ6PXo
 clQQGKIoFIAEv1s8l0ggPZswvCinegl1diyJXUXmdEJRTWYAtxn/atut1o6Giv6D2qmYbXN7
 mneMC5MzlLaJKUtoH7U/IjVw1sx2qtxAZGKVm4RZxPnMCp9E1MAr5t4dP5gJCIiqsdrVqI6i
 KupZstMxstPU//azmz7ZWWxT0JzgJqZSvPYx/SATeexTYBP47YFyri4jnsty2ErS91E6H8os
 Bv6pnSn7eAq5AQ0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRH
 UE9eosYbT6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgT
 RjP+qbU63Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+R
 dhgATnWWGKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zb
 ehDda8lvhFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r
 12+lqdsAEQEAAYkBPAQYAQgAJhYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsMBQkD
 wmcAAAoJEGgNwR1TC3ojpfcIAInwP5OlcEKokTnHCiDTz4Ony4GnHRP2fXATQZCKxmu4AJY2
 h9ifw9Nf2TjCZ6AMvC3thAN0rFDj55N9l4s1CpaDo4J+0fkrHuyNacnT206CeJV1E7NYntxU
 n+LSiRrOdywn6erjxRi9EYTVLCHcDhBEjKmFZfg4AM4GZMWX1lg0+eHbd5oL1as28WvvI/uI
 aMyV8RbyXot1r/8QLlWldU3NrTF5p7TMU2y3ZH2mf5suSKHAMtbE4jKJ8ZHFOo3GhLgjVrBW
 HE9JXO08xKkgD+w6v83+nomsEuf6C6LYrqY/tsZvyEX6zN8CtirPdPWu/VXNRYAl/lat7lSI
 3H26qrE=
Message-ID: <41deb310-2bd9-a505-c712-a66471c99656@suse.de>
Date:   Fri, 6 Dec 2019 07:02:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <68E1D255-8E73-4112-B966-AFE851389A34@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Am 06.12.19 um 01:48 schrieb John Donnelly:
> 
> 
>> On Dec 3, 2019, at 11:30 AM, John Donnelly <john.p.donnelly@oracle.com> wrote:
>>
>>
>> Hello Sasha and Thomas ,
>>
>>
>> This particular patch has failed on one class of servers that has a slightly different Sun Vendor. ID for  the BMC video device: 
>>
>> I will follow up with additional details in  the review comments for the original message,. 
>>
>>
>>
>>
>>> On Nov 28, 2019, at 8:23 AM, Sasha Levin <sashal@kernel.org> wrote:
>>>
>>> Hi,
>>>
>>> [This is an automated email]
>>>
>>> This commit has been processed because it contains a "Fixes:" tag,
>>> fixing commit: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with kunmap + unpin").
>>>
>>> The bot has tested the following trees: v5.3.13.
>>>
>>> v5.3.13: Build failed! Errors:
>>>   drivers/gpu/drm/mgag200/mgag200_drv.c:104:18: error: ‘drm_vram_mm_debugfs_init’ undeclared here (not in a function); did you mean ‘drm_client_debugfs_init’?
>>>
> 
> 
>    I had this same issue and removed that from my local 5.4.0-rc8 build 

The bot used the wrong tree. The patch has been written against drm-tip.

Best regards
Thomas

> 
> 
> 
> 
>>>
>>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>>
>>> How should we proceed with this patch?
>>>
>>> -- 
>>> Thanks,
>>> Sasha
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__lists.freedesktop.org_mailman_listinfo_dri-2Ddevel&d=DwIGaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=t2fPg9D87F7D8jm0_3CG9yoiIKdRg4qc_thBw4bzMhc&m=vxMDOLV77rRe2ekdNFH9IxMSBQrTccltZd8A1H6xYCc&s=efHs2lc_RQYvzLC82c-D3wa8MpX5DCU_YsIo6XruAQg&e=
>>
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

-- 
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg)
Geschäftsführer: Felix Imendörffer
