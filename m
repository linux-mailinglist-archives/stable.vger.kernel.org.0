Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F935C0238
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiIUPuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiIUPto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:49:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC2F9E127;
        Wed, 21 Sep 2022 08:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2A2063134;
        Wed, 21 Sep 2022 15:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC9CC433C1;
        Wed, 21 Sep 2022 15:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775285;
        bh=0jQRjovtLmJ+JpC0ZRGxXIXRjH2x78eKIRdqyG2/Io4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEF0cqny+fk78/7qjfw0aP4Fn8xRNCBVclYz1zI3rZLRWM9Os1gYSib1BT8N8hHie
         4j7szHyjhwIKiWt9tr+I2guhnvIGoI2ODlEoqGmaDmwmgLe5wU8LYDAbH5bNBsvlqS
         UCMoQSsUtoQ4LORv7VooBSqGoc2CnTYtr6EqdGwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 21/38] io_uring/msg_ring: check file type before putting
Date:   Wed, 21 Sep 2022 17:46:05 +0200
Message-Id: <20220921153646.939592037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit fc7222c3a9f56271fba02aabbfbae999042f1679 upstream.

If we're invoked with a fixed file, follow the normal rules of not
calling io_fput_file(). Fixed files are permanently registered to the
ring, and do not need putting separately.

Cc: stable@vger.kernel.org
Fixes: aa184e8671f0 ("io_uring: don't attempt to IOPOLL for MSG_RING requests")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5061,7 +5061,8 @@ done:
 		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	/* put file to avoid an attempt to IOPOLL the req */
-	io_put_file(req->file);
+	if (!(req->flags & REQ_F_FIXED_FILE))
+		io_put_file(req->file);
 	req->file = NULL;
 	return 0;
 }


