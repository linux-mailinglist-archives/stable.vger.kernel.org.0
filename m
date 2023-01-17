Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D8670B73
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 23:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjAQWL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 17:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjAQWKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 17:10:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF70743929;
        Tue, 17 Jan 2023 12:21:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93A066149D;
        Tue, 17 Jan 2023 20:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B80C433EF;
        Tue, 17 Jan 2023 20:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673986899;
        bh=Ahz305irfJEYEaciGSCUAan8ZvfkPNYtPrVTtLvOXos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqYdeTp6e10o5DYlnE8KI3d6byA6xxpoDBDurmwtb3JYU2l9nXVwc2aTyocueSPjc
         wi94QKnu2rHO/Pwf4OVcW3h/d8BaxIIRnk9EGHZdjedfKFJMRG1RhuVRKKvMLKXcGX
         3vbWodHDylNutfHma9Jhfgep4OtNZKQPcKFqjYpTpkUOf5OaHZ19/NJlBQRmcIBmZT
         l9kfbs17hJPftaKRIyEJIQ3eps5bFoV6IIM0xTJYeA14YrJFhU6Mk9A5RSP7s+6KGy
         nsVRXRrwUKHN6oLpm5fc+REKYJUllN6sNGbdLKxPY+yXGm52hRSf9ZQiwSIgoTwEYq
         CZGEcxKl6/ojw==
From:   SeongJae Park <sj@kernel.org>
Cc:     Alon Zahavi <zahavi.alon@gmail.com>,
        almaz.alexandrovich@paragon-software.com, ntfs3@lists.linux.dev,
        linux-kernel@vger.kernel.org, Tal Lossos <tallossos@gmail.com>,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] ntfs3: Fix attr_punch_hole() null pointer derenference
Date:   Tue, 17 Jan 2023 20:21:36 +0000
Message-Id: <20230117202136.116810-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815110712.36982-1-zahavi.alon@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Mon, 15 Aug 2022 14:07:12 +0300 Alon Zahavi <zahavi.alon@gmail.com> wrote:

> From: Alon Zahavi <zahavi.alon@gmail.com>
> 
> The bug occours due to a misuse of `attr` variable instead of `attr_b`.
> `attr` is being initialized as NULL, then being derenfernced
> as `attr->res.data_size`.
> 
> This bug causes a crash of the ntfs3 driver itself,
> If compiled directly to the kernel, it crashes the whole system.
> 
> Signed-off-by: Alon Zahavi <zahavi.alon@gmail.com>
> Co-developed-by: Tal Lossos <tallossos@gmail.com>
> Signed-off-by: Tal Lossos <tallossos@gmail.com>

This patch has now merged in mainline as
6d5c9e79b726cc473d40e9cb60976dbe8e669624.  stable@, could you please merge this
in stable kernels?

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations") # 5.14


Thanks,
SJ

> ---
>  fs/ntfs3/attrib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
> index e8c00dda42ad..4e74bc8f01ed 100644
> --- a/fs/ntfs3/attrib.c
> +++ b/fs/ntfs3/attrib.c
> @@ -1949,7 +1949,7 @@ int attr_punch_hole(struct ntfs_inode *ni, u64 vbo, u64 bytes, u32 *frame_size)
>  		return -ENOENT;
>  
>  	if (!attr_b->non_res) {
> -		u32 data_size = le32_to_cpu(attr->res.data_size);
> +		u32 data_size = le32_to_cpu(attr_b->res.data_size);
>  		u32 from, to;
>  
>  		if (vbo > data_size)
> -- 
> 2.25.1
> 
> 
