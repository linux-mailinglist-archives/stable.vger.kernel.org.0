Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E494FD874
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343883AbiDLHhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353742AbiDLHZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFBF388C;
        Tue, 12 Apr 2022 00:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31DB8B81A8F;
        Tue, 12 Apr 2022 07:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D46C385A6;
        Tue, 12 Apr 2022 07:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747053;
        bh=xd+6zkjK1T71bZdK8lxeDi33yn7elOo0gA8j9wLhbsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbF+THV9ljcC3+mGDuScILWsJhVR9TODxK6lykfw8TPDzG666H+Wm5NwufpKp1+4A
         y46uTl6rvWnvyoUg6NXMKJLh9fBfZVxhWoNcatm1KKV9ZDyjrLSBUvcPbf/UTrIkaD
         9nfDfOkK1Gp4hhYMvFhyvgltiUz1ynrdQmWl3/g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Syromiatnikov <esyr@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 226/285] io_uring: implement compat handling for IORING_REGISTER_IOWQ_AFF
Date:   Tue, 12 Apr 2022 08:31:23 +0200
Message-Id: <20220412062950.182021874@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Syromiatnikov <esyr@redhat.com>

commit 0f5e4b83b37a96e3643951588ed7176b9b187c0a upstream.

Similarly to the way it is done im mbind syscall.

Cc: stable@vger.kernel.org # 5.14
Fixes: fe76421d1da1dcdb ("io_uring: allow user configurable IO thread CPU affinity")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10799,7 +10799,15 @@ static __cold int io_register_iowq_aff(s
 	if (len > cpumask_size())
 		len = cpumask_size();
 
-	if (copy_from_user(new_mask, arg, len)) {
+	if (in_compat_syscall()) {
+		ret = compat_get_bitmap(cpumask_bits(new_mask),
+					(const compat_ulong_t __user *)arg,
+					len * 8 /* CHAR_BIT */);
+	} else {
+		ret = copy_from_user(new_mask, arg, len);
+	}
+
+	if (ret) {
 		free_cpumask_var(new_mask);
 		return -EFAULT;
 	}


