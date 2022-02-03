Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A1C4A86FD
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241901AbiBCOvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiBCOvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:51:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF6CC061714;
        Thu,  3 Feb 2022 06:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6F15B83475;
        Thu,  3 Feb 2022 14:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34070C340E4;
        Thu,  3 Feb 2022 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643899901;
        bh=iR+8+7N/xh5kXCeykan00hQo1rUDFYXXPBEwtT1eRfA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rhz9dSbr8PL5urS/xcXBicPsuOgFgVfd7TyguWDtUylv7xw1Wvn7QgHbnZC2uvmf2
         G2etqWXYHxgsKaWXPDmOLE+JG88Km64Ppef+uGp1mACDdfE3QbMc6Yn6Zh5EyvvDBm
         +A2zXssfU9wSc7vTDioX1JU9Smtn2G9+bZIuaUVmqjhH02nbmzb7JwOoRHJr2zhlYH
         u/JhgbEESVb6YVmEnEGjkB6N0OgCY4gHGb7btKjzZsLvtLkSomtgzN5R/YD/mInu65
         fx/BIoTLE1zy4jMxKB9T9y0m4rqJKIjwWD+EoFYKJdaUv/xf6cXrtZ2XSYLnv0mabV
         kQrmjAYLjY8cg==
Message-ID: <de4ac81a-8e47-a75b-fd17-274680b8d29d@kernel.org>
Date:   Thu, 3 Feb 2022 22:51:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 4.19 026/239] f2fs: fix to do sanity check in is_alive()
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20220124183943.102762895@linuxfoundation.org>
 <20220124183943.957395248@linuxfoundation.org>
 <20220124203637.GA19321@duo.ucw.cz>
 <3c56cf70-2557-2e9c-4694-588ddaa91220@kernel.org>
 <20220201191832.GA31656@duo.ucw.cz>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220201191832.GA31656@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/2/2 3:18, Pavel Machek wrote:
> Hi!
> 
>> Oops, you're right, my bad.
>>
>>>
>>>> +++ b/fs/f2fs/gc.c
>>>> @@ -589,6 +589,9 @@ static bool is_alive(struct f2fs_sb_info
>>>>    		set_sbi_flag(sbi, SBI_NEED_FSCK);
>>>>    	}
>>>> +	if (f2fs_check_nid_range(sbi, dni->ino))
>>>> +		return false;
>>>> +
>>>>    	*nofs = ofs_of_node(node_page);
>>>>    	source_blkaddr = datablock_addr(NULL, node_page, ofs_in_node);
>>>>    	f2fs_put_page(node_page, 1);
>>>
>>> AFAICT f2fs_put_page() needs to be done in the error path, too.
>>>
>>> (Problem seems to exist in mainline, too).
>>>
>>> Something like this?
>>
>> Could you please send a formal patch to f2fs mailing list for better review?
>>
>> Anyway, thanks a lot for the report and the patch!
> 
> I'm quite busy with other reviews at the moment. If you could submit a
> patch, it would be great, otherwise I'll get to it .. sometime.

I've submitted a patch, could you please take a look?

Thanks,

> 
> Best regards,
> 									Pavel
> 									
