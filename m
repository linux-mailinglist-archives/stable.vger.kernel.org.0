Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC4606167
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiJTNU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 09:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiJTNUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 09:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8531F140DD;
        Thu, 20 Oct 2022 06:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75CC3B82755;
        Thu, 20 Oct 2022 13:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A90EC433B5;
        Thu, 20 Oct 2022 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666271989;
        bh=jsKWqw6sex5flEAQdpaxCShxbW/VjcISHfQKqdUw+a8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P7BLnUwmTIDbb47f8eoEGEGDQbdlq7NB9mkPrZd84BNm52isGS45nq1K+8+sSXWq5
         xSNVSLgsG0kXy8kv6O2anMcCv66pi4gH4lTOAOO+hXVnPdGABrfZqYvu5qYmbUzYiH
         1r1q6+Y8R5uvaAHmuXjEuYNZnLobH+L3+HeIiBitfucYnXN+V6dGprmspwAIVoxCdj
         xpgrEktxeO4ZSoRLL8PEm30FggMf1e+TrTqHrG4r07DR2z+gBBnMqJxvEEz1QBMMSZ
         LbGlJXf/eS1X6b9MupWP9VfmSQz6i1QBQb/GdK0j7WP3H4IDUEqx2HOjs12EfAaII+
         7HMIA8v8uxzqg==
Received: by mail-vk1-f174.google.com with SMTP id o28so9792056vkn.11;
        Thu, 20 Oct 2022 06:19:49 -0700 (PDT)
X-Gm-Message-State: ACrzQf3APzoBAalwMfeZreh2LtJKsjxYrXQT+7iiOiVxIM3c3VyozxAP
        zKxOexXKLuRsnPlhzdbJrv+A9F1OWz2q28/gxg==
X-Google-Smtp-Source: AMsMyM6cyxNnvi9QEJ/wzCU65VsV6e19S0B0G0O3vHqDZtWRVmtOdSAG+7qlhrYAvnHtwtK5VUmTEn64i8lpZzNOyk8=
X-Received: by 2002:a1f:29d2:0:b0:3b2:4f9c:3b5a with SMTP id
 p201-20020a1f29d2000000b003b24f9c3b5amr984670vkp.14.1666271987997; Thu, 20
 Oct 2022 06:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221018001029.2731620-1-sashal@kernel.org> <20221018001029.2731620-12-sashal@kernel.org>
In-Reply-To: <20221018001029.2731620-12-sashal@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 20 Oct 2022 08:19:39 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLCR68uCFugv8abv-1cEwbNXHgKViYO78CQA+qoZtFx9g@mail.gmail.com>
Message-ID: <CAL_JsqLCR68uCFugv8abv-1cEwbNXHgKViYO78CQA+qoZtFx9g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 12/16] of: Fix "dma-ranges" handling for bus controllers
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 7:10 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Robin Murphy <robin.murphy@arm.com>
>
> [ Upstream commit f1ad5338a4d57fe1fe6475003acb8c70bf9d1bdf ]

This was not marked with Fixes or for stable on purpose as there are
not existing devices that need it and I think there is some chance of
regressing existing devices. So please drop it for now.

Rob
