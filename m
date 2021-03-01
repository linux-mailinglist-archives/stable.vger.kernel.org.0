Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565333290A4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhCAUMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242553AbhCAUCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F1F6538C;
        Mon,  1 Mar 2021 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621445;
        bh=Y5xBKMIoXxsVIZ216d912SwgJqLiCY371beYWkVb3rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gm14mIiwq+mbcBFfuVkpQK0ucenzyRmGswVKaKTBuQZcbe1bmSJ9f9dUhuXb2RoY9
         dCSOcIDMpxgmh0wDbkkLXC3RgJxPp2S/Dff/FaTPNbttr1vK9cLn/oRoIKrSOt+U+M
         Q2NHXiDna8srL/tNHZNox3pkJhdeDcWUp3YXyBTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 518/775] ext: EXT4_KUNIT_TESTS should depend on EXT4_FS instead of selecting it
Date:   Mon,  1 Mar 2021 17:11:26 +0100
Message-Id: <20210301161227.126068198@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 302fdadeafe4be539f247abf25f61822e4a5a577 ]

EXT4_KUNIT_TESTS selects EXT4_FS, thus enabling an optional feature the
user may not want to enable.  Fix this by making the test depend on
EXT4_FS instead.

Fixes: 1cbeab1b242d16fd ("ext4: add kunit test for decoding extended timestamps")
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20210122110234.2825685-1-geert@linux-m68k.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 619dd35ddd48a..86699c8cab281 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -103,8 +103,7 @@ config EXT4_DEBUG
 
 config EXT4_KUNIT_TESTS
 	tristate "KUnit tests for ext4" if !KUNIT_ALL_TESTS
-	select EXT4_FS
-	depends on KUNIT
+	depends on EXT4_FS && KUNIT
 	default KUNIT_ALL_TESTS
 	help
 	  This builds the ext4 KUnit tests.
-- 
2.27.0



