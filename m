Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9202FA8B6
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405545AbhARPG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390784AbhARLmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0047022D3E;
        Mon, 18 Jan 2021 11:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970122;
        bh=LI0bfn1qrxCNxBHyYC+ws2yo72/ytcyeMI2UR/92oqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSR+7lIluCRCbglBR1s0e7PxHhgf487OHrwxXDuh2/nBjaJ3iHS7YZI1iCjv5fc27
         i7VjMvT9ybY0HQxHN6cSrp8W1SiNhxl+pPv7JQNqaZzrKjvQcOlpvQJ5Jtzek8ddO3
         K9M7Eml21pMo4ZJCzJB5PIdzTx+FmSI99fXFHzdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ignat Korchagin <ignat@cloudflare.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 047/152] dm crypt: do not call bio_endio() from the dm-crypt tasklet
Date:   Mon, 18 Jan 2021 12:33:42 +0100
Message-Id: <20210118113355.042583605@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ignat Korchagin <ignat@cloudflare.com>

commit 8e14f610159d524cd7aac37982826d3ef75c09e8 upstream.

Sometimes, when dm-crypt executes decryption in a tasklet, we may get
"BUG: KASAN: use-after-free in tasklet_action_common.constprop..."
with a kasan-enabled kernel.

When the decryption fully completes in the tasklet, dm-crypt will call
bio_endio(), which in turn will call clone_endio() from dm.c core code. That
function frees the resources associated with the bio, including per bio private
structures. For dm-crypt it will free the current struct dm_crypt_io, which
contains our tasklet object, causing use-after-free, when the tasklet is being
dequeued by the kernel.

To avoid this, do not call bio_endio() from the current tasklet context, but
delay its execution to the dm-crypt IO workqueue.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1730,6 +1730,12 @@ static void crypt_inc_pending(struct dm_
 	atomic_inc(&io->io_pending);
 }
 
+static void kcryptd_io_bio_endio(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	bio_endio(io->base_bio);
+}
+
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1752,7 +1758,23 @@ static void crypt_dec_pending(struct dm_
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
-	bio_endio(base_bio);
+
+	/*
+	 * If we are running this function from our tasklet,
+	 * we can't call bio_endio() here, because it will call
+	 * clone_endio() from dm.c, which in turn will
+	 * free the current struct dm_crypt_io structure with
+	 * our tasklet. In this case we need to delay bio_endio()
+	 * execution to after the tasklet is done and dequeued.
+	 */
+	if (tasklet_trylock(&io->tasklet)) {
+		tasklet_unlock(&io->tasklet);
+		bio_endio(base_bio);
+		return;
+	}
+
+	INIT_WORK(&io->work, kcryptd_io_bio_endio);
+	queue_work(cc->io_queue, &io->work);
 }
 
 /*


