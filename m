Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189CB2B644A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732027AbgKQNp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732736AbgKQNje (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37FA724686;
        Tue, 17 Nov 2020 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620373;
        bh=a++5pX6LYbrmR0abOiTDtqu6oEjVo+MRQja8dm5Y104=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=po1QfH+oawiFXwSkLMkFPd9MQjgSIWTgQkiEg6hhOWrNR2Gh5KRqXSt76SUlQ4ESt
         yNcOe8XMORtdF0DSkA+eC5KTXYBmEj/YIkywIlOSCoAyMEfZuXYJD1twaLMmBkc8vT
         fLLxak7QMA7L6Gn+sSOH9/h+pF+yk6jJuUpCxyAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Petr Vorel <pvorel@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 197/255] block: add a return value to set_capacity_revalidate_and_notify
Date:   Tue, 17 Nov 2020 14:05:37 +0100
Message-Id: <20201117122148.517812147@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7e890c37c25c7cbca37ff0ab292873d8146e713b upstream.

Return if the function ended up sending an uevent or not.

Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/genhd.c         |    5 ++++-
 include/linux/genhd.h |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -49,7 +49,7 @@ static void disk_release_events(struct g
  * Set disk capacity and notify if the size is not currently
  * zero and will not be set to zero
  */
-void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
+bool set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
 					bool revalidate)
 {
 	sector_t capacity = get_capacity(disk);
@@ -63,7 +63,10 @@ void set_capacity_revalidate_and_notify(
 		char *envp[] = { "RESIZE=1", NULL };
 
 		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
+		return true;
 	}
+
+	return false;
 }
 
 EXPORT_SYMBOL_GPL(set_capacity_revalidate_and_notify);
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -315,7 +315,7 @@ static inline int get_disk_ro(struct gen
 extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
-extern void set_capacity_revalidate_and_notify(struct gendisk *disk,
+extern bool set_capacity_revalidate_and_notify(struct gendisk *disk,
 			sector_t size, bool revalidate);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
 


