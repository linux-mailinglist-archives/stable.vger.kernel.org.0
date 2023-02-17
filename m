Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1369A82A
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 10:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjBQJds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 04:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBQJdr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 17 Feb 2023 04:33:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729124B507;
        Fri, 17 Feb 2023 01:33:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A41C6177E;
        Fri, 17 Feb 2023 09:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9DAC433D2;
        Fri, 17 Feb 2023 09:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676626424;
        bh=uPVlv+pHe64pBsOjLmDQ2Aw4nP8vMhW/wtzTGYyF3ow=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=b0HOwVh3Bo8OI+wFQGQB34SSwmsSN79Bd2cf9SsFmcF1rIU4rkeV9U4J1CqQa/Ghl
         ahug2WXx4sBvCmXYiaaHLvv+FLt+1PJ4mq0OdzSGOcSuaTTTTvp8JeFOW7bCi3t8TM
         N0y6Y273NVdCtjcBc704UC/GqMoGk3v7O9yq5MJhct8l8Q8cy/UAU7m337xEhWWcDf
         wfU8DjDw1X185N5c488bwuJlz8aBLfEIgWOs0s1JUG+ZOvOq+8tSWqggAOljNVZReF
         jzDx+8JCjr5PXiQLWHZcd5B0JBOAUO1gkey31uhjFuG/t/HjTyFDdrRaNXItM+zS4Y
         1CoSMmAi4MI6g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for-6.3] wifi: rtw88: use RTW_FLAG_POWERON flag to prevent
 to
 power on/off twice
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230216053633.20366-1-pkshih@realtek.com>
References: <20230216053633.20366-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <tony0620emma@gmail.com>, <Stable@vger.kernel.org>,
        <pmw.gover@yahoo.co.uk>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167662641796.23451.10955002465358149127.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 09:33:43 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Use power state to decide whether we can enter or leave IPS accurately,
> and then prevent to power on/off twice.
> 
> The commit 6bf3a083407b ("wifi: rtw88: add flag check before enter or leave IPS")
> would like to prevent this as well, but it still can't entirely handle all
> cases. The exception is that WiFi gets connected and does suspend/resume,
> it will power on twice and cause it failed to power on after resuming,
> like:
> 
>   rtw_8723de 0000:03:00.0: failed to poll offset=0x6 mask=0x2 value=0x2
>   rtw_8723de 0000:03:00.0: mac power on failed
>   rtw_8723de 0000:03:00.0: failed to power on mac
>   rtw_8723de 0000:03:00.0: leave idle state failed
>   rtw_8723de 0000:03:00.0: failed to leave ips state
>   rtw_8723de 0000:03:00.0: failed to leave idle state
>   rtw_8723de 0000:03:00.0: failed to send h2c command
> 
> To fix this, introduce new flag RTW_FLAG_POWERON to reflect power state,
> and call rtw_mac_pre_system_cfg() to configure registers properly between
> power-off/-on.
> 
> Reported-by: Paul Gover <pmw.gover@yahoo.co.uk>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217016
> Fixes: 6bf3a083407b ("wifi: rtw88: add flag check before enter or leave IPS")
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

4a267bc5ea8f wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230216053633.20366-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

