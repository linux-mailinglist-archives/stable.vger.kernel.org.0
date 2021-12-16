Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2947756C
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 16:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhLPPMj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 16 Dec 2021 10:12:39 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4300 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhLPPMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 10:12:37 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JFFtb1m2gz67DWp;
        Thu, 16 Dec 2021 23:11:03 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 16:12:35 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.020;
 Thu, 16 Dec 2021 16:12:35 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     "airlied@linux.ie" <airlied@linux.ie>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com" 
        <syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com>
Subject: RE: [PATCH] drm/virtio: Ensure that objs is not NULL in
 virtio_gpu_array_put_free()
Thread-Topic: [PATCH] drm/virtio: Ensure that objs is not NULL in
 virtio_gpu_array_put_free()
Thread-Index: AQHX8E+19jelqmPilEqoid7n1sYbcaw1Pc8Q
Date:   Thu, 16 Dec 2021 15:12:35 +0000
Message-ID: <4b0d93611e8740afbf25870e8b54a8e9@huawei.com>
References: <20211213183122.838119-1-roberto.sassu@huawei.com>
In-Reply-To: <20211213183122.838119-1-roberto.sassu@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Roberto Sassu
> Sent: Monday, December 13, 2021 7:31 PM
> If virtio_gpu_object_shmem_init() fails (e.g. due to fault injection, as it
> happened in the bug report by syzbot), virtio_gpu_array_put_free() could be
> called with objs equal to NULL.
> 
> Ensure that objs is not NULL in virtio_gpu_array_put_free(), or otherwise
> return from the function.

Hello

did you have the chance to look at this patch?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

> Cc: stable@vger.kernel.org # 5.13.x
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reported-by: syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com
> Fixes: 377f8331d0565 ("drm/virtio: fix possible leak/unlock
> virtio_gpu_object_array")
> ---
>  drivers/gpu/drm/virtio/virtgpu_gem.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c
> b/drivers/gpu/drm/virtio/virtgpu_gem.c
> index 2de61b63ef91..48d3c9955f0d 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_gem.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
> @@ -248,6 +248,9 @@ void virtio_gpu_array_put_free(struct
> virtio_gpu_object_array *objs)
>  {
>  	u32 i;
> 
> +	if (!objs)
> +		return;
> +
>  	for (i = 0; i < objs->nents; i++)
>  		drm_gem_object_put(objs->objs[i]);
>  	virtio_gpu_array_free(objs);
> --
> 2.32.0

