Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD475953E1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiHPHfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiHPHee (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:34:34 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448F1D476E;
        Mon, 15 Aug 2022 21:16:00 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oNnzO-00BTJq-2W; Tue, 16 Aug 2022 14:15:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Aug 2022 12:15:38 +0800
Date:   Tue, 16 Aug 2022 12:15:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     marcan@marcan.st, will@kernel.org, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        boqun.feng@gmail.com, catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvqaK3hxix9AaQBO@slm.duckdns.org>
X-Newsgroups: apana.lists.os.linux.kernel
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:
> 
> Oh, tricky one and yeah you're absolutely right that it makes no sense to
> not guarantee barrier semantics when already pending. I didn't even know
> test_and_set_bit() wasn't a barrier when it failed. Thanks a lot for hunting
> down and fixing this. Applied to wq/for-6.0-fixes.

Please revert this as test_and_set_bit was always supposed to be
a full memory barrier.  This is an arch bug.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
