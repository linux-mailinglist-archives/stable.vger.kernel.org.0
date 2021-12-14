Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3744745AC
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhLNOyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:54:24 -0500
Received: from smtp2.axis.com ([195.60.68.18]:5634 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235063AbhLNOyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 09:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1639493664;
  x=1671029664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ErLS7YuNpq3lp+5CZrq9QXwky6KZEURyO4aP32ZAvG0=;
  b=JO7u7DdQlFHNdSIpig4SOeftAUHIkQD1gIRPxhHl0ZbeoJPyiEG3ZZVB
   fZz9DTizPDS2TgQml4vccmBz9j4HwjVmC7ZLsAtJzFDwFS6WnXM9ctZke
   FekkpovxX8JXawO5HIHTHGK3LlEExAy8JYEE9Nrsl3N4kb4fg4ukHYc1U
   mgbynW5VEFxYfQaxxADkqQfhfAZQgbKP9F+AhxYDYlOPsOhEIwWGYHmCy
   ARlfgJcRQxr29eTBgpLwVGXKNlvyASdU1AGb0Qd1HNmbeo0w5hHLfpsbg
   MswxtmVYfyZwNY6Bbxd/RvYcpK6jFAk7RDEEWyLMOiS7dEIffv7gaq7XS
   w==;
Message-ID: <5beb196e-bb70-f28c-98c9-9e18df164e94@axis.com>
Date:   Tue, 14 Dec 2021 15:54:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] tee: handle lookup of shm with reference count 0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "op-tee@lists.trustedfirmware.org" <op-tee@lists.trustedfirmware.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lars Persson <Lars.Persson@axis.com>,
        Patrik Lantz <Patrik.Lantz@axis.com>
References: <20211214123540.1789434-1-jens.wiklander@linaro.org>
 <YbifvnSBjW5m19hZ@kroah.com>
From:   Lars Persson <larper@axis.com>
In-Reply-To: <YbifvnSBjW5m19hZ@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: se-mail03w.axis.com (10.20.40.9) To se-mail03w.axis.com
 (10.20.40.9)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021-12-14 14:44, Greg KH wrote:
> On Tue, Dec 14, 2021 at 01:35:40PM +0100, Jens Wiklander wrote:
>> Since the tee subsystem does not keep a strong reference to its idle
>> shared memory buffers, it races with other threads that try to destroy a
>> shared memory through a close of its dma-buf fd or by unmapping the
>> memory.
>> 
>> In tee_shm_get_from_id() when a lookup in teedev->idr has been
>> successful, it is possible that the tee_shm is in the dma-buf teardown
>> path, but that path is blocked by the teedev mutex. Since we don't have
>> an API to tell if the tee_shm is in the dma-buf teardown path or not we
>> must find another way of detecting this condition.
>> 
>> Fix this by doing the reference counting directly on the tee_shm using a
>> new refcount_t refcount field. dma-buf is replaced by using
>> anon_inode_getfd() instead, this separates the life-cycle of the
>> underlying file from the tee_shm. tee_shm_put() is updated to hold the
>> mutex when decreasing the refcount to 0 and then remove the tee_shm from
>> teedev->idr before releasing the mutex. This means that the tee_shm can
>> never be found unless it has a refcount larger than 0.
> 
> So you are dropping dma-buf support entirely?  And anon_inode_getfd()
> works instead?  Why do more people not do this as well?

Indeed, thinking about it, does it really makes sense to do mmap() on an 
anon_inode_getfd() fd ? It is a singleton inode used there so don't we 
breach some contract with the linux mm ? The dma-buf code for creating 
the file object is more complex, it creates a unique inode for each object.

I am by no means claiming to understand inodes' interaction with mmap, 
just sharing a concern that popped up in my head.

- Lars
