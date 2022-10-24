Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5CD60A285
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiJXLo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiJXLoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:44:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CBA73C1F;
        Mon, 24 Oct 2022 04:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF2D561281;
        Mon, 24 Oct 2022 11:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21C4C43144;
        Mon, 24 Oct 2022 11:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611594;
        bh=pmOPmI+oMzt7p797XAEtSZK+rbfd/3Vbxj8UdGQP6Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohjFe7wJsIa4OHcGfJetr0J3szMfO934pBpJHdoKdKRsCMX3KUOYGM2i7106j/54b
         nlKS18/x3p+tYn4vtXztiqvj3yC5CiE2KMgBosUQWulBlqm8levNMQ+g2SYqKgLcsl
         0JDMFPjQXNzVUcddzRYv51RazcQPRhiSHbQGmWIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guozihua <guozihua@huawei.com>,
        Zhongguohua <zhongguohua1@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Lutomirski <luto@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 037/159] random: restore O_NONBLOCK support
Date:   Mon, 24 Oct 2022 13:29:51 +0200
Message-Id: <20221024112950.742291077@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit cd4f24ae9404fd31fc461066e57889be3b68641b upstream.

Prior to 5.6, when /dev/random was opened with O_NONBLOCK, it would
return -EAGAIN if there was no entropy. When the pools were unified in
5.6, this was lost. The post 5.6 behavior of blocking until the pool is
initialized, and ignoring O_NONBLOCK in the process, went unnoticed,
with no reports about the regression received for two and a half years.
However, eventually this indeed did break somebody's userspace.

So we restore the old behavior, by returning -EAGAIN if the pool is not
initialized. Unlike the old /dev/random, this can only occur during
early boot, after which it never blocks again.

In order to make this O_NONBLOCK behavior consistent with other
expectations, also respect users reading with preadv2(RWF_NOWAIT) and
similar.

Fixes: 30c08efec888 ("random: make /dev/random be almost like /dev/urandom")
Reported-by: Guozihua <guozihua@huawei.com>
Reported-by: Zhongguohua <zhongguohua1@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andrew Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1295,6 +1295,10 @@ static ssize_t random_read_iter(struct k
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    (kiocb->ki_filp->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;


