Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779FD507BE6
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 23:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbiDSVaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 17:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345951AbiDSVaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 17:30:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9A239827
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 14:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99427B81846
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 21:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5954C385A7;
        Tue, 19 Apr 2022 21:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650403641;
        bh=J4l6nOhwaGP9gwFmqdP8jxouA835/1GgWpS/8DKzJkg=;
        h=Date:From:To:Cc:Subject:From;
        b=k3qUvGotzVuqDlNl1O1CY7Rh+NP1XAKEDxdjSAQA6nUfeDRU1GNpC17/vPuW6jM1J
         W3H+W13+Ct2s+3btCEWGcsDnhdq5IN5tykWlsNTSWR/Vlfg36a9Gbrc4jra+sBL+wE
         TDJ3vN2A9zpm4AFLu8XDlubcD80FEXqL80xgmQpXJyF5ME5O2KusPi7conjaz6qJHr
         aiBaKhYDwdJNjz5b9fYa0Zb6S0usS655i2XDVAB5PpD9yk7OVxqjjhNwVRvGQUAMWm
         W7WJjT55au+sgRubuSHMMyfHDupZ1U2/7Gk0lSuwKIAog9fuMSTF2zf8QqWitn1zMx
         I/drdBGddnN5A==
Date:   Tue, 19 Apr 2022 14:27:19 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: Apply d799769188529abc6cbf035a10087a51f7832b6b to 5.17 and 5.15?
Message-ID: <Yl8pNxSGUgeHZ1FT@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha, and Michael,

Commit d79976918852 ("powerpc/64: Add UADDR64 relocation support") fixes
a boot failure with CONFIG_RELOCATABLE=y kernels linked with recent
versions of ld.lld [1]. Additionally, it resolves a separate boot
failure that Paul Menzel reported [2] with ld.lld 13.0.0. Is this a
reasonable backport for 5.17 and 5.15? It applies cleanly, resolves both
problems, and does not appear to cause any other issues in my testing
for both trees but I was curious what Michael's opinion was, as I am far
from a PowerPC expert.

This change does apply cleanly to 5.10 (I did not try earlier branches)
but there are other changes needed for ld.lld to link CONFIG_RELOCATABLE
kernels in that branch so to avoid any regressions, I think it is safe
to just focus on 5.15 and 5.17.

Paul, it would not hurt to confirm the results of my testing with your
setup, just to make sure I did not miss anything :)

[1]: https://github.com/ClangBuiltLinux/linux/issues/1581
[2]: https://lore.kernel.org/Yg2h2Q2vXFkkLGTh@dev-arch.archlinux-ax161/

Cheers,
Nathan
