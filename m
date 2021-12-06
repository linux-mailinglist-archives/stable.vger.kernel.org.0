Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847EC469EFC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391188AbhLFPpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386625AbhLFP0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334E5C08E83B;
        Mon,  6 Dec 2021 07:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB64B81118;
        Mon,  6 Dec 2021 15:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11135C341C2;
        Mon,  6 Dec 2021 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803807;
        bh=DaDRqVB9y/igRYyns2roX/zPHoq+OJx9a3K5R2n7110=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt2DRmQVaL54T0UVy6Ioy9EyJfk6s+cAxKVLoq6V3t6Ey37RNvdSwgZ6PcJawYo51
         1QM0ry0FFaZmrK/Uxi61Rg42lj1pUknuywHnXiUn8qjUzRTEDz2NSRlk3bPnT4vDrI
         k7RC1O53bOFGck9inWSKENlPnKScRjZVySZKywOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 053/130] wireguard: selftests: increase default dmesg log size
Date:   Mon,  6 Dec 2021 15:56:10 +0100
Message-Id: <20211206145601.517113761@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 03ff1b1def73f817e196bf96ab36ac259490bd7c upstream.

The selftests currently parse the kernel log at the end to track
potential memory leaks. With these tests now reading off the end of the
buffer, due to recent optimizations, some creation messages were lost,
making the tests think that there was a free without an alloc. Fix this
by increasing the kernel log size.

Fixes: 24b70eeeb4f4 ("wireguard: use synchronize_net rather than synchronize_rcu")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 74db83a0aedd..a9b5a520a1d2 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -66,6 +66,7 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_CONSOLE_LOGLEVEL_DEFAULT=15
+CONFIG_LOG_BUF_SHIFT=18
 CONFIG_PRINTK_TIME=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_LEGACY_VSYSCALL_NONE=y
-- 
2.34.1



