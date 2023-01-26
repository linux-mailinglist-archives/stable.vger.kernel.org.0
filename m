Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A1667C24E
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 02:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjAZBWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 20:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjAZBWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 20:22:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E973A64DA3;
        Wed, 25 Jan 2023 17:22:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B90ADB80DC0;
        Thu, 26 Jan 2023 01:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E83DC433D2;
        Thu, 26 Jan 2023 01:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674696110;
        bh=kmOdCPqq89Jrl2dOmzpIZUShpXw3FveHTYinnBSWHzM=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=hlsxJyly7mfAQflpYGE2TZ9rXWWWD+SxCtqOZlaqrf2+xEaruJU1JQe+yfo6jDG3o
         DCCP1iB+1BWfJNysdpcoFOzWFrhI2N9P7n5U1SqvvtmdKg3fLHb+GHvc8LKZc3qN0E
         ci67SNmsUZkJ9D42449ibLaCwmoE3cCxHv0bO9AZG4U106iI8gMVVlvAFeEZrjtxYM
         eotb9InFzUcRpbUYQU134YE6Cy/iATzRCsxiv6Y4l4CZrGCi5T5QRBckcAIrOcHCi3
         cxU5BA+K+3suaEhySqK1yax8a0RMc6LQb1d+vTKHja8P3HuzdhEgO3guAWedDRnFSm
         Om4DleJtfhPTg==
Message-ID: <a6e30b47b574e3fea568931862bcc1a6.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221214123704.7305-1-paul@crapouillou.net>
References: <20221214123704.7305-1-paul@crapouillou.net>
Subject: Re: [PATCH] clk: ingenic: jz4760: Update M/N/OD calculation algorithm
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
To:     Michael Turquette <mturquette@baylibre.com>,
        Paul Cercueil <paul@crapouillou.net>
Date:   Wed, 25 Jan 2023 17:21:48 -0800
User-Agent: alot/0.10
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Paul Cercueil (2022-12-14 04:37:04)
> The previous algorithm was pretty broken.
>=20
> - The inner loop had a '(m > m_max)' condition, and the value of 'm'
>   would increase in each iteration;
>=20
> - Each iteration would actually multiply 'm' by two, so it is not needed
>   to re-compute the whole equation at each iteration;
>=20
> - It would loop until (m & 1) =3D=3D 0, which means it would loop at most
>   once.
>=20
> - The outer loop would divide the 'n' value by two at the end of each
>   iteration. This meant that for a 12 MHz parent clock and a 1.2 GHz
>   requested clock, it would first try n=3D12, then n=3D6, then n=3D3, then
>   n=3D1, none of which would work; the only valid value is n=3D2 in this
>   case.
>=20
> Simplify this algorithm with a single for loop, which decrements 'n'
> after each iteration, addressing all of the above problems.
>=20
> Fixes: bdbfc029374f ("clk: ingenic: Add support for the JZ4760")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---

Applied to clk-fixes
