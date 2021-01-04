Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D9C2E9A4F
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbhADQIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728658AbhADQBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18169207AE;
        Mon,  4 Jan 2021 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776091;
        bh=VeG+Jo+SVrDVThJun5BeCxAaps55b6Q6aE/VapoYbF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GqK1O55UuSpZAJjafP9ePMW8BnaIt9Rix23RQkpy81GbzsoH+YHJuty9Pv56BR6V
         nzx+NXokJJ1zOZA+8AI6CVEiU2NMjJOhY+SyxgSUWgCsquNHf+6lSkA6vVC95P6oDW
         ZjdxOtSVJVgatNi8c+8rLVlCLmjEzBjIAksK1KNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1f4ba1e5520762c523c6@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 18/63] io_uring: use bottom half safe lock for fixed file data
Date:   Mon,  4 Jan 2021 16:57:11 +0100
Message-Id: <20210104155709.700408041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit ac0648a56c1ff66c1cbf735075ad33a26cbc50de upstream.

io_file_data_ref_zero() can be invoked from soft-irq from the RCU core,
hence we need to ensure that the file_data lock is bottom half safe. Use
the _bh() variants when grabbing this lock.

Reported-by: syzbot+1f4ba1e5520762c523c6@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7000,9 +7000,9 @@ static int io_sqe_files_unregister(struc
 	if (!data)
 		return -ENXIO;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	ref_node = data->node;
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7385,7 +7385,7 @@ static void io_file_data_ref_zero(struct
 	data = ref_node->file_data;
 	ctx = data->ctx;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	ref_node->done = true;
 
 	while (!list_empty(&data->ref_list)) {
@@ -7397,7 +7397,7 @@ static void io_file_data_ref_zero(struct
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->file_put_llist);
 	}
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7520,9 +7520,9 @@ static int io_sqe_files_register(struct
 	}
 
 	file_data->node = ref_node;
-	spin_lock(&file_data->lock);
+	spin_lock_bh(&file_data->lock);
 	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock(&file_data->lock);
+	spin_unlock_bh(&file_data->lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
 out_fput:
@@ -7679,10 +7679,10 @@ static int __io_sqe_files_update(struct
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		spin_lock(&data->lock);
+		spin_lock_bh(&data->lock);
 		list_add_tail(&ref_node->node, &data->ref_list);
 		data->node = ref_node;
-		spin_unlock(&data->lock);
+		spin_unlock_bh(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);
 	} else
 		destroy_fixed_file_ref_node(ref_node);


