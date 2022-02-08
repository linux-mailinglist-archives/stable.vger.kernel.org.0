Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D4E4AE037
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbiBHR7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384517AbiBHR7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:59:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC85C0612B8;
        Tue,  8 Feb 2022 09:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BF161766;
        Tue,  8 Feb 2022 17:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9A2C36AE2;
        Tue,  8 Feb 2022 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644343137;
        bh=MBI7NcGaRtsLJ4Pa/QylcWfb7IB5aUeZAVi7a5i/U9Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p6DEwQnIl3YhK1HFbTGMK8DSmIl8nW3MbznTt05hNhPJWq0n8pkfK7mUo8a+0Osla
         OH7RLM72JStbspEhs9qS6HeMzpZxc5Rf6Er99NYJtsJB/veJAtYAvO4/Q4qJp0txHL
         bOvnHT2RUaAplstCYD0q6XSP4HyQE2ddsywU9ZBnEECo8VOyUFKQxO3h9dWRa4ZfD8
         txzNMyRcALiZ88MfMAq0Fdy8o/KbwiL00W+v7fYsEa+1lxLWboyzC5ojZyPsHEFOuz
         NDDmzjajLBhvhLeOdmgInTpA+kEdYCwSKvycbwY8cArFr5pBavP8ndLVo3PVuYc7Xv
         RfP2EeI1i5SNA==
Received: by mail-yb1-f178.google.com with SMTP id bt13so28190773ybb.2;
        Tue, 08 Feb 2022 09:58:57 -0800 (PST)
X-Gm-Message-State: AOAM532XlD+q+A3QZbDl1ak9mlwLF18iR7E7+DkZR05csLTF97j+OLr5
        vmUxkMoCjTdz8sc0HPzCM8bqCwMUlCaCFR1geuM=
X-Google-Smtp-Source: ABdhPJx8LaFqRFjjwTHBownYBNXWetg2JZUqOIHFR4zdRIGbwOGj40Lyaco5MlcNX5+O0Ug/avD3K4UmZ8yfQImSP18=
X-Received: by 2002:a81:6502:: with SMTP id z2mr6222051ywb.148.1644343136961;
 Tue, 08 Feb 2022 09:58:56 -0800 (PST)
MIME-Version: 1.0
References: <20220208165050.13893-1-dmueller@suse.de>
In-Reply-To: <20220208165050.13893-1-dmueller@suse.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Feb 2022 09:58:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4wcfoiYHY4JXSME3K0ZJtVgo9hC37vS8YqAHxe_u2=Fw@mail.gmail.com>
Message-ID: <CAPhsuW4wcfoiYHY4JXSME3K0ZJtVgo9hC37vS8YqAHxe_u2=Fw@mail.gmail.com>
Subject: Re: [PATCH v2] lib/raid6/test: fix multiple definition linking error
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 8, 2022 at 8:51 AM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> GCC 10+ defaults to -fno-common, which enforces proper declaration of
> external references using "extern". without this change a link would
> fail with:
>
>   lib/raid6/test/algos.c:28: multiple definition of `raid6_call';
>   lib/raid6/test/test.c:22: first defined here
>
> the pq.h header that is included already includes an extern declaration
> so we can just remove the redundant one here.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dirk M=C3=BCller <dmueller@suse.de>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

Applied to md-next. Thanks!

Song
