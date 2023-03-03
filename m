Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DEE6A9A37
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjCCPIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjCCPIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:08:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D302126C9;
        Fri,  3 Mar 2023 07:08:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CA2C6184D;
        Fri,  3 Mar 2023 15:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F58C433EF;
        Fri,  3 Mar 2023 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677856093;
        bh=lA7s7Ro0byEU/PxUpulipBQUTo+TRrskvlgYOn9iGdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYSPN3oPOg5DkzUhgCThg7uzS8wOv2fZTxJNrPJjKFYO7g6EJ/t9QGqlmUJRjw17+
         TnxRlsCSj5RTypzCAy+RrEhTj8yJFe418jZ/s+yBYNePUaxg16wExyqWmIZm/UXOM0
         DPgU3AWj3WQD+9GvwVP3omghmv6F4oumEyodh3qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.98
Date:   Fri,  3 Mar 2023 16:08:02 +0100
Message-Id: <1677856082192142@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167785608214197@kroah.com>
References: <167785608214197@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 89e039ab5968..b17ce4c2e8f2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 97
+SUBLEVEL = 98
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7857b3d9d6a7..51d6fbe17f7f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7310,7 +7310,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (io_op_defs[req->opcode].needs_file) {
 		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE), 0);
+					(sqe_flags & IOSQE_FIXED_FILE),
+					IO_URING_F_NONBLOCK);
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
