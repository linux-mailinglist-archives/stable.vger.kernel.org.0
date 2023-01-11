Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E17665BE2
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 13:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjAKM53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 07:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjAKM51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 07:57:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764CD1C4;
        Wed, 11 Jan 2023 04:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ADE561A9C;
        Wed, 11 Jan 2023 12:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C0CC433EF;
        Wed, 11 Jan 2023 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673441845;
        bh=2Ok56WfZJaCSfZDKDQWYGdgKxRCuAs08e+mmKxHXkzQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=P99z6P9TEqBjn98Wr/1dWqSNvVmQ/MiFdfbD983uPUSRYD7y4/adFnXkKvBUzUQ8+
         Eegqf1WofVKzJ8xD4FKg8yVvV9l1wi86QUvK73kxD8cYVUj1BN/YlSiWd4HcFf34dM
         OjeqP6kw2bUJq4W3/8OKvUW3ugMnzJKeJ7JoE6Y8DRcqVHmbgyNaD0aCLUJH6nmpgC
         1AvxO3/s5st572JmHmHv9d6II0N5Rwdi1d0zrC5OWlj5ZLFTeaZBO1pENzDaMItUcH
         GvQjQoezGK6ogUFIGiIu/rDjoS1lsCkRKjVlWdAhmvJ5+dY8oulsrEgKiUVdN1Dnc1
         yv4veRc//aJFw==
Message-ID: <77b18266-69c4-c7f0-0eab-d2069a7b21d5@kernel.org>
Date:   Wed, 11 Jan 2023 20:57:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: retry to update the inode page given
 EIO
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
 <Y74O+5SklijYqMU1@google.com>
Content-Language: en-US
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <Y74O+5SklijYqMU1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/1/11 9:20, Jaegeuk Kim wrote:
> In f2fs_update_inode_page, f2fs_get_node_page handles EIO along with
> f2fs_handle_page_eio that stops checkpoint, if the disk couldn't be recovered.
> As a result, we don't need to stop checkpoint right away given single EIO.

f2fs_handle_page_eio() only covers the case that EIO occurs on the same
page, should we cover the case EIO occurs on different pages?

Thanks,

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Randall Huang <huangrandall@google.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
> 
>   Change log from v1:
>    - fix a bug
> 
>   fs/f2fs/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index ff6cf66ed46b..2ed7a621fdf1 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -719,7 +719,7 @@ void f2fs_update_inode_page(struct inode *inode)
>   	if (IS_ERR(node_page)) {
>   		int err = PTR_ERR(node_page);
>   
> -		if (err == -ENOMEM) {
> +		if (err == -ENOMEM || (err == -EIO && !f2fs_cp_error(sbi))) {
>   			cond_resched();
>   			goto retry;
>   		} else if (err != -ENOENT) {
