Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21BB6885B7
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 18:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjBBRrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 12:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjBBRrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 12:47:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDA129414;
        Thu,  2 Feb 2023 09:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 998ED61A73;
        Thu,  2 Feb 2023 17:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E080EC433D2;
        Thu,  2 Feb 2023 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675360029;
        bh=FEOGwAdb5NqiIIo7liFt1RCgg5NIegmvr8d2t4pzdgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=quhqcLKszKJwpqpWiSJWyP1bgJLtCCm2oUqUvhbnIgTC7CBOk5mr2FaqLfiAO9+gy
         CC8qrEHAiYlda38JGMaxTFdohvS1vH/tFdpXqZha2UKaI71d3zzANPxWONgYDlDbJu
         GCCrXf72MTvbqo5TwtzlURWeeyTMawcX5qMBE7J5NScj0gnET2muYuZ8egO4GQ4TMa
         JQGo9f9s8oPJxfeAPxDpiWNUhbwk7/7hi08PkiqjPY1fqJbzApT5s5t8eLEtP7zazW
         BmqmMdYcWbbTeyXT6gtzQx9rXe1QAriDLuW2JIoJr3nTd32v+vobdSkSuHBqCWayBx
         1NY2ZEJcU6HQQ==
Date:   Thu, 2 Feb 2023 12:47:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] Backport oops_limit to 5.4
Message-ID: <Y9v3G6UantaCo29G@sashalap>
References: <20230202044255.128815-1-ebiggers@kernel.org>
 <Y9vwBL2+NWtwMnA4@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y9vwBL2+NWtwMnA4@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 12:16:52PM -0500, Sasha Levin wrote:
>On Wed, Feb 01, 2023 at 08:42:38PM -0800, Eric Biggers wrote:
>>This series backports the patchset
>>"exit: Put an upper limit on how often we can oops"
>>(https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
>>to 5.4, as recommended at
>>https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
>>This follows the backports to 5.10 and 5.15 which already released.
>>
>>This required backporting various prerequisite patches.
>>
>>I've tested that oops_limit and warn_limit work correctly on x86_64.
>
>Queued up all 3 backports, thanks!

... and proceeded to drop the 4.19 and 4.14 backports which fail to
build:

mm/kasan/report.c: In function 'kasan_end_report':
mm/kasan/report.c:175:16: error: 'KASAN_BIT_MULTI_SHOT' undeclared (first use in this function)
   175 |  if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))

-- 
Thanks,
Sasha
