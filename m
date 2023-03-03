Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64206A9A32
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCCPII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCCPIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:08:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC66DBC6;
        Fri,  3 Mar 2023 07:08:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A0916184D;
        Fri,  3 Mar 2023 15:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5547FC433EF;
        Fri,  3 Mar 2023 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677856085;
        bh=RWAeNl0FOEHPyhK9CFiOhoT8q3B26AGdMmwKdGtGzMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO0TP/RDhIhf6B9vYESnUpd3Vvde/rH8d9oo96GgWAoiRShLsFsFMPTC3PaNtMXrQ
         3mXOb89VoYSw9LUPhY1wLaBxhTOsPt4UupuREvL7+Na6TxyTlSq7j5cryh34qKE5ZX
         a38dOGpeLqgOM7jNZIAPsFkv3gIAPCgnzAe0JkKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.172
Date:   Fri,  3 Mar 2023 16:07:58 +0100
Message-Id: <1677856077209149@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167785607757205@kroah.com>
References: <167785607757205@kroah.com>
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
index 9dde2c230789..447ed158d6bc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 171
+SUBLEVEL = 172
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0c27b81ee1eb..cf6f8aeb450d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7139,7 +7139,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (io_op_defs[req->opcode].needs_file) {
 		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE), 0);
+					(sqe_flags & IOSQE_FIXED_FILE),
+					IO_URING_F_NONBLOCK);
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
