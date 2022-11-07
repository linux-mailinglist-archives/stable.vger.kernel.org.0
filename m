Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5104461F735
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiKGPKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiKGPKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BAB1E734;
        Mon,  7 Nov 2022 07:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94182B811FE;
        Mon,  7 Nov 2022 15:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BF6C433D6;
        Mon,  7 Nov 2022 15:10:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="npXTMzp6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667833806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6E8sfh+KSW/lm2DELWM82NFs3eR+f8Xe/dkT5NK6VD0=;
        b=npXTMzp6yxpCXYiMribA+Dky7Ipee3hui1bOJgH1hzYBZEWIZJOHrQwjIyBeXcLdOZUnSe
        6FKLMierw6qCWpDb8iU4Mwb/sVA8QRhovFI61nau5UeiSXVyDqEUTpe3/gQWl8N0lfhaWO
        OpgxtnC9EP/w3D/5kPMExHv01wrd8WE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 146ef571 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 7 Nov 2022 15:10:06 +0000 (UTC)
Date:   Mon, 7 Nov 2022 16:09:58 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        krisman@collabora.com, jirislaby@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] unicode: don't write -1 after NUL terminator
Message-ID: <Y2kfxmf3x5bF6tkR@zx2c4.com>
References: <79db9616-a2ee-9a1a-9a35-b82f65b6d15e@kernel.org>
 <20221103113021.3271-1-Jason@zx2c4.com>
 <87sfiux1q2.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sfiux1q2.fsf@suse.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gabriel,

On Mon, Nov 07, 2022 at 09:45:25AM -0500, Gabriel Krisman Bertazi wrote:
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> 
> > If the intention is to overwrite the first NUL with a -1, s[strlen(s)]
> > is the first NUL, not s[strlen(s)+1].
> 
> Hi Jason,
> 
> This code is part of the verification of the trie that done at the end
> of utf8data generation. It is making sure the tree is not corrupted, by
> ensuring that utf8byte doesn't see something past the correct end of the
> string (the first NULL byte).  Note it is not a bad memory access
> either, since we guarantee to have allocated enough space.
> 
> So I think the code is correct as is. if you apply your patch and
> regenerate utf8data.h_shipped, utf8byte will reach that -1 and fail the
> verification.

Ah, okay. "Replace NUL" would seem to be wrong/confusing comment text I
suppose. Thanks for the explanation anyhow, and sorry for the noise.

Jason

> 
> > Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  fs/unicode/mkutf8data.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/unicode/mkutf8data.c b/fs/unicode/mkutf8data.c
> > index bc1a7c8b5c8d..61800e0d3226 100644
> > --- a/fs/unicode/mkutf8data.c
> > +++ b/fs/unicode/mkutf8data.c
> > @@ -3194,7 +3194,7 @@ static int normalize_line(struct tree *tree)
> >  	/* Second test: length-limited string. */
> >  	s = buf2;
> >  	/* Replace NUL with a value that will cause an error if seen. */
> > -	s[strlen(s) + 1] = -1;
> > +	s[strlen(s)] = -1;
> >  	t = buf3;
> >  	if (utf8cursor(&u8c, tree, s))
> >  		return -1;
> 
> -- 
> Gabriel Krisman Bertazi
