Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BF5681073
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbjA3ODj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbjA3ODa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6412840
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EEE96104D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE71C4339B;
        Mon, 30 Jan 2023 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087403;
        bh=byea834qYCPLEZDaybRi9t7oYbN0K3ZyeJQ0Hp83vsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeIrbrkWBeaItPifBc49PClm2m+7M+/OrKeUHh1IawHIGsfVeg6KU+MBDLbYit07g
         oKMpzUKpLSLUqbLCC5p3Bjib9AqgWcTWxZGw2VM+vbnholruSZG9Q4DSmy7RfQVuMj
         pPlLk6gKP9mBqvlbWcp8z83lMofSns5ZTnJbHjhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/313] tools/nolibc: prevent gcc from making memset() loop over itself
Date:   Mon, 30 Jan 2023 14:50:04 +0100
Message-Id: <20230130134344.535704244@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 1bfbe1f3e96720daf185f03d101f072d69753f88 ]

When building on ARM in thumb mode with gcc-11.3 at -O2 or -O3,
nolibc-test segfaults during the select() tests. It turns out that at
this level, gcc recognizes an opportunity for using memset() to zero
the fd_set, but it miscompiles it because it also recognizes a memset
pattern as well, and decides to call memset() from the memset() code:

  000122bc <memset>:
     122bc:       b510            push    {r4, lr}
     122be:       0004            movs    r4, r0
     122c0:       2a00            cmp     r2, #0
     122c2:       d003            beq.n   122cc <memset+0x10>
     122c4:       23ff            movs    r3, #255        ; 0xff
     122c6:       4019            ands    r1, r3
     122c8:       f7ff fff8       bl      122bc <memset>
     122cc:       0020            movs    r0, r4
     122ce:       bd10            pop     {r4, pc}

Simply placing an empty asm() statement inside the loop suffices to
avoid this.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/string.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/string.h b/tools/include/nolibc/string.h
index 0932db3817d2..fffdaf6ff467 100644
--- a/tools/include/nolibc/string.h
+++ b/tools/include/nolibc/string.h
@@ -88,8 +88,11 @@ void *memset(void *dst, int b, size_t len)
 {
 	char *p = dst;
 
-	while (len--)
+	while (len--) {
+		/* prevent gcc from recognizing memset() here */
+		asm volatile("");
 		*(p++) = b;
+	}
 	return dst;
 }
 
-- 
2.39.0



