Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F01861F679
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiKGOpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiKGOp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:45:29 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8327763CA;
        Mon,  7 Nov 2022 06:45:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 408861F88B;
        Mon,  7 Nov 2022 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667832327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cZm/wQf2gsUgDGXoHLBPB1Qsxg3OrtK7BF0uBkFje6Y=;
        b=nSLX0a1Js2iMFMZa7zClEOTa7FimIBdoknU1tFZAm7LeZXtmQh4Uoa/2WtkXblRWu7+Bc2
        r/KIGDICJ8I0dm7tCkgsodZbLcIJveHlh3xRq0p1isEV0W0pGMe/Pk+pyO7DXLI1P78CGi
        BzxE3N2fjvPH7AHpHGylnVTf2CV0tTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667832327;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cZm/wQf2gsUgDGXoHLBPB1Qsxg3OrtK7BF0uBkFje6Y=;
        b=npiHpnCbz+k6+yawP0mvSkWJPqR+7u3mdfWTsoYeDCgeEVoqu737Cqw9ttphecr2+c1YlK
        NTM6796GIFMXf4CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09A0513AC7;
        Mon,  7 Nov 2022 14:45:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZxtUOAYaaWPvCgAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 07 Nov 2022 14:45:26 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        krisman@collabora.com, jirislaby@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] unicode: don't write -1 after NUL terminator
References: <79db9616-a2ee-9a1a-9a35-b82f65b6d15e@kernel.org>
        <20221103113021.3271-1-Jason@zx2c4.com>
Date:   Mon, 07 Nov 2022 09:45:25 -0500
In-Reply-To: <20221103113021.3271-1-Jason@zx2c4.com> (Jason A. Donenfeld's
        message of "Thu, 3 Nov 2022 12:30:21 +0100")
Message-ID: <87sfiux1q2.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> If the intention is to overwrite the first NUL with a -1, s[strlen(s)]
> is the first NUL, not s[strlen(s)+1].

Hi Jason,

This code is part of the verification of the trie that done at the end
of utf8data generation. It is making sure the tree is not corrupted, by
ensuring that utf8byte doesn't see something past the correct end of the
string (the first NULL byte).  Note it is not a bad memory access
either, since we guarantee to have allocated enough space.

So I think the code is correct as is. if you apply your patch and
regenerate utf8data.h_shipped, utf8byte will reach that -1 and fail the
verification.

> Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  fs/unicode/mkutf8data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/unicode/mkutf8data.c b/fs/unicode/mkutf8data.c
> index bc1a7c8b5c8d..61800e0d3226 100644
> --- a/fs/unicode/mkutf8data.c
> +++ b/fs/unicode/mkutf8data.c
> @@ -3194,7 +3194,7 @@ static int normalize_line(struct tree *tree)
>  	/* Second test: length-limited string. */
>  	s = buf2;
>  	/* Replace NUL with a value that will cause an error if seen. */
> -	s[strlen(s) + 1] = -1;
> +	s[strlen(s)] = -1;
>  	t = buf3;
>  	if (utf8cursor(&u8c, tree, s))
>  		return -1;

-- 
Gabriel Krisman Bertazi
