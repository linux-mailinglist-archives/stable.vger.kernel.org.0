Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14036A4570
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 16:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjB0PAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 10:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjB0PAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 10:00:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDF9659F;
        Mon, 27 Feb 2023 06:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EEE3B80D53;
        Mon, 27 Feb 2023 14:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064B2C4339E;
        Mon, 27 Feb 2023 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677509988;
        bh=cpGiJHjSdLQyBJPnVBT9lZXyxg6+w4yV3JfgqD66YBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cnrke0HLcDZeNsJOS+SYEI++TSqQ4QvJH9CrHpftcmK2MlcOhqTdtrJQTKe9frBcC
         tAf+FU8mm4XeV2lzvP0nI3yT/BkjcNGFtxznn7own2FhWj9Xuf4cQSt98fk7fXFMlY
         KUvJrbwEOqT9hsca08pJszaPVaQjnHjKri/MV4v3C/46VmkE34n50AsTJmxAxWt4mV
         zJUGk3bGlPGXFWO186mLthpScPWhVHs7abouNt1ayBwtdT+tpkVZma+oCRq6thDzlJ
         Vo9lOZKpfz1ohFaJZ4GjxXwVsuzjlUd4F3ZlYy+UPfEnvk+1eNTRNQ/A26iKONNes7
         W9B5J8WmETHrA==
Date:   Mon, 27 Feb 2023 09:59:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Allen Ballway <ballway@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, groeck@chromium.org,
        alistair@alistair23.me, dmitry.torokhov@gmail.com,
        jk@codeconstruct.com.au, Jonathan.Cameron@huawei.com,
        cmo@melexis.com, u.kleine-koenig@pengutronix.de,
        linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 10/25] HID: multitouch: Add quirks for
 flipped axes
Message-ID: <Y/zFYpxtkBmNmFLf@sashalap>
References: <20230227020855.1051605-1-sashal@kernel.org>
 <20230227020855.1051605-10-sashal@kernel.org>
 <20230227132300.4a3c3fad@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230227132300.4a3c3fad@endymion.delvare>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 01:23:00PM +0100, Jean Delvare wrote:
>Hi Sasha,
>
>On Sun, 26 Feb 2023 21:08:33 -0500, Sasha Levin wrote:
>> From: Allen Ballway <ballway@chromium.org>
>>
>> [ Upstream commit a2f416bf062a38bb76cccd526d2d286b8e4db4d9 ]
>>
>> Certain touchscreen devices, such as the ELAN9034, are oriented
>> incorrectly and report touches on opposite points on the X and Y axes.
>> For example, a 100x200 screen touched at (10,20) would report (90, 180)
>> and vice versa.
>>
>> This is fixed by adding device quirks to transform the touch points
>> into the correct spaces, from X -> MAX(X) - X, and Y -> MAX(Y) - Y.
>>
>> Signed-off-by: Allen Ballway <ballway@chromium.org>
>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/hid/hid-multitouch.c             | 39 ++++++++++++++++++---
>>  drivers/hid/hid-quirks.c                 |  6 ++++
>>  drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 43 ++++++++++++++++++++++++
>>  drivers/hid/i2c-hid/i2c-hid.h            |  3 ++
>>  4 files changed, 87 insertions(+), 4 deletions(-)
>> (...)
>
>Second rule of acceptance for stable patches:
>
> - It cannot be bigger than 100 lines, with context.
>
>Clearly not met here.

About a quarter of stable commits in the last 12 months breat the rule
above.

>To me, this commit is something distributions may want to backport if
>their users run are likely to run the affected hardware. But it's out
>of scope for stable kernel branches.

Why? We explicitly call out new device IDs and quirks in the same doc
you quoted the 100 line rule from.

-- 
Thanks,
Sasha
