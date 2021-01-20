Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8195E2FC6C4
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbhATB24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbhATB2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11CF23332;
        Wed, 20 Jan 2021 01:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106028;
        bh=MHHSEdHWWHQDTN+p6yi39+yU36kMMRKVLoHSUbGF48c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkKQozzOJxXpDeR/toxOeurs53QSsJXXZXDUZEynOTzYjQRFDCv67ZRdfH/zcQEfM
         rg9kEVWiTmp0hVqXvzJ830dU3eXy/iUwMs/tcxeNxubWjI1uTOzzHOrBvOFt56iDQ7
         UE1A4mvcwKEB35cJ/BjY2T1WGOvwoSiAquYvhL1oyarSYIIqf741no+FgC1inRotYg
         EDFfd4fesHpQubJidWk9pRhMoOxzXMc9WFSuhsY775b20PBkpaf6K6IsbYTz9cCZ6+
         eEzVEUe1SyGeltZ3Ht8oT5HiBKV2sWf4kzRdmGW51Bii1TYtsxVQtfO3aFpM1lpcCt
         3Rib1qv6yuBNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/26] dm integrity: select CRYPTO_SKCIPHER
Date:   Tue, 19 Jan 2021 20:26:40 -0500
Message-Id: <20210120012704.770095-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index aa98953f4462e..7dd6e98257c72 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -565,6 +565,7 @@ config DM_INTEGRITY
 	select BLK_DEV_INTEGRITY
 	select DM_BUFIO
 	select CRYPTO
+	select CRYPTO_SKCIPHER
 	select ASYNC_XOR
 	---help---
 	  This device-mapper target emulates a block device that has
-- 
2.27.0

