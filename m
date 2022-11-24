Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB9637D43
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 16:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKXPvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 10:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKXPvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 10:51:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F9913C735;
        Thu, 24 Nov 2022 07:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361AAB82870;
        Thu, 24 Nov 2022 15:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DE7C433D6;
        Thu, 24 Nov 2022 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669305068;
        bh=s+OXtssHmkAV/8o5aF5tW5Nh7Fk9Rc3WObTGHXe16+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YA4gD3oKppDGX2Co0Q/Uy/hSzkCs8LcBN9zRrgTorOh9jjK8b0IZxUgwlhxyZUXrw
         qsVUcWlospWJrpHYtDLxyIBGFgy2WcjgTU/kUD5mMLq1GiBV3u2IxQGBtcc/59k5sy
         FYankUYfq1X1MtN1c0o1lWpIFJcO3xKveaoVi3mjQjmNmi+Zkkc2VUkBLiGf8DyzGy
         WpkD3gVHMLD5xkw+qjMGbXGTtGz+EC0B/Ucyo7DYPUS5gUdp1hMv0VqfE9CnKy/wOP
         b3eIYNxnpQCHBUd/S4mr6o1DyhP5NhVO7ICOjRXJt71ucKRFBi53APphtFygcPswKa
         ORQQaABm6ymiA==
Date:   Thu, 24 Nov 2022 10:51:06 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.0 13/44] clocksource/drivers/hyperv: add data
 structure for reference TSC MSR
Message-ID: <Y3+S6j4GW0RrHgB2@sashalap>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-13-sashal@kernel.org>
 <SN6PR2101MB1693A83DF44A95B439532F9DD7089@SN6PR2101MB1693.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <SN6PR2101MB1693A83DF44A95B439532F9DD7089@SN6PR2101MB1693.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 19, 2022 at 05:37:16AM +0000, Michael Kelley (LINUX) wrote:
>From: Sasha Levin <sashal@kernel.org> Sent: Friday, November 18, 2022 6:11 PM
>>
>> From: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
>>
>> [ Upstream commit 4ad1aa571214e8d6468a1806794d987b374b5a08 ]
>>
>> Add a data structure to represent the reference TSC MSR similar to
>> other MSRs. This simplifies the code for updating the MSR.
>>
>> Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
>> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>> Link: https://lore.kernel.org/all/20221027095729.1676394-2-anrayabh@linux.microsoft.com/
>> Signed-off-by: Wei Liu <wei.liu@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Sasha -- I don't think this patch needs to be backported to any stable versions.  Anirudh
>or Wei Liu, can you confirm?  The patch is more about enabling a new scenario than fixing a bug.

Ack, I'll drop both of the patches you've pointed out. Thanks!

-- 
Thanks,
Sasha
