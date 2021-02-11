Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FA31840F
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 04:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBKDqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 22:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhBKDqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 22:46:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D934601FC;
        Thu, 11 Feb 2021 03:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613015121;
        bh=iemugIdQeJU2GGS6+K1JMlL582bf/fRRHWUSkcs0xQE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pzvP5/Pf2KZUwiesMWWK1VNT/7zGrBUXMeNentd8JwpdYQL2Bdr3IMN6cVBAz5Sm6
         dUC30JQAojoj57Jfxz0oorso/18dLWbVSIkVYMje0eM5gTjipLCVDbTV0AknH8W/xA
         pstGzFRpc94Ij5TLW6drIF0CEkcgy4Dyzg4lYCk0OpZP8Ej9nnMQMwIeAVC98xyakA
         uZMm9vYkNXsMu6Jgv+AyT9sj5j3IfTnzt+e9KAGLkGRhnBGUaQMyvj0+eLlBxPKIpm
         GntMSLfW8+oAVbZmorzS8uHVjCJoO3ftNJH5VxbcdS5tRCRJnRay4UGz+CmylcwOLl
         GB34gmgHudX2Q==
Subject: Re: [PATCH] erofs: initialized fields can only be observed after bit
 is set
To:     Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <20210209130618.15838-1-hsiangkao.ref@aol.com>
 <20210209130618.15838-1-hsiangkao@aol.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <801d8f5d-9d5f-bc6a-1796-70d1038611da@kernel.org>
Date:   Thu, 11 Feb 2021 11:45:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209130618.15838-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/2/9 21:06, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Currently, although set_bit() & test_bit() pairs are used as a fast-
> path for initialized configurations. However, these atomic ops are
> actually relaxed forms. Instead, load-acquire & store-release form is
> needed to make sure uninitialized fields won't be observed in advance
> here (yet no such corresponding bitops so use full barriers instead.)
> 
> Fixes: 62dc45979f3f ("staging: erofs: fix race of initializing xattrs of a inode at the same time")
> Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
> Cc: <stable@vger.kernel.org> # 5.3+
> Reported-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Thanks for detailed explanation for barrier offline.

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
