Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445F62FC8BC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbhATCbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbhATB3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F32D235E4;
        Wed, 20 Jan 2021 01:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106064;
        bh=5rQcYV71KV3JmQ4KsDwVdvTYld0jKiuvXxDFcSAvbW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVzP6w4Z44+dO8GFT71fLuUZJk0A5ABKx/89a/Dw7dbGBl2EfVccZAxYOpdgQ44tA
         nxPpTXhBliNk4B5/X0J4EcBmCC0v//WajF5X9t2KNDgLxFc4bQ6RuDJIcepkB62VIV
         T+XqecZrEU5ulSkXGXsfw37xulO2o5tyGYSmLesg0jXxDYZr6Eo6vhHjJ5vCxmovUq
         oQwrgycvmpdPrSeakmRj+dtStSnBxRsaomySaSw7UwsNGF6BcT5PYMKwA3xN/cFEqN
         jLw4veScXP9s6AIg5AccuDBfbUtl6TQ1LSUY2WILUw3e65KA9y2VSr9Ng/NT4X0Bcr
         UNGThlFmgdvAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/15] dm integrity: select CRYPTO_SKCIPHER
Date:   Tue, 19 Jan 2021 20:27:27 -0500
Message-Id: <20210120012740.770354-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
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
index 8b8c123cae66f..7d61ef03cb187 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -527,6 +527,7 @@ config DM_INTEGRITY
 	select BLK_DEV_INTEGRITY
 	select DM_BUFIO
 	select CRYPTO
+	select CRYPTO_SKCIPHER
 	select ASYNC_XOR
 	---help---
 	  This device-mapper target emulates a block device that has
-- 
2.27.0

