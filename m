Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DCA20CAE5
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 00:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgF1WIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 18:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgF1WIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 18:08:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E522065D;
        Sun, 28 Jun 2020 22:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593382096;
        bh=tnBagW9pptZ2kIcjglaAW420dosX/kSmRkyJV/JS8m4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zzJL5D22Ogd+9mwsYIvmB6XUD/2fZQlL72DyuX4TfAUk53Ds93pqiZZyZSqnJz60D
         Hy5WunSGu1XyWnceurRAHFq1X5P5x7VCK7FTNIKVxT/TWdV7r2RskMuIxGDcJ0iW6t
         rfETK7mFQ2aOhi+t2ewCKdE/1lyuTGMAupo4Y0v0=
Date:   Sun, 28 Jun 2020 18:08:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     zhangxiaoxu5@huawei.com, hulkci@huawei.com, pshilov@microsoft.com,
        stfrench@microsoft.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cifs/smb3: Fix data inconsistent when
 zero file range" failed to apply to 4.19-stable tree
Message-ID: <20200628220815.GP1931@sasha-vm>
References: <159335944015982@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159335944015982@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 28, 2020 at 05:50:40PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 6b69040247e14b43419a520f841f2b3052833df9 Mon Sep 17 00:00:00 2001
>From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>Date: Tue, 23 Jun 2020 07:31:54 -0400
>Subject: [PATCH] cifs/smb3: Fix data inconsistent when zero file range
>
>CIFS implements the fallocate(FALLOC_FL_ZERO_RANGE) with send SMB
>ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
>remote file to zero, but local page cache not update, then the data
>inconsistent with server, which leads the xfstest generic/008 failed.
>
>So we need to remove the local page caches before send SMB
>ioctl(FSCTL_SET_ZERO_DATA) to server. After next read, it will
>re-cache it.
>
>Fixes: 30175628bf7f5 ("[SMB3] Enable fallocate -z support for SMB3 mounts")
>Reported-by: Hulk Robot <hulkci@huawei.com>
>Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>Cc: stable@vger.kernel.org # v3.17
>Signed-off-by: Steve French <stfrench@microsoft.com>

Conflict with the tracepoint that didn't exist on older kernels. Fixed
up and queued for 4.19, 4.14, 4.9, and 4.4.

-- 
Thanks,
Sasha
