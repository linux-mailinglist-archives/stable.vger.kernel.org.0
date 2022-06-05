Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D6753DB8F
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242526AbiFEN22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiFEN21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:28:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85F9DF3D;
        Sun,  5 Jun 2022 06:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68CADB80B1B;
        Sun,  5 Jun 2022 13:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9338C385A5;
        Sun,  5 Jun 2022 13:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654435703;
        bh=HierzychIYSfee9l8j1OTtj4tWyJ2mBt2LQfQBnykFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rUOLXX3zrCJW0VLSBgnwsV6+UDkVAMmy79GxbOk7fdLc2vwTbubEBMfk6lLCR8SP+
         4tx89jtNe0ovs1kAzbY1X0KLbrLv8vu2QysOGPHSJ1MVBmX9C4omjHic/DfechABkg
         5Bog0KunRk7wAi7E8NZ1C22JF94T2YOl8NGtdBs1JXXTQVrVfl/8G5rCQcZvxOYzE8
         on2ucRXTtqr/mL4Mm72xfxnWcR0SnR05xdeYBeHLr2kEyI/lPdKmLDZ1tak1S0A+Fe
         mVPaU3WRFvN0DN79O5iZseiyybXts2j/HgHgVK8xvYjZZwVR+1sJ0L7t1FPTCeFRCb
         E9zEkkXe/gLlA==
Date:   Sun, 5 Jun 2022 09:28:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>, mripard@kernel.org,
        wens@csie.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 4.19 16/38] drm/sun4i: Add support for D1 TCONs
Message-ID: <YpyvdSCoVwhAcpgs@sashalap>
References: <20220530134924.1936816-1-sashal@kernel.org>
 <20220530134924.1936816-16-sashal@kernel.org>
 <0f81cfb5-de3c-02eb-8d6d-e5aa1b69c439@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0f81cfb5-de3c-02eb-8d6d-e5aa1b69c439@sholland.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 09:41:59AM -0500, Samuel Holland wrote:
>Hi Sasha,
>
>On 5/30/22 8:49 AM, Sasha Levin wrote:
>> From: Samuel Holland <samuel@sholland.org>
>>
>> [ Upstream commit b9b52d2f4aafa2bd637ace0f24615bdad8e49f01 ]
>>
>> D1 has a TCON TOP, so its quirks are similar to those for the R40 TCONs.
>> While there are some register changes, the part of the TCON TV supported
>> by the driver matches the R40 quirks, so that quirks structure can be
>> reused. D1 has the first supported TCON LCD with a TCON TOP, so the TCON
>> LCD needs a new quirks structure.
>>
>> D1's TCON LCD hardware supports LVDS; in fact it provides dual-link LVDS
>> from a single TCON. However, it comes with a brand new LVDS PHY. Since
>> this PHY has not been tested, leave out LVDS driver support for now.
>>
>> Signed-off-by: Samuel Holland <samuel@sholland.org>
>> Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
>> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
>> Link: https://patchwork.freedesktop.org/patch/msgid/20220424162633.12369-14-samuel@sholland.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch adds support for hardware in a SoC that will not boot on earlier
>kernel releases, so there is no benefit to backporting the patch (to any
>previous release).

Dropped, thanks!

-- 
Thanks,
Sasha
