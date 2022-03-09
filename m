Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85A4D3CF7
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbiCIWdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238771AbiCIWdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89C3120F75;
        Wed,  9 Mar 2022 14:32:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D5C61BF2;
        Wed,  9 Mar 2022 22:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA96C340E8;
        Wed,  9 Mar 2022 22:32:02 +0000 (UTC)
Date:   Wed, 9 Mar 2022 22:31:59 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: Do not include __READ_ONCE() block in assembly
 files
Message-ID: <Yikq33Q9Cfhbce6F@arm.com>
References: <20220309191633.2307110-1-nathan@kernel.org>
 <CAKwvOdkrgtyE3rU8Xa2B8QQJ1ZErSTB9PDuikPF6=4D4Q80XVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkrgtyE3rU8Xa2B8QQJ1ZErSTB9PDuikPF6=4D4Q80XVQ@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 01:53:50PM -0800, Nick Desaulniers wrote:
> On Wed, Mar 9, 2022 at 11:19 AM Nathan Chancellor <nathan@kernel.org> wrote:
> > Avoid this problem by just avoiding the CONFIG_LTO=y __READ_ONCE() block
> > in asm/rwonce.h with assembly files, as nothing in that block is useful
> > to assembly files, which allows ARM_SMCCC_ARCH_WORKAROUND_3 to be
> > properly expanded with CONFIG_LTO=y builds.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when CONFIG_LTO=y")
> > Link: https://lore.kernel.org/r/20220309155716.3988480-1-maz@kernel.org/
> > Reported-by: Marc Zyngier <maz@kernel.org>
> > Acked-by: James Morse <james.morse@arm.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks for taking point on all of the BHB fallout.
> 
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the review and testing. Unfortunately I've just sent the pull
request to Linus, so didn't include your tags.

-- 
Catalin
