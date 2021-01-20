Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D9B2FC7BD
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbhATCUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:20:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730857AbhATB3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC8623715;
        Wed, 20 Jan 2021 01:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106085;
        bh=jcd+HH/G7EYQLV0kHgGg4IVObzS7LgAWPr49vD7pUh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDB1viuI5Sqi4sYsm6U8lwGjqIcA0Qw2OtvVgd1d2wFT7IXghQMOHtctWAlKkePWP
         L7Kgo8jQ4gNSUnheYp2B2ns34Po9qz2fGXTM5sIFGAyi1So2JUbnnRbqRAjTJQPm75
         WTbAk0ghfAX5SCRsu2j09ZvDd1YeAeFq7kh3ANP2Zs39BxtqldsxELA1+PAx6BYPAx
         pfMg2rAtyru3jAAhqWWhQv9Et3J+N4EvlTnWzm9UEVU5YqTHPuV9Krx5EojVgOO27+
         xL9b4ZXOjot3F50c7hb6DVVNIEwcXoi41jDr0B3PMn345tDSP2elKw12wfVz3vBv/D
         ff69MpfzZII8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/9] dm integrity: select CRYPTO_SKCIPHER
Date:   Tue, 19 Jan 2021 20:27:55 -0500
Message-Id: <20210120012802.770525-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012802.770525-1-sashal@kernel.org>
References: <20210120012802.770525-1-sashal@kernel.org>
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
index 4a249ee86364c..231b6a18ca272 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -508,6 +508,7 @@ config DM_INTEGRITY
 	select BLK_DEV_INTEGRITY
 	select DM_BUFIO
 	select CRYPTO
+	select CRYPTO_SKCIPHER
 	select ASYNC_XOR
 	---help---
 	  This device-mapper target emulates a block device that has
-- 
2.27.0

