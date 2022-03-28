Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1F4E8C5D
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 04:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiC1C7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 22:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiC1C7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 22:59:00 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09774B1F6;
        Sun, 27 Mar 2022 19:57:20 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648436235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhpVEffh7PsiV5KTLrc2gQ5RNNJSm3uaVzdGf/WPCPY=;
        b=XH2tGYkkqFH4Yww3ZFRv806shwyK3IlfyFQ6NqCFsFH2arW3wc8RVAw8RQN/y3yo6nzjXs
        C4hL7UtJ5K8ilIuZJHFkdrTYSSTKRovdVpSZUXfwmoYNED8DggvKiV52zrHPaOwtm6oQSh
        N92iL8ZSnkADXx3hqTB/RBHKDAPu9II=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH] md: md2: fix an incorrect NULL check on list iterator
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, song@kernel.org,
        rgoldwyn@suse.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220327080111.12028-1-xiam0nd.tong@gmail.com>
Message-ID: <bdc2ed02-6f13-c8a5-7e61-190a5dd9b6bc@linux.dev>
Date:   Mon, 28 Mar 2022 10:57:11 +0800
MIME-Version: 1.0
In-Reply-To: <20220327080111.12028-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiaomeng,

I'd suggest to rephrase the subject to "md: fix an incorrect NULL check 
in md_reload_sb".

On 3/27/22 4:01 PM, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!rdev || rdev->desc_nr != nr) {
>
> The list iterator value 'rdev' will *always* be set and non-NULL
> by rdev_for_each_rcu(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> found (In fact, it will be a bogus pointer to an invalid struct
> object containing the HEAD). Otherwise it will bypass the check
> and lead to invalid memory access passing the check.
>
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'pdev' as a dedicated pointer to
> point to the found element.
>
> Cc:stable@vger.kernel.org
> Fixes: 70bcecdb1534 ("amd-cluster: Improve md_reload_sb to be less error prone")

amd-cluster? 😉

> Signed-off-by: Xiaomeng Tong<xiam0nd.tong@gmail.com>
> ---
>   drivers/md/md.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7476fc204172..f156678c08bc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9794,16 +9794,18 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   
>   void md_reload_sb(struct mddev *mddev, int nr)
>   {
> -	struct md_rdev *rdev;
> +	struct md_rdev *rdev = NULL, *iter;
>   	int err;
>   
>   	/* Find the rdev */
> -	rdev_for_each_rcu(rdev, mddev) {
> -		if (rdev->desc_nr == nr)
> +	rdev_for_each_rcu(iter, mddev) {
> +		if (iter->desc_nr == nr) {
> +			rdev = iter;
>   			break;
> +		}
>   	}
>   
> -	if (!rdev || rdev->desc_nr != nr) {
> +	if (!rdev) {
>   		pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
>   		return;
>   	}

I guess we only need to check desc_nr since rdev should always be valid 
, and IMO the fix tag
is not necessary.

@@ -9800,7 +9800,7 @@ void md_reload_sb(struct mddev *mddev, int nr)
                         break;
         }

-       if (!rdev || rdev->desc_nr != nr) {
+       if (rdev->desc_nr != nr) {

Thanks,
Guoqing
