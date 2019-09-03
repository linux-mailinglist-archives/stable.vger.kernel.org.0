Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C2BA6EAA
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbfICQ1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730964AbfICQ1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0F32343A;
        Tue,  3 Sep 2019 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528071;
        bh=y7zrbxbyuIpeUNUY35urgqiiOnBeTRg/Nw172CvPTf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkfpgPGdfz2fmWmNauNAkgvxl0v17rp9Ex+oikIiHFRZkJW9VLY2KWngITr3s1gt+
         /qrYeWecB9FS7FcNjayrQACNeXc+OOHr5E4FbvDqxagrztBCcqBZepjrkuybAcH56E
         6fe5qnEOwe3tFKVN75InuHYqTzyqJJsjXSQW6WCE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 085/167] CIFS: Fix leaking locked VFS cache pages in writeback retry
Date:   Tue,  3 Sep 2019 12:23:57 -0400
Message-Id: <20190903162519.7136-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit 165df9a080b6863ae286fa01780c13d87cd81076 ]

If we don't find a writable file handle when retrying writepages
we break of the loop and do not unlock and put pages neither from
wdata2 nor from the original wdata. Fix this by walking through
all the remaining pages and cleanup them properly.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a5cb7b2d1ac5d..86a54b809c484 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2033,12 +2033,13 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 
 		wdata2->cfile = find_writable_file(CIFS_I(inode), false);
 		if (!wdata2->cfile) {
-			cifs_dbg(VFS, "No writable handles for inode\n");
+			cifs_dbg(VFS, "No writable handle to retry writepages\n");
 			rc = -EBADF;
-			break;
+		} else {
+			wdata2->pid = wdata2->cfile->pid;
+			rc = server->ops->async_writev(wdata2,
+						       cifs_writedata_release);
 		}
-		wdata2->pid = wdata2->cfile->pid;
-		rc = server->ops->async_writev(wdata2, cifs_writedata_release);
 
 		for (j = 0; j < nr_pages; j++) {
 			unlock_page(wdata2->pages[j]);
@@ -2053,6 +2054,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 			kref_put(&wdata2->refcount, cifs_writedata_release);
 			if (is_retryable_error(rc))
 				continue;
+			i += nr_pages;
 			break;
 		}
 
@@ -2060,6 +2062,13 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 		i += nr_pages;
 	} while (i < wdata->nr_pages);
 
+	/* cleanup remaining pages from the original wdata */
+	for (; i < wdata->nr_pages; i++) {
+		SetPageError(wdata->pages[i]);
+		end_page_writeback(wdata->pages[i]);
+		put_page(wdata->pages[i]);
+	}
+
 	if (rc != 0 && !is_retryable_error(rc))
 		mapping_set_error(inode->i_mapping, rc);
 	kref_put(&wdata->refcount, cifs_writedata_release);
-- 
2.20.1

