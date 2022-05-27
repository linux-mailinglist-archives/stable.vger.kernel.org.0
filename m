Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168A8536216
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352822AbiE0MHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353604AbiE0MGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:06:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60D9166693;
        Fri, 27 May 2022 04:55:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C27BB824D8;
        Fri, 27 May 2022 11:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72733C385A9;
        Fri, 27 May 2022 11:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652497;
        bh=udgTduj/RGNpsId+hnXUCmh3BDR/m1lF7T1V3sKJ+ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+188eb99usg1ZzeMUrOq+kVavoPRUBWxa5kRv80EKIvwP7Ar6+MXKLkms7Qa1mnj
         MzcV7LxkMCJGrYzlRWWGT/18uMFcC5AztmBn1dDAXCJHHIA1rH2W6frhtDS9vH+vyF
         jri4TdH3GXSF6zGUFEqrRBk98z+q4buRUOFaS9H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 161/163] random: wire up fops->splice_{read,write}_iter()
Date:   Fri, 27 May 2022 10:50:41 +0200
Message-Id: <20220527084850.615525258@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
@@ -1386,6 +1386,8 @@ const struct file_operations random_fops
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 const struct file_operations urandom_fops = {
@@ -1395,6 +1397,8 @@ const struct file_operations urandom_fop
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 


