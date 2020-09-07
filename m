Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D00B26004F
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgIGQrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730831AbgIGQfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C07221F1;
        Mon,  7 Sep 2020 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496523;
        bh=NQKH7qV+mvGMmdYVsn+drBg78YJ7yUGWecvlsGgCjo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsDyv25Rsf2ltPkWAuLq1HUAgIuMd2WNF9WsKmlZGUFTPIPKRw1um1L3QBKClYOqH
         TG6n5aL+1ZrFmqE6OxtxaHo1IRXd3ILGlHFqPL/1rgiX79+QLBwl1aryjNeEYf6ZIw
         qxXRH8/3pJTvdTk8lk+BdgKyaNVuYQ49aVvk+Y1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 17/17] gcov: Disable gcov build with GCC 10
Date:   Mon,  7 Sep 2020 12:35:00 -0400
Message-Id: <20200907163500.1281543-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163500.1281543-1-sashal@kernel.org>
References: <20200907163500.1281543-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit cfc905f158eaa099d6258031614d11869e7ef71c ]

GCOV built with GCC 10 doesn't initialize n_function variable.  This
produces different kernel panics as was seen by Colin in Ubuntu and me
in FC 32.

As a workaround, let's disable GCOV build for broken GCC 10 version.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1891288
Link: https://lore.kernel.org/lkml/20200827133932.3338519-1-leon@kernel.org
Link: https://lore.kernel.org/lkml/CAHk-=whbijeSdSvx-Xcr0DPMj0BiwhJ+uiNnDSVZcr_h_kg7UA@mail.gmail.com/
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gcov/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index 1276aabaab550..1d78ed19a3512 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -3,6 +3,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
+	depends on !CC_IS_GCC || GCC_VERSION < 100000
 	select CONSTRUCTORS if !UML
 	default n
 	---help---
-- 
2.25.1

