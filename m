Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3280F3535C
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfFDXYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbfFDXYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AF3208C3;
        Tue,  4 Jun 2019 23:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690674;
        bh=0xDaq6sf4YN7169JdPWC6VPkMZp1QHIpgS/sexm+Gb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm1Ug9f/T1L7XB6W6PGlOitRa1VJaONMNE1TYy0rmZV5DRrOq2ypRXtyJmaLN3rVy
         w5fJJcMw2n7vDot6U72VlM4C1f59TM8pfm4dWKDBFM4lAujf/i6pazyT8HrwBt63Eb
         Df7wDDlyA6S7r2diZsu7ejYz6hAWn/MdTwDHRZLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Young Xiao <YangX92@hotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 08/24] Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_var
Date:   Tue,  4 Jun 2019 19:23:59 -0400
Message-Id: <20190604232416.7479-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232416.7479-1-sashal@kernel.org>
References: <20190604232416.7479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young Xiao <YangX92@hotmail.com>

[ Upstream commit b281218ad4311a0342a40cb02fb17a363df08b48 ]

There is an out-of-bounds access to "config[len - 1]" array when the
variable "len" is zero.

See commit dada6a43b040 ("kgdboc: fix KASAN global-out-of-bounds bug
in param_set_kgdboc_var()") for details.

Signed-off-by: Young Xiao <YangX92@hotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/kgdbts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index fc7efedbc4be..94cbc5c98cae 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -1134,7 +1134,7 @@ static void kgdbts_put_char(u8 chr)
 
 static int param_set_kgdbts_var(const char *kmessage, struct kernel_param *kp)
 {
-	int len = strlen(kmessage);
+	size_t len = strlen(kmessage);
 
 	if (len >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdbts: config string too long\n");
@@ -1154,7 +1154,7 @@ static int param_set_kgdbts_var(const char *kmessage, struct kernel_param *kp)
 
 	strcpy(config, kmessage);
 	/* Chop out \n char as a result of echo */
-	if (config[len - 1] == '\n')
+	if (len && config[len - 1] == '\n')
 		config[len - 1] = '\0';
 
 	/* Go and configure with the new params. */
-- 
2.20.1

