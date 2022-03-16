Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B4C4DB65A
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbiCPQln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiCPQll (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F896CA58;
        Wed, 16 Mar 2022 09:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AD3DB81C4D;
        Wed, 16 Mar 2022 16:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5752EC340EC;
        Wed, 16 Mar 2022 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647448824;
        bh=OdHnsPhO+nf6lRLZmvE5GdCJeP1n3slji6FMMEZeRU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FMOWEpp+AcXUUv3TA2YoGzKcajj7vY8Bvvw+nUQd5yVgHGkVQGzCAXc/NKlscblE3
         Dk9JEKyCkevxXoYKCq7iQtO5KMUFFA9LMABmkr1OCpSXvbSyqNgEXxCZ4ZlxxZDLM4
         3AQRP7tj91Klt5tzc5/BrwbzSyK1W/ZkRIYp6gbTnJn5aF95bjoHHANbN2h5Nvi96o
         m1jcIEYFQKvDoJnQ8Yp6x3qNxQMttfmX0uN3ZZmLrC5sh+L+7rS7Is+YZU36+3UYI7
         gxcj/meKs6Q9T4ZMV0LU3j+tO5c2xX5kpyUL0PKTSg7kItCxwlqtGCnBdgYOqTN+ky
         Rv12vnXYEGmWA==
Date:   Wed, 16 Mar 2022 12:40:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 10/12] gpio: Revert regression in sysfs-gpio
 (gpiolib.c)
Message-ID: <YjIS9KENmMgXQejZ@sashalap>
References: <20220316141636.248324-1-sashal@kernel.org>
 <20220316141636.248324-10-sashal@kernel.org>
 <CACRpkdZU_wv74MeRiO_bMV03Gwp=8LamsPOGMEpY8Rm-X2Aq8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACRpkdZU_wv74MeRiO_bMV03Gwp=8LamsPOGMEpY8Rm-X2Aq8w@mail.gmail.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 05:06:47PM +0100, Linus Walleij wrote:
>On Wed, Mar 16, 2022 at 3:17 PM Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
>>
>> [ Upstream commit fc328a7d1fcce263db0b046917a66f3aa6e68719 ]
>>
>> Some GPIO lines have stopped working after the patch
>> commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
>>
>> And this has supposedly been fixed in the following patches
>> commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
>> commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
>>
>> But an erratic behavior where some GPIO lines work while others do not work
>> has been introduced.
>>
>> This patch reverts those changes so that the sysfs-gpio interface works
>> properly again.
>>
>> Signed-off-by: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
>> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>
>I think you should not apply this for stable, because we will revert the revert.

Okay, I'll give it a week to soak and if the revert is in by then I can
just pick it too for the sake of completeness.

-- 
Thanks,
Sasha
