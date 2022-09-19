Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F351F5BD73A
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 00:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiISWYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 18:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiISWYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 18:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889C526F6;
        Mon, 19 Sep 2022 15:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E380761F25;
        Mon, 19 Sep 2022 22:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F475C433C1;
        Mon, 19 Sep 2022 22:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663626283;
        bh=WeViwtRYiEct6JdkRg0/EHBTsvanzK6bAY0e0FVZfUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=utD7UhZBPjczB52yx2dxtW2yedxqPwZC5xsd0tqkBoV54V6mqBNKn0MKQGfXYFlsA
         v/F5gLfMu/+ypzH9OTdsMuyDzvgR/Y9GkyHpYpGevzDUy5Ru/snowxIpPwQAoN83pY
         rbevGieIEK1x8wnA6vxZhGGiCA5VQ8xBbjE/Mi1Up/lvLDSwGwr1hhlY7/5xUZHMII
         LzS493VE2b70za2AGvpZqZ9nouIGb91AIaqb6F3flNBR8oS0g5kWxR54J372uGa/I7
         z28dNGPwHC/2qBSe6vaa6U1ifYW35h1+WwN1GbXZwSTUl7q2lSuH7ch0YFslkBO1fQ
         kjFGIK2Tbkkbg==
Date:   Mon, 19 Sep 2022 18:24:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 22/41] video: fbdev: pxa3xx-gcu: Fix integer
 overflow in pxa3xx_gcu_write
Message-ID: <YyjsKkg+qG5ieCAC@sashalap>
References: <20220628022100.595243-1-sashal@kernel.org>
 <20220628022100.595243-22-sashal@kernel.org>
 <20220919082143.g4gn5ssbzolnc57b@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220919082143.g4gn5ssbzolnc57b@altlinux.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 19, 2022 at 11:21:43AM +0300, Vitaly Chikunov wrote:
>On Mon, Jun 27, 2022 at 10:20:41PM -0400, Sasha Levin wrote:
>> From: Hyunwoo Kim <imv4bel@gmail.com>
>>
>> [ Upstream commit a09d2d00af53b43c6f11e6ab3cb58443c2cac8a7 ]
>>
>> In pxa3xx_gcu_write, a count parameter of type size_t is passed to words of
>> type int.  Then, copy_from_user() may cause a heap overflow because it is used
>> as the third argument of copy_from_user().
>
>Why this commit is still not in the stable branches?

Mostly because it's not tagged for stable.

But really, looks like I've missed a batch a few months ago, I can push
it for the next release cycle.

>Isn't this is the fix for CVE-2022-39842[1]?

How the heck did this thing get a CVE?

-- 
Thanks,
Sasha
