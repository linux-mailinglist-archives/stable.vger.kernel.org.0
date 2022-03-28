Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83784E8C5F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiC1C7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 22:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbiC1C7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 22:59:34 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5022650B04;
        Sun, 27 Mar 2022 19:57:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648436273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i6q6suH8KrNU8xV+UOxoXrCmknh3JGOhtLcTgk5QiSs=;
        b=kMMcX5KYxuGE8MAj+8IQ6srEZXX4H3gGD2ws9AfVtPOaE0+nNLkcgTg6+3ZIl+YS2PwArJ
        kNUjDIwzafR4A+ootL00BIGvpiGDGP5gvio+9kvyLqKdnLVNgGpc7ymZbLXrrUD9Iyy/ne
        rnUL2q338hWg/75znNGR2s7kLGF/SHE=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH] md: md1: fix an incorrect NULL check on list iterator
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, song@kernel.org,
        rgoldwyn@suse.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220327080002.11923-1-xiam0nd.tong@gmail.com>
Message-ID: <0e0ca783-0604-b8a6-24c2-247fd17a6af1@linux.dev>
Date:   Mon, 28 Mar 2022 10:57:49 +0800
MIME-Version: 1.0
In-Reply-To: <20220327080002.11923-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The subject need to be improved as well.

On 3/27/22 4:00 PM, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!rdev)
>
> The list iterator value 'rdev' will *always* be set and non-NULL
> by rdev_for_each(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element found.
> Otherwise it will bypass the NULL check and lead to invalid memory
> access passing the check.
>
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'pdev' as a dedicated pointer to
> point to the found element.
>
> Cc:stable@vger.kernel.org
> Fixes: 2aa82191ac36c ("md-cluster: Perform a lazy update")
> Signed-off-by: Xiaomeng Tong<xiam0nd.tong@gmail.com>
> ---
>   drivers/md/md.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4d38bd7dadd6..7476fc204172 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2629,14 +2629,16 @@ static void sync_sbs(struct mddev *mddev, int nospares)
>   
>   static bool does_sb_need_changing(struct mddev *mddev)
>   {
> -	struct md_rdev *rdev;
> +	struct md_rdev *rdev = NULL, *iter;
>   	struct mdp_superblock_1 *sb;
>   	int role;
>   
>   	/* Find a good rdev */
> -	rdev_for_each(rdev, mddev)
> -		if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
> +	rdev_for_each(iter, mddev)
> +		if ((iter->raid_disk >= 0) && !test_bit(Faulty, &iter->flags)) {
> +			rdev = iter;
>   			break;
> +		}
>   
>   	/* No good device found. */
>   	if (!rdev)


Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Thanks,
Guoqing
