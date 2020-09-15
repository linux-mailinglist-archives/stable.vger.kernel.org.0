Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB4326B454
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgIOXVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgIOOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6DC123C83;
        Tue, 15 Sep 2020 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180099;
        bh=SiZDO8TJseYfG8EFYanRKu4nC+XeQyvtHXeky5PXjSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQz59G1D19jvP/7bfn689J7C6McJxAjWwuv+hTPvo7B2ZHB1BaPr630njEXU0Owqq
         7lPbcHLtTd27TFVnHoMUnRR796HQRFtt6rZZyABhjmcZeY+tZoyw++T9/C5gMxTwuv
         pGge8NHEvxA/yWu9q+UhuLTjYtY2ZUYVjMR3enoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 108/177] gcov: Disable gcov build with GCC 10
Date:   Tue, 15 Sep 2020 16:12:59 +0200
Message-Id: <20200915140658.820608455@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



