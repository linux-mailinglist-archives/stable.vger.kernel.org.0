Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D001E4D87E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfFTS1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbfFTSFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:05:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E9A204FD;
        Thu, 20 Jun 2019 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053923;
        bh=K0D5RiaBxXVakvVfZoWJm431MDLU2u7E5g65ouIOmp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDymvYj4RjXdEGaUGvG1GP0dbPBCYgIuI17STwCAPv/ZzaM4r4GwtNm419LxAvf/r
         urM3fq5oq3pvCW75ceiRZ4YfkGIfOTvHcboQc2sKscASollAUy4MhJ3VfEqQg10rdn
         tTHgpqi9ed71g3sjbtl/myLXgDgZ+aZG1jzQ8QVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <YangX92@hotmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 073/117] Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_var
Date:   Thu, 20 Jun 2019 19:56:47 +0200
Message-Id: <20190620174356.961101617@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 99635dd9dbac..bb3a76ad80da 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -1132,7 +1132,7 @@ static void kgdbts_put_char(u8 chr)
 
 static int param_set_kgdbts_var(const char *kmessage, struct kernel_param *kp)
 {
-	int len = strlen(kmessage);
+	size_t len = strlen(kmessage);
 
 	if (len >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdbts: config string too long\n");
@@ -1152,7 +1152,7 @@ static int param_set_kgdbts_var(const char *kmessage, struct kernel_param *kp)
 
 	strcpy(config, kmessage);
 	/* Chop out \n char as a result of echo */
-	if (config[len - 1] == '\n')
+	if (len && config[len - 1] == '\n')
 		config[len - 1] = '\0';
 
 	/* Go and configure with the new params. */
-- 
2.20.1



