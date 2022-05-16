Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98ECA52892D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbiEPPuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 11:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiEPPuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 11:50:17 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAEE2B1B8;
        Mon, 16 May 2022 08:50:16 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 25D6B1F431E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652716215;
        bh=LKlIdLOO4j50+tfjv98qyF6r1YItkJl+IUV5p+TB/6k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=B4G8ttqT8x2WWy6RVT7vFYvQ9NokIrgIiydUuOJofiVW5bFY4TYb4QLMF4G47aEUl
         2BT1h8XhlquGJbFlOjQmD3F9eokTq/BWT4LDplYoKAVxOpdbdScJiTYgsU3AoSwI2B
         J2Byk1M1UDnr2ai4E6eSgGUMK9Pq4fxsdx84OZIlVDznfFKqYlIUfat+V1q/IejA97
         KZ9fj1Anjx8JPyozvJgwPNIXA6IVeAp52sMLokMLrbZZB5Thmb0DUZkAkOD9S2pFIC
         bkD3NfN8r0Ff+1JfAmlW4WMSKZIfTpZB5BbZmUB8svVWbsJd32DkV48po2MQMZnmza
         W2Q1OZzMr4byw==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: don't use casefolded comparison for "." and ".."
Organization: Collabora
References: <20220514175929.44439-1-ebiggers@kernel.org>
Date:   Mon, 16 May 2022 11:50:10 -0400
In-Reply-To: <20220514175929.44439-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Sat, 14 May 2022 10:59:29 -0700")
Message-ID: <87r14txyrx.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> From: Eric Biggers <ebiggers@google.com>
>
> Tryng to rename a directory that has all following properties fails with
> EINVAL and triggers the 'WARN_ON_ONCE(!fscrypt_has_encryption_key(dir))'
> in f2fs_match_ci_name():
>
>     - The directory is casefolded
>     - The directory is encrypted
>     - The directory's encryption key is not yet set up
>     - The parent directory is *not* encrypted
>
> The problem is incorrect handling of the lookup of ".." to get the
> parent reference to update.  fscrypt_setup_filename() treats ".." (and
> ".") specially, as it's never encrypted.  It's passed through as-is, and
> setting up the directory's key is not attempted.  As the name isn't a
> no-key name, f2fs treats it as a "normal" name and attempts a casefolded
> comparison.  That breaks the assumption of the WARN_ON_ONCE() in
> f2fs_match_ci_name() which assumes that for encrypted directories,
> casefolded comparisons only happen when the directory's key is set up.
>
> We could just remove this WARN_ON_ONCE().  However, since casefolding is
> always a no-op on "." and ".." anyway, let's instead just not casefold
> these names.  This results in the standard bytewise comparison.
>
> Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> Cc: <stable@vger.kernel.org> # v5.11+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/f2fs/dir.c  |  3 ++-
>  fs/f2fs/f2fs.h | 10 +++++-----
>  fs/f2fs/hash.c | 11 ++++++-----
>  3 files changed, 13 insertions(+), 11 deletions(-)

Hi Eric,

This looks good to me:

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks,

-- 
Gabriel Krisman Bertazi
