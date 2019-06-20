Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6EB4D1EC
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 17:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbfFTPSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 11:18:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45363 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731791AbfFTPSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 11:18:52 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so777502ioc.12
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 08:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LbaJcyWYnbCa5ezoro66saapuXs/2zff7F4rgt4jO/0=;
        b=Vgb6ZSxZHxs/uF5rGy6wsIsWX1oNvwsVPTCFF0NCmLRH7xlP6b3yhvsiikpiDNYTsl
         fFr9zFv5G8yh1I0ISPt9HhTsz4g31G0pXdVQ66gHrsaLY66H8TVJlwYnY/EZ4IHox7rw
         WGi3kTBfRbg/0MwUa03341kI9jQ6Pm0dIf7m4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LbaJcyWYnbCa5ezoro66saapuXs/2zff7F4rgt4jO/0=;
        b=iBkFz0cJ3uepGcVjb2wImo3S58bF/c9pxHD5fpZNYTtjBcOvTJeqcsbbylCUWdP64E
         rLlno4jwzALiw4saSso6XSxWyKc14T6Tp1/eGZxM1YlmTPpMcFTBKUQ+R0WdXwVWPVUO
         O5rLU3AVu5CN97dahvtLFYve3OsNKlc9xBTctzchstnh1MSgKtM7voXcRmSS3pvzAe9v
         jCKmVCwyd1Tei8vdCqdj/8+igFmyfVxr1bFhcOSjLluNgxe4PC76ERH1BfHD+W1Ac06r
         KyI1yP2e9PQvNlBmqOWpHHMsAWtFwIfWmqwJ5SG2s0zTdLHiqYplGTyF+lvUv1RtX2nC
         9z5w==
X-Gm-Message-State: APjAAAVW/JMZIIpPm4uId1TJxEqaV9HH+YR2L5iMtK48aSdWGCZtM4Da
        JeAAoCzruhV2/NqpIEkRVaMsog==
X-Google-Smtp-Source: APXvYqzN4QF7VO7txjKK/zwdz7+tEgOtdahmqqRfrztYneRm16nQeJy7GrQuF3sgTYRsfdJ7IOKEpw==
X-Received: by 2002:a6b:bf01:: with SMTP id p1mr50911675iof.181.1561043931856;
        Thu, 20 Jun 2019 08:18:51 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id l2sm108135ioh.20.2019.06.20.08.18.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 08:18:51 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm: add filemap_fdatawait_range_keep_errors()
Date:   Thu, 20 Jun 2019 09:18:37 -0600
Message-Id: <20190620151839.195506-2-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620151839.195506-1-zwisler@google.com>
References: <20190620151839.195506-1-zwisler@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the spirit of filemap_fdatawait_range() and
filemap_fdatawait_keep_errors(), introduce
filemap_fdatawait_range_keep_errors() which both takes a range upon
which to wait and does not clear errors from the address space.

Signed-off-by: Ross Zwisler <zwisler@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
---
 include/linux/fs.h |  2 ++
 mm/filemap.c       | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7fdfe93e25d3..79fec8a8413f4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2712,6 +2712,8 @@ extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait_keep_errors(struct address_space *mapping);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
+extern int filemap_fdatawait_range_keep_errors(struct address_space *mapping,
+		loff_t start_byte, loff_t end_byte);
 
 static inline int filemap_fdatawait(struct address_space *mapping)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index df2006ba0cfa5..e87252ca0835a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -553,6 +553,28 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
 }
 EXPORT_SYMBOL(filemap_fdatawait_range);
 
+/**
+ * filemap_fdatawait_range_keep_errors - wait for writeback to complete
+ * @mapping:		address space structure to wait for
+ * @start_byte:		offset in bytes where the range starts
+ * @end_byte:		offset in bytes where the range ends (inclusive)
+ *
+ * Walk the list of under-writeback pages of the given address space in the
+ * given range and wait for all of them.  Unlike filemap_fdatawait_range(),
+ * this function does not clear error status of the address space.
+ *
+ * Use this function if callers don't handle errors themselves.  Expected
+ * call sites are system-wide / filesystem-wide data flushers: e.g. sync(2),
+ * fsfreeze(8)
+ */
+int filemap_fdatawait_range_keep_errors(struct address_space *mapping,
+		loff_t start_byte, loff_t end_byte)
+{
+	__filemap_fdatawait_range(mapping, start_byte, end_byte);
+	return filemap_check_and_keep_errors(mapping);
+}
+EXPORT_SYMBOL(filemap_fdatawait_range_keep_errors);
+
 /**
  * file_fdatawait_range - wait for writeback to complete
  * @file:		file pointing to address space structure to wait for
-- 
2.22.0.410.gd8fdbe21b5-goog

