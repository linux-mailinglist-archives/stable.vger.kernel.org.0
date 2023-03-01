Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9213E6A6E1F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 15:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCAOP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 09:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCAOP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 09:15:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035482CC47;
        Wed,  1 Mar 2023 06:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D158612D8;
        Wed,  1 Mar 2023 14:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BDCC433D2;
        Wed,  1 Mar 2023 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677680155;
        bh=67yGKOOelLpeOlZKR/e1mlM7y1TTA9eOt92/JiaBs8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QiiYn58qB3G8xGjuvfAilzxQMkLAq9gcG8f3uZ1/YEfZhCe66xYzB7SOhLATl8PAn
         RqdpSp5nfLMghhz+gDvEDj+5TXJJfxSQrQMVjyKWOTMBMUci5p4acb6NK07/m0NKhJ
         xo6rISBtTeUm2tLzrGxi9A8yGgfSkCn/AtUIRrGm3dZ7YAFzDPeVK1feOjAJh+69i1
         OjBzxpWuMb9MYIbUYnXW4xPemQCQpbgOpKttOY8M+eHAKdy1Qwo2gTeNPm8Wzsviqx
         P2vlitqOYsj37CBqm7WMVJkX/aXrU6xXTwM3rWYHabOce3Lz2edEsX7Bg/LjWUgnkQ
         NIGDDiIu/m5Rg==
Date:   Wed, 1 Mar 2023 09:15:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        robdclark@gmail.com, quic_abhinavk@quicinc.com, airlied@gmail.com,
        daniel@ffwll.ch, swboyd@chromium.org, johan+linaro@kernel.org,
        quic_sbillaka@quicinc.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 6.2 18/60] drm/msm/dp: Remove INIT_SETUP delay
Message-ID: <Y/9eGRUEYyN8oroU@sashalap>
References: <20230227020045.1045105-1-sashal@kernel.org>
 <20230227020045.1045105-18-sashal@kernel.org>
 <Y/xz9IcSsc8mau9s@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/xz9IcSsc8mau9s@hovoldconsulting.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 10:12:20AM +0100, Johan Hovold wrote:
>On Sun, Feb 26, 2023 at 09:00:03PM -0500, Sasha Levin wrote:
>> From: Bjorn Andersson <quic_bjorande@quicinc.com>
>>
>> [ Upstream commit e17af1c9d861dc177e5b56009bd4f71ace688d97 ]
>>
>> During initalization of the DisplayPort controller an EV_HPD_INIT_SETUP
>> event is generated, but with a delay of 100 units. This delay existed to
>> circumvent bug in the QMP combo PHY driver, where if the DP part was
>> powered up before USB, the common properties would not be properly
>> initialized - and USB wouldn't work.
>>
>> This issue was resolved in the recent refactoring of the QMP driver,
>> so it's now possible to remove this delay.
>>
>> While there is still a timing dependency in the current implementation,
>> test indicates that it's now possible to boot with an external display
>> on USB Type-C and have the display power up, without disconnecting and
>> reconnecting the cable.
>>
>> Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
>> Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
>> Patchwork: https://patchwork.freedesktop.org/patch/518729/
>> Link: https://lore.kernel.org/r/20230117172951.2748456-1-quic_bjorande@quicinc.com
>> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This is not a bug fix and should not be backported.

Ack, I'll drop all the INIT_SETUP patches. Thanks!

-- 
Thanks,
Sasha
