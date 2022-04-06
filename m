Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8F54F6218
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 16:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiDFOvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 10:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbiDFOuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 10:50:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2212B5E9860;
        Wed,  6 Apr 2022 04:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 767D8B82014;
        Wed,  6 Apr 2022 11:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2FBC385A3;
        Wed,  6 Apr 2022 11:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649244208;
        bh=SjcaJJhx4BXe6tnaJctHdMtT1mA4dYXjywpMRbdjPeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N7tchrJdtzp4jeVjHtb9aLdDQoEL3gt3zjKdL4UzSzCFF6Xg1mW9TB0tAtjFWMIS5
         IhpmUGk3sd9JLznarD+6dgCgpH7XT7sVQdm4RhxCGAhJH+16lwkCgGybxONSSm8CJb
         ckrFdnTXxqUt7zLrcesjQ84WLYHk5LNKM02HG2k8SAfob4vwZQXmW2sOqE4jvprXR3
         tWPBPCRUhaCU2jW5ALDmWFhWMq+rCxzWci8pH90PnV+Ewr+aRRMlYvisbpWrKO8NiL
         rPTbLAfl954xdZM5ROBWBtHjd1Bg+qAatC8RsixNgzPhN7vTv7Qc3l2N2QU5sLwRkG
         6n/g3YaDEFlQw==
Date:   Wed, 6 Apr 2022 07:23:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH 5.15 746/913] ARM: ftrace: avoid redundant loads or
 clobbering IP
Message-ID: <Yk14LhswMSlPGrmJ@sashalap>
References: <20220405070339.801210740@linuxfoundation.org>
 <20220405070402.195698649@linuxfoundation.org>
 <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
>On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
>>
>> Tweak the ftrace return paths to avoid redundant loads of SP, as well as
>> unnecessary clobbering of IP.
>>
>> This also fixes the inconsistency of using MOV to perform a function
>> return, which is sub-optimal on recent micro-architectures but more
>> importantly, does not perform an interworking return, unlike compiler
>> generated function returns in Thumb2 builds.
>>
>> Let's fix this by popping PC from the stack like most ordinary code
>> does.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop all the 32-bit ARM patches authored by me from the stable
>queues except the ones that have fixes tags. These are highly likely

I can drop you from future selections as well.

>to cause an explosion of regressions, and they should have never been
>selected, as I don't remember anyone proposing these for stable.

They were proposed by the bot last week
(https://lore.kernel.org/lkml/20220330115005.1671090-22-sashal@kernel.org/).

-- 
Thanks,
Sasha
