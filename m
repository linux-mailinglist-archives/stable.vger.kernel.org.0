Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F808D6E0
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 17:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHNPJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 11:09:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45127 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNPJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 11:09:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id w26so8476892pfq.12
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 08:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IUmHYWSvqGvDlE5fCA2dGLGnHLe5dTz4b/3dg3VtZ5o=;
        b=CVzXSJd1tggLsODZFvUEpYWvDdQERKXQhWO5hgcBgc5h4Fl8+2zsuVNRnnIWI74yfO
         rjrHzoDGfRwBJKSrsNNLDEpNtQcwMMXx0Gfbj2qpCj7WzqB8UpeIGua20iaZa4nJDsgt
         Wg5/F1sawIMO5MR7wcEcZcw8Bn1BYpPrSdcsYqDyHF7yD83ph+Q2doR0+w6hLZXBLHlo
         2r1b6/WCGyDYdgbt8vs3oFOk8U8XIE1+VPONSdfm5R4aWaoIE69mvMS6XDurxHHB+Gxa
         vfvNU9NYAKsT87PGiEYebUDR+9y12hEyEAk67ag869GJVtMXasP/kMr1c2IlusJOHyv5
         bhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IUmHYWSvqGvDlE5fCA2dGLGnHLe5dTz4b/3dg3VtZ5o=;
        b=sdiJbqPnniYwBdZTOSuKEwgOmrH9eKTkRDz88VLCCeG2Ise7SEAl3S5GSVfIvPONBs
         1T6qVVq6wB85JDNGb0MqtgXm6feGlZznqp4OrIC8edi/eMWkEzSeMAv6pGYk58JX17IF
         ft6/smze0ODelE/+WlpoqxnNCSH28uv1TQ/X3TDyN3u10sXDMP55eqKgRA46VTMld3tq
         WWzHAydd5kyhT/Y8v0ynvs6V7Ecyurr6jQwvqhmSCOgQ5UkcLqqt2Mt3+jIkuV8zYGoT
         7dAgsi5gzsdauLaHD3f+UKmNB10YjHN7/VfZdOIHIxqm9EYhG63ayv22afEDhphwpQhW
         OYtQ==
X-Gm-Message-State: APjAAAWzaNd5f7Dt4hSwLVt+p3PR/ZaZuwdMCc8y/oFjsNRs6PNcuclu
        a8avqO/MWHqTV6DbUxqp7UxIygCcW8Y4Ng==
X-Google-Smtp-Source: APXvYqyk/Y+CHicjriVyQvQr4+Q4Zoe3wvrsm+JIGSK4xb9QsII/6kHbx42A/CDWBUSTkiNQuCxdng==
X-Received: by 2002:a65:430b:: with SMTP id j11mr38903929pgq.383.1565795384329;
        Wed, 14 Aug 2019 08:09:44 -0700 (PDT)
Received: from rmonther.bne.com ([149.167.105.241])
        by smtp.googlemail.com with ESMTPSA id 67sm246499pjo.29.2019.08.14.08.09.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 08:09:43 -0700 (PDT)
From:   Monthero Ronald <rhmcruiser@gmail.com>
To:     viro@zeniv.linux.org.uk
Cc:     stable@vger.kernel.org, Monthero Ronald <rhmcruiser@gmail.com>
Subject: [PATCH] fs: buffer: Check to avoid NULL pointer dereference of returned buffer_head for a private page
Date:   Thu, 15 Aug 2019 01:09:11 +1000
Message-Id: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch checks for this condition of NULL pointer for the buffer_head returned from page_buffers()
and also a check placed within the list traversal loop for next buffer_head structs.

crash scenario:
The buffer_head returned from page_buffers() is not checked in block_invalidatepage_range function.
The struct buffer_head* pointer returned by page_buffers(page) was 0x0, although this page had its
private flag PG_private bit set and was expected to have buffer_head structs attached.The NULL pointer
buffer_head was dereferenced in block_invalidatepage_range function at bh->b_size, where bh returned by
page_buffers(page) was 0x0.

The stack frames were  truncate_inode_page() => do_invalidatepage_range() => xfs_vm_invalidatepage() =>
          [exception RIP: block_invalidatepage_range+132]

The inode for truncate in this case was valid and had  proper inode.i_state = 0x20 - FREEING and had
a valid mapped address space to xfs. And the struct page in context of block_invalidatepage_range()
had its page flag PG_private set but the page.private was 0x0. So page_buffers(page) returned 0x0
and hence the crash.
This patch performs NULL pointer check for returned buffer_head. Applies to 3.16 and later kernels.

Signed-off-by: Monthero Ronald <rhmcruiser@gmail.com>
---
 fs/buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index eba6e4f..fa80cf4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1541,6 +1541,7 @@ void block_invalidatepage(struct page *page, unsigned int offset,
 	BUG_ON(stop > PAGE_CACHE_SIZE || stop < length);
 
 	head = page_buffers(page);
+	BUG_ON(!head);
 	bh = head;
 	do {
 		unsigned int next_off = curr_off + bh->b_size;
@@ -1559,6 +1560,7 @@ void block_invalidatepage(struct page *page, unsigned int offset,
 			discard_buffer(bh);
 		curr_off = next_off;
 		bh = next;
+		BUG_ON(!bh);
 	} while (bh != head);
 
 	/*
-- 
1.8.3.1

