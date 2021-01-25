Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B2A302AB4
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbhAYSuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730916AbhAYStA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9692220719;
        Mon, 25 Jan 2021 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600500;
        bh=z2nkGx7jaZFwXVnkf+A3FUsnCvzbVcIGaL9Lh8Z7U58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1A2yob9te+HI4dRQXNFigsPT6q8r7QBmAG/QOlueEOc6MnzD6ULFFga5zR2XZCxd
         6T/bArJgZPxA4yAtVtB9QaOfZuX0LQJ70jlwAakYZRKdn90aBxOLzjDstyOK41aOHi
         46BT1D22oWBpY1o0xB5eoqM5CTatKirTMM8XKCBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/199] dm integrity: select CRYPTO_SKCIPHER
Date:   Mon, 25 Jan 2021 19:37:41 +0100
Message-Id: <20210125183217.894969768@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0e04d3718af3c..2cefb075b2b84 100644
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



