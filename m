Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E306053FD06
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiFGLL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243084AbiFGLKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6D39BAC2;
        Tue,  7 Jun 2022 04:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 606B5B81F67;
        Tue,  7 Jun 2022 11:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A165C385A5;
        Tue,  7 Jun 2022 11:09:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hM6inLcZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654600148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=05ZDRn+9Kxgpo8QsxBj7Nm6masp/GCwnWMrtg/75p8k=;
        b=hM6inLcZrJ1hIf172CEMGMg9q7w51oxf1fdo7MyCz3oI2e8YPF6gl3TlgarLeGMOeSCaFg
        CfpUSNbYSgh4KAtKsvNlBah8XYtju4r2JNDjHHGMVAY6LkxZgcRUpxcE9RK8pqNGiWbaFD
        DY6bVkCn4P8Kh8+RGz9tkxNK0LnZ0dg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 04c485fc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 11:09:08 +0000 (UTC)
Date:   Tue, 7 Jun 2022 13:09:03 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <Yp8xz0gfsRKgSO/n@zx2c4.com>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
 <Yp8WBaqr+sLInNnc@kroah.com>
 <c47c42e3-1d56-5859-a6ad-976a1a3381c6@raspberrypi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c47c42e3-1d56-5859-a6ad-976a1a3381c6@raspberrypi.com>
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

On Tue, Jun 07, 2022 at 12:04:13PM +0100, Phil Elwell wrote:
> A clean 5.15.45 boots cleanly, whereas a downstream kernel shows the static key 
> warning (but it does go on to boot). The significant difference is that our 
> defconfigs set CONFIG_RANDOM_TRUST_BOOTLOADER=y - defining that on top of 
> multi_v7_defconfig demonstrates the issue on a clean 5.15.45. Conversely, not 
> setting that option in a downstream kernel build avoids the warning

Ah, that makes sense. Note that I've got a patch out for changing that
defconfig as well to be Y, which means the CI will catch this sort of
thing in the future.

Jason
