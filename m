Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D957360C1F6
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 04:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJYCyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 22:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiJYCxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 22:53:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524041211E1;
        Mon, 24 Oct 2022 19:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD695616E6;
        Tue, 25 Oct 2022 02:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A31C433C1;
        Tue, 25 Oct 2022 02:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666666424;
        bh=bgoqEEDvEzhJrh/4G88Q8OoiwieqsueEejZQ94ELqxM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ge6F4ay+H3GfgnTrjb10k9mDv43jrwM/QSF6PXQSHbhGJPX5IMdTqcg1R3ndDvaiH
         MSavLeGVgqF5W6+GA6VgZwYTRqdfS4T9wIwwQZPKFvz1a47zG1wBLkYQ1kSzp1Obgn
         JlP/PDnAOOHusRrXQw/plpAvcVt8tqWFWdwspEGLjXTUeiiHeHGa7Mk9zHY30qdr5v
         FlOuicsgsX3HNnjz2F2LaRMm+gnyo9GvI9DNoTn9OaOl1oAyzUbKujnkaSzsYoUJIJ
         giaH18pI9jgEco/0K5QGVRxbqKgxxcPzESk2IzsbNdDxRHVp0+4ngj0WZf41IfnSUI
         Q0wcDytvVODqw==
Message-ID: <1b9d6a6d-4e19-f455-bf9a-659b85a3206f@kernel.org>
Date:   Tue, 25 Oct 2022 10:53:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 5.10 052/390] f2fs: fix to do sanity check on summary info
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenqing Liu <wenqingliu0120@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113024.853480982@linuxfoundation.org>
 <20221024173012.GA25198@duo.ucw.cz>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20221024173012.GA25198@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/10/25 1:30, Pavel Machek wrote:
> Hi!
> 
>> From: Chao Yu <chao@kernel.org>
>>
>> commit c6ad7fd16657ebd34a87a97d9588195aae87597d upstream.
>>
>> As Wenqing Liu reported in bugzilla:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=216456
>>
>> BUG: KASAN: use-after-free in recover_data+0x63ae/0x6ae0 [f2fs]
>> Read of size 4 at addr ffff8881464dcd80 by task mount/1013
> 
> I believe this is missing put_page on the error path:
> 
>> +++ b/fs/f2fs/gc.c
>> @@ -1003,6 +1003,14 @@ static bool is_alive(struct f2fs_sb_info
>>   		return false;
>>   	}
>>   
>> +	max_addrs = IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
>> +						DEF_ADDRS_PER_BLOCK;
>> +	if (ofs_in_node >= max_addrs) {
>> +		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
>> +			ofs_in_node, dni->ino, dni->nid, max_addrs);
>> +		return false;
>> +	}
>> +
>>   	*nofs = ofs_of_node(node_page);
>>   	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
>>   	f2fs_put_page(node_page, 1);
> 
> So something like this is needed. (Feel free to test/adapt/apply).
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> Best regards,
> 								Pavel
> 
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 4546e01b2ee0..dab794225cce 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -1110,6 +1110,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
>   	if (ofs_in_node >= max_addrs) {
>   		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
>   			ofs_in_node, dni->ino, dni->nid, max_addrs);
> +		f2fs_put_page(node_page, 1);
>   		return false;
>   	}

My bad, thanks for fixing this.

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

>   
> 
