Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39553BFB4
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237598AbiFBUW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238916AbiFBUWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:22:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EB69FDF
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 13:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 226A56185C
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361C7C385A5;
        Thu,  2 Jun 2022 20:22:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hctC1cyx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654201369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8dkod86+clrL+2Z+yWqGe8mwZhhiF54eX9tqDAoDCSU=;
        b=hctC1cyxGmNx0plRqwKhBK9nQq6vrZyOa++A5WrFDfiMGRMDqSPrZjKMkT1gwJuKqnArpw
        0d/R1V/B3KW1B+AIhUY9ScLb/hPRcSoWzOa0FqzQyLWp+ExBACmauFYS+Wmi9h77ryet+f
        OhP86UQTau4aWtZj00ySxEYzBqzeKmM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id eb2cbd65 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jun 2022 20:22:48 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.10.y 0/5] missing random.c-related stable patches
Date:   Thu,  2 Jun 2022 22:22:27 +0200
Message-Id: <20220602202232.281326-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I forgot two things when doing the 5.10 backport. The first is a patch
from Justin fixing a bug in some of the lib/crypto Kconfig changes,
which Pablo (CC'd) pointed out was missed. The second is that the
backport of 5acd35487dc9 ("random: replace custom notifier chain with
standard one") isn't quite right without Nicolai's patches there too,
since the drbg module is removable.

I'll continue to monitor all the channels I possibly can for chatter
about problems, but so far this is all I've run into.

Jason

Cc: Pablo Greco <pgreco@centosproject.org>

Justin M. Forbes (1):
  lib/crypto: add prompts back to crypto libraries

Nicolai Stange (4):
  crypto: drbg - prepare for more fine-grained tracking of seeding state
  crypto: drbg - track whether DRBG was seeded with
    !rng_is_initialized()
  crypto: drbg - move dynamic ->reseed_threshold adjustments to
    __drbg_seed()
  crypto: drbg - make reseeding from get_random_bytes() synchronous

 crypto/Kconfig        |   2 -
 crypto/drbg.c         | 110 +++++++++++++++++-------------------------
 drivers/char/random.c |   2 -
 include/crypto/drbg.h |  10 ++--
 lib/Kconfig           |   2 +
 lib/crypto/Kconfig    |  17 +++++--
 6 files changed, 65 insertions(+), 78 deletions(-)

-- 
2.35.1

