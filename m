Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648AE6A87B1
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 18:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCBRQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 12:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCBRQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 12:16:50 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C322625E02
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 09:16:49 -0800 (PST)
Received: from [192.168.2.216] (109-252-117-89.nat.spd-mgts.ru [109.252.117.89])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 701BC6602F64;
        Thu,  2 Mar 2023 17:16:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1677777408;
        bh=9+LsKOxASfHNgQnQTMd3imAcZuorrm+JG7Tg634FOpQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lv8cA+1K8lLWL+Hq3Il1En+EmYanRr3ngLoU7xULHJNRjXqCLJCAcSzT2kHPxWzKV
         7SODLXktKBo4B/tNN1kfY99kYLU3n2YtSuMRdOZwDf75MDKXfb9BLJwFNjIx5oJfu6
         kP7OVntfyOUiiM2LenxOejWBFkXou+ODfywxDjHQjsbER4JW3Ek0elAJds9vqY3GuW
         +q65ulD0gdYeRS2RQFA+HUT+v+QpTfcNN9H6Gvy26av8r/7jJyWWVemti1bIhjumbv
         zwHexHCF4b5jCGPTUaEpsgQViFHvs/aA4ujUd6p0dEhMi9yYTtTOU9DxYQvwBWTLhF
         SbibPjzT6Jnrw==
Message-ID: <0c9d2708-cd94-7a68-4f55-02b5a41e073b@collabora.com>
Date:   Thu, 2 Mar 2023 20:16:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 16/19] drm/virtio: Correct
 drm_gem_shmem_get_sg_table() error handling
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Emil Velikov <emil.l.velikov@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Dan Carpenter <error27@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20230301180652.316428563@linuxfoundation.org>
 <20230301180652.989746215@linuxfoundation.org>
 <78b78fd7-899c-aee8-4f82-f7e7dbc2f4c9@oracle.com>
Content-Language: en-US
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <78b78fd7-899c-aee8-4f82-f7e7dbc2f4c9@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/23 19:52, Harshit Mogalapalli wrote:
> Hi,
> 
> On 01/03/23 11:38 pm, Greg Kroah-Hartman wrote:
>> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>>
>> commit 64b88afbd92fbf434759d1896a7cf705e1c00e79 upstream.
>>
>> Previous commit fixed checking of the ERR_PTR value returned by
>> drm_gem_shmem_get_sg_table(), but it missed to zero out the shmem->pages,
>> which will crash virtio_gpu_cleanup_object(). Add the missing zeroing of
>> the shmem->pages.
>>
>> Fixes: c24968734abf ("drm/virtio: Fix NULL vs IS_ERR checking in
>> virtio_gpu_object_shmem_init")
>> Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
>> Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>> Link:
>> https://urldefense.com/v3/__http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-2-dmitry.osipenko@collabora.com__;!!ACWV5N9M2RV99hQ!KAxF_UJ7x6SleCxrpYd8Huyt4Zj4e08fd9IUL6fl1Wneipk6_LKBnYuqQ2LK0bnvWHC6dxungVXptuvz5-4QQ2zjcq_JT1ub$
>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
>> ---
>>   drivers/gpu/drm/virtio/virtgpu_object.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> --- a/drivers/gpu/drm/virtio/virtgpu_object.c
>> +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
>> @@ -159,6 +159,7 @@ static int virtio_gpu_object_shmem_init(
>>       shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
>>       if (IS_ERR(shmem->pages)) {
>>           drm_gem_shmem_unpin(&bo->base.base);
>> +        shmem->pages = NULL;
>>           return PTR_ERR(shmem->pages);
>>       }
> 
> While doing static analysis with smatch on LTS-rc series I found this bug.
> 
> PTR_ERR(NULL) is 1/success, so we are returning success in this case,
> which looks wrong.
> 
> Only 5.10.y and 5.15.y are effected. Upstream commit b5c9ed70d1a9
> ("drm/virtio: Improve DMA API usage for shmem BOs")
> deleted this code, is present in linux-6.1.y and
> linux-6.2.y, so this problem is not in 6.1.y and 6.2.y stable releases.
> 
> I have prepared a patch for fixing this, will send it out.

Thanks, that's a good catch!

-- 
Best regards,
Dmitry

