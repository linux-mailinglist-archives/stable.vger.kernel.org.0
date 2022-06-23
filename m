Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748C25582B3
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiFWRSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiFWRSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D6D88B3C;
        Thu, 23 Jun 2022 10:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03A8560FF9;
        Thu, 23 Jun 2022 17:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4187C341C4;
        Thu, 23 Jun 2022 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003609;
        bh=jRMmu2yKSBTvdsxsfBHp6XyoOa58ur+p9cmpuZp/3IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr8qHFJ1AOYzsktN8YxhJ0/4FVdzo367J0opM2E1rtyuiZN48Ymc0jU8+Bl2WEH3Q
         pVFCEF1gXWXb93uEmOoqfO+1JssTTuJ+FNYUG6FhAEqTp7H+j2KCBYV6PpbQ77rJZ5
         KwVXjUSkVb0b9vQSnM6wm1JtMKl6Dza/ZGFIK1n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 029/237] random: Dont wake crng_init_wait when crng_init == 1
Date:   Thu, 23 Jun 2022 18:41:03 +0200
Message-Id: <20220623164343.994391946@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 4c8d062186d9923c09488716b2fb1b829b5b8006 upstream.

crng_init_wait is only used to wayt for crng_init to be set to 2, so
there's no point to waking it when crng_init is set to 1.  Remove the
unnecessary wake_up_interruptible() call.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/6fbc0bfcbfc1fa2c76fd574f5b6f552b11be7fde.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -962,7 +962,6 @@ static int crng_fast_load(const char *cp
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
 	return 1;


