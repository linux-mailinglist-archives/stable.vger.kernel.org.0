Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D472FC7CE
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbhATB1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbhATB12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0FC323121;
        Wed, 20 Jan 2021 01:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105971;
        bh=74ee0G2fGOSu4kMozZgJOcryEsvgpnye5mybvhlRqt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9zf/MckfHV5sBWpG1m5EigHjlV9ycJO7faeSOnTwkvENfufQ0rq7euPaEVm+5/2z
         g4padWtyMH9UY00iKfxEsGoNbuv3uFbdruukXP+iPbYe0qSFT3+1qyCJwwn8I1Tqx5
         5KEKaZn0hnZTQmz1T8ACJZ0pFZNi52Uuped3oxJn7MxMdtaT4QjuJP+vs6iRPTUHGG
         BZ7lSze8j1qDxiepf2HHzTFw8QVC+JsdjN21wiHp08ksVfxbdWG4qZrIIcfBCluYWM
         dcHLBgXDNpH8Hj4RTfDN016YwRFJkMINe5ZAGoOqHXOav2gzV2djtbTkz3Vwv/0BuC
         X8gfcccAsVhOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/45] dm integrity: select CRYPTO_SKCIPHER
Date:   Tue, 19 Jan 2021 20:25:24 -0500
Message-Id: <20210120012602.769683-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit f7b347acb5f6c29d9229bb64893d8b6a2c7949fb ]

The integrity target relies on skcipher for encryption/decryption, but
certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
compilation errors due to unresolved symbols. Explicitly select
CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
on it.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30ba3573626c2..5c0e7063f5f5c 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -585,6 +585,7 @@ config DM_INTEGRITY
 	select BLK_DEV_INTEGRITY
 	select DM_BUFIO
 	select CRYPTO
+	select CRYPTO_SKCIPHER
 	select ASYNC_XOR
 	help
 	  This device-mapper target emulates a block device that has
-- 
2.27.0

