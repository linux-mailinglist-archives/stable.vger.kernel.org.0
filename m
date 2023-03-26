Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DF6C9495
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjCZNrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 09:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCZNrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 09:47:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456657689;
        Sun, 26 Mar 2023 06:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52255CE0EB3;
        Sun, 26 Mar 2023 13:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C6DC433D2;
        Sun, 26 Mar 2023 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679838437;
        bh=s2QYAdjbUYQBkX1WyFcFHz0Vhba1CYaExhV8K6Xm6iE=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=WlczRvY58+j7UqiQ0n27gc7fKfvprvdjanglAmNZrCG/VjSo5ZpvNgsN9mKbFRbGu
         M3cvoO1b6F7UzA0QCXq0SylaVtJKLGzBXeSa04nYzRWSyQdGVUwnxj553nXE2dL3Rb
         An34Z7ymKIhJi1n2WhwLZ6NkNb/tGxIPotAx+ngpi/NzuwIHblXvZ4bMH9ARUeM3dE
         qQ6WZ4y08cRTVb7xVoK2oyl/DHDQ2WsnuXMysrZFqB4Wm9r8vA+qzj4HFkrxU2KlPS
         xtmkYzV2gtbY9dFGHUC2Yn1/HjgdnjjA67jOlhm7D40Jb1Y5djR5zVuiEOfPNQvcWn
         SmEaSnCWmiM3Q==
Message-ID: <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
Date:   Sun, 26 Mar 2023 21:47:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230323213919.1876157-1-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH] f2fs: get out of a repeat loop when getting a
 locked data page
In-Reply-To: <20230323213919.1876157-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/24 5:39, Jaegeuk Kim wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216050
> 
> Somehow we're getting a page which has a different mapping.
> Let's avoid the infinite loop.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>   fs/f2fs/data.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index bf51e6e4eb64..80702c93e885 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
>   {
>   	struct address_space *mapping = inode->i_mapping;
>   	struct page *page;
> -repeat:
> +
>   	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
>   	if (IS_ERR(page))
>   		return page;
>   
>   	/* wait for read completion */
>   	lock_page(page);
> -	if (unlikely(page->mapping != mapping)) {

How about using such logic only for move_data_page() to limit affect for
other paths?

Jaegeuk, any thoughts about why mapping is mismatch in between page's one and
inode->i_mapping?

After several times code review, I didn't get any clue about why f2fs always
get the different mapping in a loop.

Maybe we can loop MM guys to check whether below folio_file_page() may return
page which has different mapping?

struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
		int fgp_flags, gfp_t gfp)
{
	struct folio *folio;

	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
	if (IS_ERR(folio))
		return NULL;
	return folio_file_page(folio, index);
}

Thanks,

> -		f2fs_put_page(page, 1);
> -		goto repeat;
> -	}
> -	if (unlikely(!PageUptodate(page))) {
> +	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
>   		f2fs_put_page(page, 1);
>   		return ERR_PTR(-EIO);
>   	}
