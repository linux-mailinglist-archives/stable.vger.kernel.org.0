Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9C6B9D3A
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCNRmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCNRmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:42:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A3A8A45;
        Tue, 14 Mar 2023 10:42:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29C8B81AB7;
        Tue, 14 Mar 2023 17:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5D1C433EF;
        Tue, 14 Mar 2023 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678815731;
        bh=QkIwxCBXFihogQPG33157WCr6YP7trAKxHMdphluvQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtA5ceaYdHCqWCzQ/SlOXCiGEwpS+dvIQhq1Es5lTHFVMPgrp3BzylxtQaibxEJe/
         1egCfWafVCbu6zntJA/uiNk2/BnTqlJ9BZz06v5DtyZqWhELaJZ3EmLXOvWHHI6+f5
         kF2QYzPbEDC+e/Gb5bj8DoHRhSoEdnUyqxzj9SuCN8wazz69Z5C+F/dQAhKGak06yh
         wsF5+NGLRVq5zDt+N+n+uwVaXd8Owz7Ezv2HRDiX1aIVC2XbkOW8EMet6eQZ0msOvR
         Bs2OKJjRrFt2dbKdRwEQtKjnSZ/YhdEAPhwxg9yZbmMmjjcsj7mQJNPMHnb6rl+pSV
         U55rHyQI9t2lg==
Date:   Tue, 14 Mar 2023 13:42:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 07/16] clk: renesas: rcar-gen3: Disable R-Car
 H3 ES1.*
Message-ID: <ZBCx8QV/CsMxiiUu@sashalap>
References: <20230305135207.1793266-1-sashal@kernel.org>
 <20230305135207.1793266-7-sashal@kernel.org>
 <CAMuHMdXLBVDPPM5ZGGV5O5uMm4R8=ZHvsgDxMxHQP2q4YKvhhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXLBVDPPM5ZGGV5O5uMm4R8=ZHvsgDxMxHQP2q4YKvhhA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 05, 2023 at 02:59:11PM +0100, Geert Uytterhoeven wrote:
>Hi Sasha,
>
>On Sun, Mar 5, 2023 at 2:52 PM Sasha Levin <sashal@kernel.org> wrote:
>> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
>>
>> [ Upstream commit b1dec4e78599a2ce5bf8557056cd6dd72e1096b0 ]
>>
>> R-Car H3 ES1.* was only available to an internal development group and
>> needed a lot of quirks and workarounds. These become a maintenance
>> burden now, so our development group decided to remove upstream support
>> for this SoC. Public users only have ES2 onwards.
>>
>> In addition to the ES1 specific removals, a check for it was added
>> preventing the machine to boot further. It may otherwise inherit wrong
>> clock settings from ES2 which could damage the hardware.
>>
>> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
>> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Link: https://lore.kernel.org/r/20230202092332.2504-1-wsa+renesas@sang-engineering.com
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch disables hardware support.  Do we really want to backport
>that to stable?
>Perhaps backporting to v6.2.y and v6.1.y is still acceptable (the next
>Renesas BSP will be based on v6.1.y LTS), but I would not recommend
>backporting to older versions.

Ack, I'll drop it from older trees. Thanks!

-- 
Thanks,
Sasha
