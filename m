Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE55544E36
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343561AbiFIN4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245514AbiFIN4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:56:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FB42A979;
        Thu,  9 Jun 2022 06:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BE4FB82DF3;
        Thu,  9 Jun 2022 13:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92084C34114;
        Thu,  9 Jun 2022 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654782982;
        bh=ZFAylpFPdXpnDgSAOTeAWTe07vZUdY80vnrc0rD1Zwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pKwWuA/1IrL+tANFoM3hAMgCOccR0jKv2caj0MODqpuZlOHNU/KEUBqR5hSQiWlvc
         +51OqII6lI735wAn8N59w2LN+7z4dGBsR+uxyictvVvan6GuWwsfzauzMYN+1siRKn
         tC6xjUeJashWP6i3+r+T8y7Wg4f/NaKb/eKFe+K0ckofL482ZpZKP99J6ryTJwjFwG
         dUFk3vD/mKIHjE/E5OKhq/ZJbcXX41V7zFZpJPHQwJqKqXT7NkSPp0c0F386k3UfY8
         E/3qGvT3ruyAA8YlhgVzvslW2VOXt5x4zJ9kp465zWhgC7eN2rQJndGuF4/AXWK7QL
         favHAhRYH8vLA==
Date:   Thu, 9 Jun 2022 09:56:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Denis Ciocca <denis.ciocca@st.com>, linus.walleij@linaro.org,
        lars@metafoo.de, andy.shevchenko@gmail.com, aardelean@deviqon.com,
        cai.huoqing@linux.dev, linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.18 03/68] iio: st_sensors: Add a local lock for
 protecting odr
Message-ID: <YqH8BTZ240DeZ9fq@sashalap>
References: <20220607174846.477972-1-sashal@kernel.org>
 <20220607174846.477972-3-sashal@kernel.org>
 <20220608102651.000035b0@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220608102651.000035b0@Huawei.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 10:26:51AM +0100, Jonathan Cameron wrote:
>On Tue,  7 Jun 2022 13:47:29 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Miquel Raynal <miquel.raynal@bootlin.com>
>>
>> [ Upstream commit 474010127e2505fc463236470908e1ff5ddb3578 ]
>>
>> Right now the (framework) mlock lock is (ab)used for multiple purposes:
>> 1- protecting concurrent accesses over the odr local cache
>> 2- avoid changing samplig frequency whilst buffer is running
>>
>> Let's start by handling situation #1 with a local lock.
>>
>> Suggested-by: Jonathan Cameron <jic23@kernel.org>
>> Cc: Denis Ciocca <denis.ciocca@st.com>
>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>> Link: https://lore.kernel.org/r/20220207143840.707510-7-miquel.raynal@bootlin.com
>> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi Sasha,
>
>This one is a cleanup rather than a fix. It's part of a long term move to stop
>drivers using an internal lock (which works, but limits our ability to
>change the core code).  No problem backporting it if it makes
>taking some other fix easier, but I'm not immediately seeing such a patch.

Yup, it's not a dependency. I'll drop it.

-- 
Thanks,
Sasha
