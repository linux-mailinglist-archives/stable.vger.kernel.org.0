Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2C35270A
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 09:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhDBHpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 03:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234347AbhDBHpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Apr 2021 03:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB30B6100C;
        Fri,  2 Apr 2021 07:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617349515;
        bh=CHUVzzwOvWHtGtMyC4Dc1Tl18xOORfSsXep5lgLLe2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kuXPhZGbzsmIlQQ+0YxQDc3oNZiQ5/9V4vc/3qBG9wuRZI6Wg2o9jjUoSqllaZ6tV
         Y4etNp9PQE5YCP8KxUeDvdXS3Zrozv+RFtarS1sduVbnDjQqtgjazqLtC0fuHgtgmL
         a8d+1WxuomHRupfDfGz0WgYcJ2u86W0BAYLNhLrU=
Date:   Fri, 2 Apr 2021 09:45:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     stable@vger.kernel.org, vbabka@suse.cz, linux-mm@kvack.org,
        open-iscsi@googlegroups.com, cleech@redhat.com,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        liuyongqiang13@huawei.com,
        "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        chenzhou10@huawei.com
Subject: Re: [QUESTION] WARNNING after 3d8e2128f26a ("sysfs: Add sysfs_emit
 and sysfs_emit_at to format sysfs output")
Message-ID: <YGbLiIL8ewIX1Hrt@kroah.com>
References: <5837f5d9-2235-3ac2-f3f2-712e6cf4da5c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5837f5d9-2235-3ac2-f3f2-712e6cf4da5c@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 02, 2021 at 03:16:21PM +0800, yangerkun wrote:
> sysfs_emit(3d8e2128f26a ("sysfs: Add sysfs_emit and sysfs_emit_at to
> format sysfs output")) has a hidden constraint that the buf should be
> alignment with PAGE_SIZE. It's OK since 59bb47985c1d ("mm, sl[aou]b:
> guarantee natural alignment for kmalloc(power-of-two)") help us to solve
> scenes like CONFIG_SLUB_DEBUG or CONFIG_SLOB which will break this.
> 
> 
> But since lots of stable branch(we reproduce it with 4.19 stable) merge
> 3d8e2128f26a ("sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs
> output") without 59bb47985c1d ("mm, sl[aou]b: guarantee natural
> alignment for kmalloc(power-of-two)"), we will get the follow warning
> with command 'cat /sys/class/iscsi_transport/tcp/handle' once we enable
> CONFIG_SLUB_DEBUG and start kernel with slub_debug=UFPZ!
> 
> 
> Obviously, we can backport 59bb47985c1d ("mm, sl[aou]b: guarantee
> natural alignment for kmalloc(power-of-two)") to fix it. But this will
> waste some memory to ensure natural alignment which seems unbearable for
> embedded device. So for stable branch like 4.19, can we just remove the
> warning in sysfs_emit since the only user for it is iscsi, and seq_read
> + sysfs_kf_seq_show can ensure that the buf in sysfs_emit must be aware
> of PAGE_SIZE. Or does there some other advise for this problem?

More users of this function will be backported over time as we all know,
so just removing the functions is not good.

Why is the buffer alignment considered a "waste" here?  If that change
is in Linus's tree and newer kernels (it showed up in 5.4 which was
released quite a while ago), where are the people complaining about it
there?

I think backporting 59bb47985c1d ("mm, sl[aou]b: guarantee natural
alignment for kmalloc(power-of-two)") seems like the correct thing to do
here to bring things into alignment (pun intended) with newer kernels.

thanks,

greg k-h
