Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BBD15E7E4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392707AbgBNQ4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404597AbgBNQRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E53246FC;
        Fri, 14 Feb 2020 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697075;
        bh=vryvSdo/3/KfXGVCRD19mzsGxVTJKiG/aRm1Km2IjyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLr0x3flUQDDe7eClDVcuwk8bPMZ3bvnE3yCZcyn1xH2qeZAz6+mFGAfeTJH9M2U6
         32mVcE69QucWnEftlWA5ihFleGG8uQ7zAIcLP9MzkiOKsdp20k2HrQz3ohbgRwXrkB
         9E10YppMSaTZZz+NnlEvxEHWX7KNZFAl4yKxTCH0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 030/186] nfs: NFS_SWAP should depend on SWAP
Date:   Fri, 14 Feb 2020 11:14:39 -0500
Message-Id: <20200214161715.18113-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 474c4f306eefbb21b67ebd1de802d005c7d7ecdc ]

If CONFIG_SWAP=n, it does not make much sense to offer the user the
option to enable support for swapping over NFS, as that will still fail
at run time:

    # swapon /swap
    swapon: /swap: swapon failed: Function not implemented

Fix this by adding a dependency on CONFIG_SWAP.

Fixes: a564b8f0398636ba ("nfs: enable swap on NFS")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 5f93cfacb3d14..ac3e06367cb68 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -89,7 +89,7 @@ config NFS_V4
 config NFS_SWAP
 	bool "Provide swap over NFS support"
 	default n
-	depends on NFS_FS
+	depends on NFS_FS && SWAP
 	select SUNRPC_SWAP
 	help
 	  This option enables swapon to work on files located on NFS mounts.
-- 
2.20.1

