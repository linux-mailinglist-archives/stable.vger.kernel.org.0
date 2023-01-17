Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F644670B47
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 23:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjAQWJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 17:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjAQWII (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 17:08:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF83EC60;
        Tue, 17 Jan 2023 12:27:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2386149D;
        Tue, 17 Jan 2023 20:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813B8C433D2;
        Tue, 17 Jan 2023 20:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673987227;
        bh=r9S6GWZqtO98hixUabotCT9dNXxS/dfJjaNPyn+TipQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFVJkIWukAG/4hoH/KvZs1ZQX+Zfk3eG87ciZxJV28q30TpQSOnHiD5UzNGHsM8vJ
         dCgAxI2DS//fuL/AUEzCMojb+ZuOQx/AyJ4WD0uEfHlsnTKAhp82GPQToeqo0Omxqp
         LcBIztjH6A14n+zmaxHTPGU5U1IoLJ3yT2qHMBevRez43e1IzTnTcDGEiwoo+dnrR9
         nvZhL8zLdFf1SaJ3D/NfzC453F3ntM3qHj1D8c1L3AgelNFKyN41rxjT6u8Om2hnX9
         fqzc0xW0Oa+Dexu8dXccc12ymY+8Ac2L8aIEARur4r6sleV+JhlFlVkgDK1bDX/rGa
         XraAFntf7vGGA==
From:   SeongJae Park <sj@kernel.org>
Cc:     Alon Zahavi <zahavi.alon@gmail.com>,
        almaz.alexandrovich@paragon-software.com, ntfs3@lists.linux.dev,
        linux-kernel@vger.kernel.org, Tal Lossos <tallossos@gmail.com>,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] ntfs3: Fix attr_punch_hole() null pointer derenference
Date:   Tue, 17 Jan 2023 20:27:03 +0000
Message-Id: <20230117202703.116897-1-sj@kernel.org>
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
>               return -ENOENT;
>
>       if (!attr_b->non_res) {
> -             u32 data_size = le32_to_cpu(attr->res.data_size);
> +             u32 data_size = le32_to_cpu(attr_b->res.data_size);
>               u32 from, to;
>
>               if (vbo > data_size)
> --
> 2.25.1
>
>
