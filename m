Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A055FDE47
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJMQcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJMQcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:32:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A9BF034B
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51EB7B81D03
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2A1C433C1;
        Thu, 13 Oct 2022 16:32:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mgFeMCuR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665678757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTpFXmluGzDUwtC15aowm1eIaCthcTF7HKAB7UuvSHA=;
        b=mgFeMCuR99yKwY9N2yH4+qNOGQFpnEm0du9oAv/k/7G7Tyg4sF1SYl/Z0PpUoDtWH8ApK4
        ZT/P5DfQa+BJbJnecaTrtMMeyGeNHhXpSw2NsyeVd8atq4vs8nEQYiTlk9Yy8+yx881Sjy
        ol9rGTGZJxjLjuzQKHiLSbZR1J38B18=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d3fd5a1d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 13 Oct 2022 16:32:36 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 4.9.y] random: restore O_NONBLOCK support
Date:   Thu, 13 Oct 2022 10:32:31 -0600
Message-Id: <20221013163231.1410141-1-Jason@zx2c4.com>
In-Reply-To: <Y0g7N95gKNFMJZ72@kroah.com>
References: <Y0g7N95gKNFMJZ72@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/char/random.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1cbc33ee5a5f..838f66723ccd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1295,6 +1295,10 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    (kiocb->ki_filp->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
-- 
2.37.3

