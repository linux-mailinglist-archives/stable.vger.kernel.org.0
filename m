Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C095049A4
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 23:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiDQVgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 17:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiDQVgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 17:36:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9396A13F17;
        Sun, 17 Apr 2022 14:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13A62B80CBE;
        Sun, 17 Apr 2022 21:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86589C385A4;
        Sun, 17 Apr 2022 21:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650231209;
        bh=6qcNJcVy5PMZaik/AXmASsHLrpgx9xdYiTGeqrVUfqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UPbEGMlL1SoYoeGuWyHFUE2DEgY4TWH95SgRJfjx4qdmeO6u4bqONa+Wz0/VXUGJK
         x2qkuTkP83j1KC3Xyk28hOtR22HMLJfkGhk4aoKZogHxbgYELho0KrIvXWWKHDHR1s
         tgjA4FQ/9Mneyo+WlD/1GSplPVKzHS24XVuqCyf3OsSusqsBIKrPEI6hffPyiPB8Ky
         /C9KZk/rd/3LP4gk1ryqej1sckWtjjZfoVcGcoRfZA5yfwps28vVs8/z6/9leFcHai
         PGbNc0+/PEh3qW/E4BgMPvWeZ8uctZ9U4fIz25JSLt/KTR2XjxHBTybwFwhls2ITtz
         gtN4lEkFm9uZw==
Date:   Sun, 17 Apr 2022 17:33:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        linux-spi@vger.kernel.org, Pratyush Yadav <p.yadav@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 34/49] spi: cadence-quadspi: fix protocol
 setup for non-1-1-X operations
Message-ID: <YlyHqKVBC9u1F9xS@sashalap>
References: <20220412004411.349427-1-sashal@kernel.org>
 <20220412004411.349427-34-sashal@kernel.org>
 <d618fc184f162b1da8d75729b5939bed52308040.camel@ew.tq-group.com>
 <YlVrbR6Giy2OXe1R@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YlVrbR6Giy2OXe1R@sirena.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 01:07:09PM +0100, Mark Brown wrote:
>On Tue, Apr 12, 2022 at 01:49:19PM +0200, Matthias Schiffer wrote:
>
>Please don't top post, reply in line with needed context.  This allows
>readers to readily follow the flow of conversation and understand what
>you are talking about and also helps ensure that everything in the
>discussion is being addressed.
>
>> what's your plan regarding this patch and the other patch I sent [1]? I
>> think there has been some confusion regarding which solution we want to
>> backport to stable kernels (well, at least I'm confused...)
>
>Well, it's up to the stable people what they choose to backport -
>they're generally fairly aggressive about what they pick up so I guess
>they want to take this one?
>
>> I'm fine with this patch getting backported, but in that case [1]
>> doesn't make sense anymore (in fact I expected this patch to be dropped
>> for now when I submitted [1], due to Pratyush Yadav's concerns).
>
>> [1] https://patchwork.kernel.org/project/spi-devel-general/patch/20220406132832.199777-1-matthias.schiffer@ew.tq-group.com/
>
>For the benefit of those playing at home that's "spi: cadence-quadspi:
>fix incorrect supports_op() return value".  It's much more the sort of
>thing I'd expect to see backported to stable so it seems good from that
>point of view.

I'm a bit confused as I don't see the other patch in Linus's tree?

I'll queue this one up then...

-- 
Thanks,
Sasha
