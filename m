Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C804F32AEE0
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbhCCAG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13037 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837869AbhCBI7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 03:59:36 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DqVrg3tMvzMg9X;
        Tue,  2 Mar 2021 16:38:11 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 16:40:13 +0800
Subject: Re: [PATCH 4.19 21/57] proc: dont allow async path resolution of
 /proc/self components
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        yangerkun <yangerkun@huawei.com>,
        Cheng Jian <cj.chengjian@huawei.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084650.205087954@linuxfoundation.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <cced67ae-ceca-3812-121c-70e0ed104f49@huawei.com>
Date:   Tue, 2 Mar 2021 16:40:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20201201084650.205087954@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2020/12/1 16:53, Greg Kroah-Hartman wrote:
> From: Jens Axboe <axboe@kernel.dk>
>
> [ Upstream commit 8d4c3e76e3be11a64df95ddee52e99092d42fc19 ]
>
> If this is attempted by a kthread, then return -EOPNOTSUPP as we don't
> currently support that. Once we can get task_pid_ptr() doing the right
> thing, then this can go away again.

https://www.spinics.net/lists/io-uring/msg05297.html

This patch seems used for io-wq worker which is merged in

v5.5-rc1, why we need this in linux-4.19.y ?


Thanks,

Yang

>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/proc/self.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/fs/proc/self.c b/fs/proc/self.c
> index cc6d4253399d1..7922edf70ce1a 100644
> --- a/fs/proc/self.c
> +++ b/fs/proc/self.c
> @@ -16,6 +16,13 @@ static const char *proc_self_get_link(struct dentry *dentry,
>   	pid_t tgid = task_tgid_nr_ns(current, ns);
>   	char *name;
>   
> +	/*
> +	 * Not currently supported. Once we can inherit all of struct pid,
> +	 * we can allow this.
> +	 */
> +	if (current->flags & PF_KTHREAD)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
>   	if (!tgid)
>   		return ERR_PTR(-ENOENT);
>   	/* max length of unsigned int in decimal + NULL term */
