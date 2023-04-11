Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E566DD02D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDKD3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDKD3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF40D1724;
        Mon, 10 Apr 2023 20:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 496A86145A;
        Tue, 11 Apr 2023 03:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64803C433D2;
        Tue, 11 Apr 2023 03:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681183776;
        bh=8LDh54v+qQDwP7GfVmR9n31ko7S3dKLDiRvUJ8KDTLo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=euv2XbmWvZz54H6/qkrcpFrK+4KsVY+yii8cCib+J6kGceO/xaqWN717ECtugvyhC
         05/WCCY8hBFDs9/hsC2YHKbNGF3pni9u5q1g+FsPmjyW+a4Q+iB6jZYdwucChI/l06
         tMGN2Ovb3NmNUFh40njg7tOsytb4zYZPj6qswhlU=
Date:   Mon, 10 Apr 2023 20:29:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     Liam.Howlett@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        David Binderman <dcb314@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] maple_tree: Use correct variable type in sizeof
Message-Id: <20230410202935.d1abf62f386eefb1efa36ce4@linux-foundation.org>
In-Reply-To: <20230411023513.15227-1-zhangpeng.00@bytedance.com>
References: <20230411023513.15227-1-zhangpeng.00@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Apr 2023 10:35:13 +0800 Peng Zhang <zhangpeng.00@bytedance.com> wrote:

> The type of variable pointed to by pivs is unsigned long, but the type
> used in sizeof is a pointer type. Change it to unsigned long.

Thanks, but there's nothing in this changelog which explains why a
-stable backport is being proposed.  When fixing a bug, please always
describe the user-visible effects of that bug.

> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3255,7 +3255,7 @@ static inline void mas_destroy_rebalance(struct ma_state *mas, unsigned char end
>  
>  		if (tmp < max_p)
>  			memset(pivs + tmp, 0,
> -			       sizeof(unsigned long *) * (max_p - tmp));
> +			       sizeof(unsigned long) * (max_p - tmp));
>  
>  		if (tmp < mt_slots[mt])
>  			memset(slots + tmp, 0, sizeof(void *) * (max_s - tmp));

Is there any situation in which
sizeof(unsigned long *) != sizeof(unsigned long)?
