Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047A724FC60
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHXLQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:16:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10260 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbgHXLPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:15:44 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E98ABA15FF03CF7F0D60;
        Mon, 24 Aug 2020 19:15:29 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.187) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 24 Aug 2020
 19:15:26 +0800
Subject: Re: [PATCH 4.9 15/39] jbd2: add the missing unlock_buffer() in the
 error path of jbd2_write_superblock()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ritesh Harjani <riteshh@linux.ibm.com>,
        <stable@kernel.org>, Theodore Tso <tytso@mit.edu>
References: <20200824082348.445866152@linuxfoundation.org>
 <20200824082349.270439673@linuxfoundation.org>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <72009693-6c2a-df4f-f93a-31b5924e7790@huawei.com>
Date:   Mon, 24 Aug 2020 19:15:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200824082349.270439673@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.187]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi，Greg

The problem this patch want to fix only exists on the kernel both
538bcaa6261b and 742b06b5628f these two upstream patches were merged,
but 538bcaa6261b was not merged to 4.9, so we don't need this patch
for 4.9.

Thanks,
Yi.

On 2020/8/24 16:31, Greg Kroah-Hartman wrote:
> From: zhangyi (F) <yi.zhang@huawei.com>
> 
> commit ef3f5830b859604eda8723c26d90ab23edc027a4 upstream.
> 
> jbd2_write_superblock() is under the buffer lock of journal superblock
> before ending that superblock write, so add a missing unlock_buffer() in
> in the error path before submitting buffer.
> 
> Fixes: 742b06b5628f ("jbd2: check superblock mapped prior to committing")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Cc: stable@kernel.org
> Link: https://lore.kernel.org/r/20200620061948.2049579-1-yi.zhang@huawei.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  fs/jbd2/journal.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1340,8 +1340,10 @@ static int jbd2_write_superblock(journal
>  	int ret;
>  
>  	/* Buffer got discarded which means block device got invalidated */
> -	if (!buffer_mapped(bh))
> +	if (!buffer_mapped(bh)) {
> +		unlock_buffer(bh);
>  		return -EIO;
> +	}
>  
>  	trace_jbd2_write_superblock(journal, write_flags);
>  	if (!(journal->j_flags & JBD2_BARRIER))
> 
> 
> 
> .
> 

