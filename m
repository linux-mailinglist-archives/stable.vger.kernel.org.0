Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02215535F59
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349475AbiE0LhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349040AbiE0LhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:37:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A2522C6;
        Fri, 27 May 2022 04:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BA5E61C3F;
        Fri, 27 May 2022 11:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C87AC385A9;
        Fri, 27 May 2022 11:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651442;
        bh=lnFjtwLUDdubcl79VcwkRkWPLGZJDO44WzGc606Jztc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CU3gdKWyIUf6oVuW1Dgfnq5e3RhP0tRbtQBP0o71hiDRTHjG3B3X1qMv4afldSNej
         ZDyr7DQkKc9l1fQWU87OTByJcfIn4jz06kwLx1c/zoYJxELcbILOxeBLeQjW64dZ9P
         Is/SpW9WmCXEl0aDj4sz27vZD/zwP+PTZlBHpygQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 045/111] random: only wake up writers after zap if threshold was passed
Date:   Fri, 27 May 2022 10:49:17 +0200
Message-Id: <20220527084825.820184840@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit a3f9e8910e1584d7725ef7d5ac870920d42d0bb4 upstream.

The only time that we need to wake up /dev/random writers on
RNDCLEARPOOL/RNDZAPPOOL is when we're changing from a value that is
greater than or equal to POOL_MIN_BITS to zero, because if we're
changing from below POOL_MIN_BITS to zero, the writers are already
unblocked.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1582,7 +1582,7 @@ static long random_ioctl(struct file *f,
 		 */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (xchg(&input_pool.entropy_count, 0)) {
+		if (xchg(&input_pool.entropy_count, 0) >= POOL_MIN_BITS) {
 			wake_up_interruptible(&random_write_wait);
 			kill_fasync(&fasync, SIGIO, POLL_OUT);
 		}


