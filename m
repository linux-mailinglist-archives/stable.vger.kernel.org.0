Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB355DF34
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiF0R57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiF0R5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF47DE80
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 10:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E6E61426
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 17:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCCAC341CA;
        Mon, 27 Jun 2022 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656352669;
        bh=SGbAEy3fdHeEVcjI4t9OH0aKVgiRmHRRIPZJQ6tnnTU=;
        h=Date:From:To:Cc:Subject:From;
        b=uwtmygiZxs5dgALOqGgQQEF6+RkhJVOEmnk/7H2x297pjUtNjP1uUQXM8AI1U6/wp
         TMhIGZ9M+Mb1Eqc4B8ox/faWrAoBZkMavVLeH59W67zeaKRjUmpyt4jLSad2u/4DEw
         p8usEU6lZboMXUxUWovbi0YTh6mu6O7a7nN7E8y7pjZn1Rp6Y4+Itr3zDMMxiJl9LY
         ejfrtirswesU1lP0tKqTN9rheFVTw1I1uC0Sq6GZFVj/b5nDZIKNO6YHWvNBWzdiEm
         l/Bsr5NOtUTPVQLHi0TY4q+HxnNiI8lDFsN2jCXASAd6BssIi9sVpCc9PyJC3qag5U
         WInd07GB8W9nA==
Date:   Mon, 27 Jun 2022 10:57:47 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Apply 1e70212e031528918066a631c9fdccda93a1ffaa to 5.18
Message-ID: <Yrnvm6mwtaiKu6Rj@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit 1e70212e0315 ("hinic: Replace memcpy() with direct
assignment") to 5.18. It fixes a warning visible when building arm64 and
x86_64 allmodconfig with clang 14 and newer (and possibly other
architectures but I didn't check). This will allow CONFIG_WERROR to
remain enabled when building arm64 and x86_64 kernels with clang on 5.15
and 5.18 (other architectures and newer versions are getting there).

This change shouldn't be problematic in older kernels but the warning it
fixes won't be visible without the new FORTIFY_SOURCE changes that
landed in 5.18, so I wouldn't worry about backporting it further.

Cheers,
Nathan
