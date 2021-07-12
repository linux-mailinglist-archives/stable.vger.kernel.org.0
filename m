Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D253C4FD4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343547AbhGLH2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245030AbhGLH1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:27:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1683161436;
        Mon, 12 Jul 2021 07:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074582;
        bh=/MDQwBPu25sWYyJOfvgD8JgN3k4F4npfdpPyF70b98g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xg9tp2oZTIS7d9MaImp07LjlsVWkmRJon5DNdEtGbId8ZMtpD4CnoYLFFXz9ZdFUk
         Lt+++rg3JmZAvMtGVvJWDE8jrOSPJ3Lma0M9HGo9PKeEpgFVBc6lCy9IZVj8GnkrIb
         t/5QS+gFTFfAgHLLawO184hNuVGFNrSxPRgID8xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jeremy Kerr <jk@ozlabs.org>, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 585/700] fsi: core: Fix return of error values on failures
Date:   Mon, 12 Jul 2021 08:11:08 +0200
Message-Id: <20210712061038.284546656@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



