Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E95A19BE
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 21:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243226AbiHYTpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 15:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243733AbiHYTp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 15:45:29 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16B4D3335E;
        Thu, 25 Aug 2022 12:45:27 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4DADAEF8;
        Thu, 25 Aug 2022 14:43:51 -0500 (CDT)
Message-ID: <4ccd8b01-24ae-87de-3cfa-bf99a8bb6b3b@sandeen.net>
Date:   Thu, 25 Aug 2022 14:45:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2] fs: fix UAF/GPF bug in nilfs_mdt_destroy
Content-Language: en-US
To:     Dongliang Mu <dzm91@hust.edu.cn>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, Jiacheng Xu <stitch@zju.edu.cn>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220816040859.659129-1-dzm91@hust.edu.cn>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220816040859.659129-1-dzm91@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/22 11:08 PM, Dongliang Mu wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> In alloc_inode, inode_init_always() could return -ENOMEM if
> security_inode_alloc() fails, which causes inode->i_private
> uninitialized. Then nilfs_is_metadata_file_inode() returns
> true and nilfs_free_inode() wrongly calls nilfs_mdt_destroy(),
> which frees the uninitialized inode->i_private
> and leads to crashes(e.g., UAF/GPF).
> 
> Fix this by moving security_inode_alloc just prior to
> this_cpu_inc(nr_inodes)
> 
> Link: https://lkml.kernel.org/r/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ@mail.gmail.com
> Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Reported-by: Jiacheng Xu <stitch@zju.edu.cn>
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> ---
> v1->v2: move security_inode_alloc at the very end according to Al Viro
> 	other than initializing i_private before security_inode_alloc.
>  fs/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 6462276dfdf0..49d1eb91728c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -192,8 +192,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
>  	inode->i_wb_frn_history = 0;
>  #endif
>  
> -	if (security_inode_alloc(inode))
> -		goto out;
>  	spin_lock_init(&inode->i_lock);
>  	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
>  
> @@ -228,6 +226,9 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
>  	inode->i_fsnotify_mask = 0;
>  #endif
>  	inode->i_flctx = NULL;
> +
> +	if (security_inode_alloc(inode))
> +		goto out;

Seems like the out: label could be removed, and simply return -ENOMEM directly here,
but that's just a nitpick.

-Eric

>  	this_cpu_inc(nr_inodes);
>  
>  	return 0;
