Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5771B1F21
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389799AbfIMNQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389787AbfIMNQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:10 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F40206A5;
        Fri, 13 Sep 2019 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380569;
        bh=2MotSDzYBMQnVbaO4Ad5yPeQ1EQWWXr5aIP3vatel6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oC3NMZqRztwqB+6/DJVplgH+kemDq0lF16RPUS7eHsdoLRfRdpkA0aiGe0Gud1YJO
         0Y/WsdeoRp5IK0v8+qrVCsx0V1pyrtyQ2MrEqwqPPD00Wdgiv8bMHR3wwwZUKXgY0V
         8T2Jytg6IRgDt6zc3J99hVczmywUbs75Xub+KHug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/190] CIFS: Fix leaking locked VFS cache pages in writeback retry
Date:   Fri, 13 Sep 2019 14:06:02 +0100
Message-Id: <20190913130608.245039576@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



