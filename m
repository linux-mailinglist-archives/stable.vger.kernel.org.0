Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D886E17A6
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 00:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDMWnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDMWnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 18:43:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8099A18B;
        Thu, 13 Apr 2023 15:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1456A60F0C;
        Thu, 13 Apr 2023 22:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3638BC433EF;
        Thu, 13 Apr 2023 22:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681425828;
        bh=MYkqVonKvDFOQP8GDOdu5yaz94D6JHfiMpL3GBFKLOY=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Q3cxOEAyehfmM8fYpA0nmae+5w4p6y47VjFokF0BALuO51fwHu52wxSgbzSmVMFQe
         4T+9uldwJK6FRoJp3bcBKFphsPB/Zf7p5/tMceW+czJvkBwtvgdfo6u6Z1mFqze4ye
         5bBHQYAbrMrlItmVT/YZrwk6ZRcDwcKbPnXK4C/Y7M4jba6jGrXHxhS0NVVpQ+eptL
         hLtzDMRg3f/hNuKgo3hWkWKvFxWREqAjwEszVFU5MbAaf97tXdagO7lgXYFuvRfeHO
         sY14swGGUmdZxhllTF2KG55ZyczNXaQ3cQiFugbaowww2gvanq/Is/WCodoytt0woW
         k6OPYdc0s1hAg==
Message-ID: <8b602852596974df384b2d7088cadd64.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230413-critter-synopsis-dac070a86cb4@spud>
References: <20230413-critter-synopsis-dac070a86cb4@spud>
Subject: Re: [PATCH v1] clk: microchip: fix potential UAF in auxdev release callback
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     conor@kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        stable@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org
To:     Conor Dooley <conor@kernel.org>
Date:   Thu, 13 Apr 2023 15:43:45 -0700
User-Agent: alot/0.10
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Conor Dooley (2023-04-13 15:20:45)
> From: Conor Dooley <conor.dooley@microchip.com>
>=20
> Similar to commit 1c11289b34ab ("peci: cpu: Fix use-after-free in
> adev_release()"), the auxiliary device is not torn down in the correct
> order. If auxiliary_device_add() fails, the release callback will be
> called twice, resulting in a UAF. Due to timing, the auxdev code in this
> driver "took inspiration" from the aforementioned commit, and thus its
> bugs too!
>=20
> Moving auxiliary_device_uninit() to the unregister callback instead
> avoids the issue.
>=20
> CC: stable@vger.kernel.org
> Fixes: b56bae2dd6fd ("clk: microchip: mpfs: add reset controller")
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---

Applied to clk-next
