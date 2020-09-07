Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575B8260147
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgIGRCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbgIGQd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FF8F21974;
        Mon,  7 Sep 2020 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496408;
        bh=SiZDO8TJseYfG8EFYanRKu4nC+XeQyvtHXeky5PXjSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrDtGH3deN5zKtzIAddIZ/n+M2Fmft7X1w4DAimRmOeuywTVoc5OtqFJ5gJhfxbq7
         uTvkZm0PnrW6GYmpZj5kGoolzekdh/Qj3PWzKQ+a6D6EeyZZ1jfi7px3c+yik9QYtN
         TdDIsgpzx0mODzvA483nfit/8IqwGZyNENTY4vGA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 53/53] gcov: Disable gcov build with GCC 10
Date:   Mon,  7 Sep 2020 12:32:19 -0400
Message-Id: <20200907163220.1280412-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
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
index 3110c77230c7f..bb4b680e8455a 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -4,6 +4,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
+	depends on !CC_IS_GCC || GCC_VERSION < 100000
 	select CONSTRUCTORS if !UML
 	default n
 	help
-- 
2.25.1

