Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1E066C5A5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjAPQIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjAPQHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6F027D64
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B154761042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BE0C433EF;
        Mon, 16 Jan 2023 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885142;
        bh=7NtsNkiy6I8Bo08AC+C1iUXJg2+S5FRpeyeYohkHdgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFOCg3GHkefj7/164ZFtAj/xKkYyXS7isk8aER6Fz3L/5DSOF4bkZ0JvRL+VLSNiE
         fGoHEaPMI6Ov1uAqgV+AJ6zAvMTurzcq5D03uosjVdaEsMgTk9nnp4YI96geEdxUV9
         ANqvf9wJE07X6fNcVObm5hXPusfNIN8zU0J+usKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/86] tools/nolibc: fix the O_* fcntl/open macro definitions for riscv
Date:   Mon, 16 Jan 2023 16:51:40 +0100
Message-Id: <20230116154749.785473332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 00b18da4089330196906b9fe075c581c17eb726c ]

When RISCV port was imported in 5.2, the O_* macros were taken with
their octal value and written as-is in hex, resulting in the getdents64()
to fail in nolibc-test.

Fixes: 582e84f7b779 ("tool headers nolibc: add RISCV support") #5.2
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-riscv.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/include/nolibc/arch-riscv.h b/tools/include/nolibc/arch-riscv.h
index 511d67fc534e..8c0cb1abb29f 100644
--- a/tools/include/nolibc/arch-riscv.h
+++ b/tools/include/nolibc/arch-riscv.h
@@ -11,13 +11,13 @@
 #define O_RDONLY            0
 #define O_WRONLY            1
 #define O_RDWR              2
-#define O_CREAT         0x100
-#define O_EXCL          0x200
-#define O_NOCTTY        0x400
-#define O_TRUNC        0x1000
-#define O_APPEND       0x2000
-#define O_NONBLOCK     0x4000
-#define O_DIRECTORY  0x200000
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
 
 struct sys_stat_struct {
 	unsigned long	st_dev;		/* Device.  */
-- 
2.35.1



