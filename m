Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1732E497
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 10:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCEJSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 04:18:32 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13062 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhCEJSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 04:18:25 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DsMY34mMxzMjMf;
        Fri,  5 Mar 2021 17:16:07 +0800 (CST)
Received: from [10.136.110.154] (10.136.110.154) by smtp.huawei.com
 (10.3.19.211) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 5 Mar 2021
 17:18:15 +0800
Subject: Re: [PATCH v2] f2fs: fix error handling in f2fs_end_enable_verity()
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>, <stable@vger.kernel.org>,
        Yunlei He <heyunlei@hihonor.com>
References: <20210305054310.111011-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <6fdddbac-7148-a2ff-2fcd-3cdde5ed3aa0@huawei.com>
Date:   Fri, 5 Mar 2021 17:18:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210305054310.111011-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.110.154]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/3/5 13:43, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> f2fs didn't properly clean up if verity failed to be enabled on a file:
> 
> - It left verity metadata (pages past EOF) in the page cache, which
>    would be exposed to userspace if the file was later extended.
> 
> - It didn't truncate the verity metadata at all (either from cache or
>    from disk) if an error occurred while setting the verity bit.
> 
> Fix these bugs by adding a call to truncate_inode_pages() and ensuring
> that we truncate the verity metadata (both from cache and from disk) in
> all error paths.  Also rework the code to cleanly separate the success
> path from the error paths, which makes it much easier to understand.
> 
> Finally, log a message if f2fs_truncate() fails, since it might
> otherwise fail silently.
> 
> Reported-by: Yunlei He <heyunlei@hihonor.com>
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
