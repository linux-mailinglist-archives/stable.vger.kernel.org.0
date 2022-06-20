Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9830F551682
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240850AbiFTLDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240146AbiFTLDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:03:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE5312AA2;
        Mon, 20 Jun 2022 04:03:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CEA3B8108C;
        Mon, 20 Jun 2022 11:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E842C3411C;
        Mon, 20 Jun 2022 11:03:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DFTzjwGR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655723002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XCzTJV39Spaf8xMntkyuVAWW186G7M690N665AOiqfk=;
        b=DFTzjwGRSPlUI4JRPx49WGas67S5luQNT3sO44uqmW65LM/Q+gAQp7KBSGA5js3G0rzVX8
        ssHLJZdTeOo7HfCSp4HhIDTQLWlYtbng9iWf/vmrDVj15b42YNZI8pfaaaRdxxx68YMScn
        UO+dw4P6FJeXC7n59l5gyc3ibbnT7fM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 29d6483a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Jun 2022 11:03:22 +0000 (UTC)
Date:   Mon, 20 Jun 2022 13:03:19 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] s390/archrandom: simplify back to earlier design
Message-ID: <YrBT97lARo2QAWVF@zx2c4.com>
References: <20220610111041.2709-1-Jason@zx2c4.com>
 <1e6dd1baa9a5d7a665917793e2df785c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1e6dd1baa9a5d7a665917793e2df785c@linux.ibm.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Harald,

On Mon, Jun 20, 2022 at 12:54:11PM +0200, Harald Freudenberger wrote:
> Hi Jason, I've been on vacation and now seen your s390 arch random 
> rework.
> Your assumption is right. The hw TRNG we have on the s390 platform is
> relatively expensive and I had to learn that directly calling the TRNG
> as part of an arch_get_random_{long,int} is not the right way. As we
> also have a NIST 800-90A conform PRNG in hardware, I used it as some
> kind of caching the TRNG random data.

Indeed that's what I saw. I actually think this kind of caching is
undesirable from an rng perspective too, since it essentially means we
have two software rngs, with different lifetimes and semantics on key
duration. So getting rid of that seems like a benefit.

> With all the changes in random.c there is no need to provide any
> arch_get_random_{long,int}() implementation any more.
> However, the arch_get_random_seed functions should provide TRNG
> values to random.c and so I'll have a close look onto your changes.

Right, that's what my patch does.

> Thanks for your patches, I'll come back with some feedback.

Thanks, looking forward. Please be sure to read v3 of the bunch I sent
(rather than this v1 you're replying to here):
https://lore.kernel.org/lkml/20220610222023.378448-1-Jason@zx2c4.com/

Jason
