Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7236AE663
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCGQYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjCGQYY (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 11:24:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B8C1421E;
        Tue,  7 Mar 2023 08:23:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03440614C3;
        Tue,  7 Mar 2023 16:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2739C4339E;
        Tue,  7 Mar 2023 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678206181;
        bh=7jiRWQnOqlikHWyFcy2266cI8cKqGFksydn4vH8WOKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZIIjZMv/lwIojx0KSIDfHtx96xXXbsbilPAsxXCVHEjeLRDbgBWHS64JfOSfuLx7
         Vsenx+JlUw/YuO6tI+C133WV5E9x6aqBGG9k+o3GsutUa/pc7hweduh94O1IpGOwO1
         2snHaVJ4VjrhcAbqmt6pDxyFKSgOV+xiGIOJSuqg=
Date:   Tue, 7 Mar 2023 17:21:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     Liam.Howlett@oracle.com, snild@sony.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Stable@vger.kernel.org
Subject: Re: [PATCH] maple_tree: Fix the error of mas->min/max in
 mas_skip_node()
Message-ID: <ZAdki6kTfwm/B+yD@kroah.com>
References: <20230307160340.57074-1-zhangpeng.00@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307160340.57074-1-zhangpeng.00@bytedance.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 12:03:40AM +0800, Peng Zhang wrote:
> The assignment of mas->min and mas->max is wrong. mas->min and mas->max
> should represent the range of the current node. After mas_ascend()
> returns, mas-min and mas->max already represent the range of the current
> node, so we should delete these assignments of mas->min and mas->max.
> 
> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> ---
>  lib/maple_tree.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index f5bee48de569..d4ddf7f8adc7 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5157,9 +5157,6 @@ static inline bool mas_rewind_node(struct ma_state *mas)
>   */
>  static inline bool mas_skip_node(struct ma_state *mas)
>  {
> -	unsigned long *pivots;
> -	enum maple_type mt;
> -
>  	if (mas_is_err(mas))
>  		return false;
>  
> @@ -5173,14 +5170,7 @@ static inline bool mas_skip_node(struct ma_state *mas)
>  			mas_ascend(mas);
>  		}
>  	} while (mas->offset >= mas_data_end(mas));
> -
> -	mt = mte_node_type(mas->node);
> -	pivots = ma_pivots(mas_mn(mas), mt);
> -	mas->min = pivots[mas->offset] + 1;
>  	mas->offset++;
> -	if (mas->offset < mt_slots[mt])
> -		mas->max = pivots[mas->offset];
> -
>  	return true;
>  }
>  
> -- 
> 2.20.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
