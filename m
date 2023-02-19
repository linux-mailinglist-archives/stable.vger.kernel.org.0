Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F157D69BEB0
	for <lists+stable@lfdr.de>; Sun, 19 Feb 2023 06:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBSFml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Feb 2023 00:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjBSFmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Feb 2023 00:42:38 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2976F14483
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 21:42:18 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 31J5evJY024869
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Feb 2023 00:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1676785262; bh=L1BHkHi6T6qz27wZYhHErthtb81Jb5TkLhnb88KVfFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=W8q1MJILVWeW7U0Rr0HxqnkfP4cIr5QB0Q4dXqkSq+6YYZUmxY2nQnWQti4HUlQsv
         ox3yih4VNlr/QeeFX39vnbJauYNwbFc5Xc37McUH/Lx+G+7tKKX9+Aey/JEgfyE9Cl
         He+1J9s/GWZapxXm9YJUhcC8HqTFl096W3dR9svjlG2/o2s9PYQSexPiKfHHGrRq5/
         oVAxgjJHFztjaPIMgwk4A3krlcTVoYAy/v5rJc2QG12FpH2mmMdKHu4j5OSr0z+x8W
         1IzbgAMpNTEHiBQdYbKmVOjkKeaIfkRPgGxXX+UjwzpiT6FeGA4RJSFJyaosDOTF7C
         JwVRQKmkeeLgQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C977B15C35A7; Sun, 19 Feb 2023 00:40:55 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>,
        linux-hardening@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Riccardo Schirone <sirmy15@gmail.com>,
        linux-kernel@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v2] ext4: Fix function prototype mismatch for ext4_feat_ktype
Date:   Sun, 19 Feb 2023 00:40:47 -0500
Message-Id: <167678522170.2723470.13730761644590168004.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230104210908.gonna.388-kees@kernel.org>
References: <20230104210908.gonna.388-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Jan 2023 13:09:12 -0800, Kees Cook wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed.
> 
> ext4_feat_ktype was setting the "release" handler to "kfree", which
> doesn't have a matching function prototype. Add a simple wrapper
> with the correct prototype.
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix function prototype mismatch for ext4_feat_ktype
      commit: d99a55a94a0db8eda4a336a6f21730b844b8d2d2

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
