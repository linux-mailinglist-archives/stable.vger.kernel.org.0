Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D153C4AA3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbhGLGxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239425AbhGLGto (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E034060FE3;
        Mon, 12 Jul 2021 06:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072416;
        bh=/MDQwBPu25sWYyJOfvgD8JgN3k4F4npfdpPyF70b98g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msZzFBLfyb2cgHoeLstqHWuh14qN0aUskSLBt5JN4kE4IgXM/Mo9i9MTJdZX3hUl5
         uLZevaXDAJhGqs7HyR+UaRhYpev2A53Q1qeib5Ttu2KmTwcIHZ4gOMiXNvbE/eJY5k
         tfHjsR3l5hF3WSMFFLUVe7QZuuyKFO/otVCXvWUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jeremy Kerr <jk@ozlabs.org>, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 489/593] fsi: core: Fix return of error values on failures
Date:   Mon, 12 Jul 2021 08:10:49 +0200
Message-Id: <20210712060945.009263437@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 910810945707fe9877ca86a0dca4e585fd05e37b ]

Currently the cfam_read and cfam_write functions return the provided
number of bytes given in the count parameter and not the error return
code in variable rc, hence all failures of read/writes are being
silently ignored. Fix this by returning the error code in rc.

Addresses-Coverity: ("Unused value")
Fixes: d1dcd6782576 ("fsi: Add cfam char devices")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Jeremy Kerr <jk@ozlabs.org>
Link: https://lore.kernel.org/r/20210603122812.83587-1-colin.king@canonical.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fsi/fsi-core.c b/drivers/fsi/fsi-core.c
index 4e60e84cd17a..59ddc9fd5bca 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -724,7 +724,7 @@ static ssize_t cfam_read(struct file *filep, char __user *buf, size_t count,
 	rc = count;
  fail:
 	*offset = off;
-	return count;
+	return rc;
 }
 
 static ssize_t cfam_write(struct file *filep, const char __user *buf,
@@ -761,7 +761,7 @@ static ssize_t cfam_write(struct file *filep, const char __user *buf,
 	rc = count;
  fail:
 	*offset = off;
-	return count;
+	return rc;
 }
 
 static loff_t cfam_llseek(struct file *file, loff_t offset, int whence)
-- 
2.30.2



