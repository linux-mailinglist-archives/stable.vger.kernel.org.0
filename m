Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B3553F839
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 10:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiFGIbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 04:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238371AbiFGIbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 04:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0BED244E;
        Tue,  7 Jun 2022 01:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A5FE616BD;
        Tue,  7 Jun 2022 08:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AE4C3411E;
        Tue,  7 Jun 2022 08:31:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FuzyMElt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654590662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fUt937EWiJwdxfcnA3TwhfA5LXA4pjELaJrATUg3Gno=;
        b=FuzyMEltiCFIFQUmYH95BwWbsv9Jmv2KImD60Loe0r08XydEY3ttXcvt2b44+BjRtgAm0h
        oFuS9FJbwBOXJGoKg5jenf+H/iSelcEFK9LRXllKyWlfmzzn26X8gRODeb0i+4mQwuLvsw
        xC638RdHA9p8zxSDpuTqy57YQtJHXeY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c7736b60 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 08:31:02 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2f83983782fso167380197b3.6;
        Tue, 07 Jun 2022 01:31:01 -0700 (PDT)
X-Gm-Message-State: AOAM53030pdb+b7HVxAMKm7E/41I944k4+CpQp8ktweDv0zt+LQIypYp
        F3eeQaWeXi6QZaoVEGY13X/cAl4bsJqOhQOuVT4=
X-Google-Smtp-Source: ABdhPJw/VMyA0h9d+MMv/xwmYZDFcqj0M+obhAs7O9tOWkc5LQ9u10sR+9mDVCGaUSlxaOjCKRDw5LSvVGWJ0aRCjSc=
X-Received: by 2002:a0d:cd04:0:b0:300:4784:caa3 with SMTP id
 p4-20020a0dcd04000000b003004784caa3mr30121618ywd.231.1654590660515; Tue, 07
 Jun 2022 01:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
In-Reply-To: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jun 2022 10:30:49 +0200
X-Gmail-Original-Message-ID: <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
Message-ID: <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Phil,

Thanks for testing this. Can you let me know if v1 of this works?

https://lore.kernel.org/lkml/20220602212234.344394-1-Jason@zx2c4.com/

(I'll also fashion a revert for this part of stable.)

Jason
