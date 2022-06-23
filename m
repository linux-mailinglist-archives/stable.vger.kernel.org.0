Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174D75586B1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbiFWSQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbiFWSPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:15:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D085DF0D;
        Thu, 23 Jun 2022 10:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8017B82497;
        Thu, 23 Jun 2022 17:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E64BC341C5;
        Thu, 23 Jun 2022 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004927;
        bh=VUdUdSClpPx72kdmXclp+/hBcSqoa28HxWnfFrjn8/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS1ajmkL56pfcf9LP9mB6w+q15Ww5IZ8yKqeA9O4YGRgy0lnekpm9ao83PSIR/W/i
         fBFd1UwmLDgo1O7QfhCpNTwzrT3JqyMDJB3wXRMSFFSjE2NiMnVnXGQYI5aTk49xG7
         uO3KhDMA3+d77JNsfw9wVOvL5bv+dzvXA2uBTkZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 168/234] random: wire up fops->splice_{read,write}_iter()
Date:   Thu, 23 Jun 2022 18:43:55 +0200
Message-Id: <20220623164347.807363101@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 79025e727a846be6fd215ae9cdb654368ac3f9a6 upstream.

Now that random/urandom is using {read,write}_iter, we can wire it up to
using the generic splice handlers.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Jason: added the splice_write path. Note that sendfile() and such still
 does not work for read, though it does for write, because of a file
 type restriction in splice_direct_to_actor(), which I'll address
 separately.]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1381,6 +1381,8 @@ const struct file_operations random_fops
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 const struct file_operations urandom_fops = {
@@ -1389,6 +1391,8 @@ const struct file_operations urandom_fop
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 


