Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075233C88F7
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGNQwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 12:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhGNQwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 12:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B302D613C3;
        Wed, 14 Jul 2021 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626281359;
        bh=6SKB3Qqjs+EC5rQxtbZljNFZlyLM4HZOJZxqpbfl9sM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ko/UfbhD+PKfNZ3iK4ym6LzrxkwTJIAnlAs+qXdzedMZaGQBceXrGL4yO3Mhi8Yui
         vMOTVVJx+4Ujke2mPgfBk3Ht3ixeEAIiueMcl+Mt3nZdEGKe/obO9fAbsIwGZd2S1E
         wlHDb7pZo4ORM9aKt7vjHyClabpj5MHNp1aihZ0eiiUfnZphY1Cf8Si2OtplBMmvoA
         FklATVbj/QyXl8hG1qWEX00mxNkUQ0OdAccH8p4pfKml6iQ2yveG5hqAcabY/0PnHT
         ShhjQGUDah6fa1UE1UZsYnAqBBPNlHHBWN0dRxflqSplK04t3uzsQ1hpgqx1ZY+qSN
         8z4l8b9ME85bA==
Date:   Wed, 14 Jul 2021 12:49:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 4.4 08/31] drm/virtio: Fixes a potential NULL
 pointer dereference on probe failure
Message-ID: <YO8VjgdgHXoAcOMY@sashalap>
References: <20210706112931.2066397-1-sashal@kernel.org>
 <20210706112931.2066397-8-sashal@kernel.org>
 <20210712215937.GA9488@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210712215937.GA9488@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 11:59:37PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Xie Yongji <xieyongji@bytedance.com>
>>
>> [ Upstream commit 17f46f488a5d82c5568e6e786cd760bba1c2ee09 ]
>>
>> The dev->dev_private might not be allocated if virtio_gpu_pci_quirk()
>> or virtio_gpu_init() failed. In this case, we should avoid the cleanup
>> in virtio_gpu_release().
>
>The check is in wrong place at least in 4.4:
>
>> +++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
>> @@ -257,6 +257,9 @@ int virtio_gpu_driver_unload(struct drm_device *dev)
>>  	flush_work(&vgdev->config_changed_work);
>>  	vgdev->vdev->config->del_vqs(vgdev->vdev);
>>
>> +	if (!vgdev)
>> +		return;
>> +
>
>Pointer is dereferenced before being tested.

Heh, yes, thanks for catching that. I'll drop it for now and rework it
next week.

-- 
Thanks,
Sasha
