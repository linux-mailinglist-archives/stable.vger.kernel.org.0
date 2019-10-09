Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9CD16E2
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbfJIRfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:35:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44872 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731145AbfJIRfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 13:35:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id u12so1837081pgb.11;
        Wed, 09 Oct 2019 10:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nj9rSb6+A9rvujRfiVZZzuEm43YQDU7Btaig5FdBlVs=;
        b=p2naQpfKkUyVP/r5NFyocBbjnhvhMPF5uKg/TmLzNENbyRQacdtHkqs9NGbt3/y8jS
         mfEeh2IfnCdEggqSHkgvLj6oQNAfjlNZS5V5sh5GLcP9ZAuAO7J3B042ax3MCWgywu/n
         oDdicrt2Fn/77UkZb9yYKGciGardpeP4A/IaMF+iw0+CRmQ/cTkeNzoH57lhmHQhulZu
         afNycQref9u0f9yqBIankmiWXYMglH1V0cUbItuy74Z6V+Ql7g5rmLNTFr5/+L7VKfQ+
         2AFAxOMmvm+KgRvkEWdRZn1dSxjM6GODEKmLCk5ygMUnPVmQ8griVlsHMOQl9f7YISJt
         JnMg==
X-Gm-Message-State: APjAAAUElkOb4UnqilooKd9S0D7ftIa6aEjsmMWvEhOWiTHOSpAvBV4a
        A2cy+avmpMTzrMLkomMbn0o=
X-Google-Smtp-Source: APXvYqycBmCFvgBWin/59P0yH6yBKADVg4UJZBU0cr3asYVbdrEcEgsOycsuSlQ5QHrDbwNsFOPy9g==
X-Received: by 2002:a63:231e:: with SMTP id j30mr5734299pgj.419.1570642544058;
        Wed, 09 Oct 2019 10:35:44 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c11sm4161190pfj.114.2019.10.09.10.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 10:35:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Rob Turk <robtu@rtist.nl>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
Subject: [PATCH] ch: Make it again possible to open a ch device two or more times
Date:   Wed,  9 Oct 2019 10:35:36 -0700
Message-Id: <20191009173536.247889-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clearing ch->device in ch_release() is wrong because that pointer must
remain valid until ch_remove() is called. This patch fixes the following
crash the second time a ch device is opened:

BUG: kernel NULL pointer dereference, address: 0000000000000790
RIP: 0010:scsi_device_get+0x5/0x60
Call Trace:
 ch_open+0x4c/0xa0 [ch]
 chrdev_open+0xa2/0x1c0
 do_dentry_open+0x13a/0x380
 path_openat+0x591/0x1470
 do_filp_open+0x91/0x100
 do_sys_open+0x184/0x220
 do_syscall_64+0x5f/0x1a0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: Rob Turk <robtu@rtist.nl>
Suggested-by: Rob Turk <robtu@rtist.nl>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
Fixes: 085e56766f74 ("scsi: ch: add refcounting")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ch.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 5f8153c37f77..76751d6c7f0d 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -579,7 +579,6 @@ ch_release(struct inode *inode, struct file *file)
 	scsi_changer *ch = file->private_data;
 
 	scsi_device_put(ch->device);
-	ch->device = NULL;
 	file->private_data = NULL;
 	kref_put(&ch->ref, ch_destroy);
 	return 0;
-- 
2.23.0.581.g78d2f28ef7-goog

