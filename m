Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8D25581EB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiFWRJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiFWRH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:07:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A974522DD;
        Thu, 23 Jun 2022 09:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861BBB8248C;
        Thu, 23 Jun 2022 16:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EE8C3411B;
        Thu, 23 Jun 2022 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003363;
        bh=bRpfpTLbjOWFCMFLl0M5dzFYUWbGwOag7/SYxuGRWz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnwHxOKjKNXa1VC376oKYuS/mFjXpaqom+EIvLsEJCLDxsm6xDxwfHr3P0XXAx1H8
         jlBB7NvEkpsfghaubGX3kJbIW7T/758qhA9C9HVwIFNoUOgnsSkw8UA/VmMyYj7Mfw
         g2tb9pg1nbMY9/5BGRgVnlqm6T7piHO324QrjaKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 212/264] random: wire up fops->splice_{read,write}_iter()
Date:   Thu, 23 Jun 2022 18:43:25 +0200
Message-Id: <20220623164350.071845525@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
@@ -1382,6 +1382,8 @@ const struct file_operations random_fops
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 const struct file_operations urandom_fops = {
@@ -1390,6 +1392,8 @@ const struct file_operations urandom_fop
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 


