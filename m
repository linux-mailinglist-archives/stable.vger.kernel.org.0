Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1FC6A3E1B
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 10:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjB0JRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 04:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjB0JRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 04:17:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB45921A3D;
        Mon, 27 Feb 2023 01:12:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784EB60D45;
        Mon, 27 Feb 2023 09:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58DCC433D2;
        Mon, 27 Feb 2023 09:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677489142;
        bh=M73yfffVGAh8sWbCGSQU9guO48iLvbYQo53igIT8KqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=umkYI4Dkv7vJbXYspcgvjCpo61vd3SstOYuL5CeMkshATpTO5yxYQ5DvALqDlaZ93
         4n7hML65CU4ModwE9uR1oe8qjyuJ2Y6nkjDjRBlcMJmSbed4LUKNRhdJeWheqD5/B5
         KQMX8CmhKbRjtNN7kLYx8NQj9ZhXXOWLVoOYWBDuXTGQfM+9C8g/FrG8hVrbcN/N3N
         GZO/hje0SWhY216fAbwCQfGK/8t21VYP9ogPcZ/t/5r4BlH3Djvr0W1iUQjVy10psC
         9JEYk0h9cpn4BcxVaVee4UKmB+DRwSR9fH4Zr+1ZilFCf8ZBwcwsWdAJOUgws9zmAx
         JTX9q/CCS/Daw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pWZYo-0006Zu-DS; Mon, 27 Feb 2023 10:12:42 +0100
Date:   Mon, 27 Feb 2023 10:12:42 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        robdclark@gmail.com, quic_abhinavk@quicinc.com, airlied@gmail.com,
        daniel@ffwll.ch, swboyd@chromium.org, johan+linaro@kernel.org,
        quic_sbillaka@quicinc.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 6.1 18/58] drm/msm/dp: Remove INIT_SETUP delay
Message-ID: <Y/x0CpMmNV6pJlZB@hovoldconsulting.com>
References: <20230227020457.1048737-1-sashal@kernel.org>
 <20230227020457.1048737-18-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227020457.1048737-18-sashal@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 26, 2023 at 09:04:16PM -0500, Sasha Levin wrote:
> From: Bjorn Andersson <quic_bjorande@quicinc.com>
> 
> [ Upstream commit e17af1c9d861dc177e5b56009bd4f71ace688d97 ]
> 
> During initalization of the DisplayPort controller an EV_HPD_INIT_SETUP
> event is generated, but with a delay of 100 units. This delay existed to
> circumvent bug in the QMP combo PHY driver, where if the DP part was
> powered up before USB, the common properties would not be properly
> initialized - and USB wouldn't work.
> 
> This issue was resolved in the recent refactoring of the QMP driver,
> so it's now possible to remove this delay.
> 
> While there is still a timing dependency in the current implementation,
> test indicates that it's now possible to boot with an external display
> on USB Type-C and have the display power up, without disconnecting and
> reconnecting the cable.
> 
> Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
> Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Patchwork: https://patchwork.freedesktop.org/patch/518729/
> Link: https://lore.kernel.org/r/20230117172951.2748456-1-quic_bjorande@quicinc.com
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is not a bug fix and should not be backported.

Johan
