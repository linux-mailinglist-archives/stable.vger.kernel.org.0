Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837BB2E9A77
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbhADQKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:10:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbhADQBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5602121D93;
        Mon,  4 Jan 2021 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776093;
        bh=+XWpYRlH14aguLeK/2XmnIRiLYQgDpkgVIGis8LuEFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwgztkKPF9jqYhW6/CbAYet4f+fsiz8jMDcAmumjSBYGvrF9BQxumG0YSfX7eo1nL
         41edqt/5ZnUDfuxhs64aqDsvDC5ot6qKNasihlYElZ9DOfimnB4vjsIOi1BAffJanB
         uBIrL6dkC9/7dyLgMiwt9u98c7S9321WJ0Vf5FjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 19/63] io_uring: add a helper for setting a ref node
Date:   Mon,  4 Jan 2021 16:57:12 +0100
Message-Id: <20210104155709.749086373@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1642b4450d20e31439c80c28256c8eee08684698 upstream.

Setting a new reference node to a file data is not trivial, don't repeat
it, add and use a helper.

Cc: stable@vger.kernel.org # 5.6+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6991,6 +6991,16 @@ static void io_file_ref_kill(struct perc
 	complete(&data->done);
 }
 
+static void io_sqe_files_set_node(struct fixed_file_data *file_data,
+				  struct fixed_file_ref_node *ref_node)
+{
+	spin_lock_bh(&file_data->lock);
+	file_data->node = ref_node;
+	list_add_tail(&ref_node->node, &file_data->ref_list);
+	spin_unlock_bh(&file_data->lock);
+	percpu_ref_get(&file_data->refs);
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_file_data *data = ctx->file_data;
@@ -7519,11 +7529,7 @@ static int io_sqe_files_register(struct
 		return PTR_ERR(ref_node);
 	}
 
-	file_data->node = ref_node;
-	spin_lock_bh(&file_data->lock);
-	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock_bh(&file_data->lock);
-	percpu_ref_get(&file_data->refs);
+	io_sqe_files_set_node(file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7679,11 +7685,7 @@ static int __io_sqe_files_update(struct
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		spin_lock_bh(&data->lock);
-		list_add_tail(&ref_node->node, &data->ref_list);
-		data->node = ref_node;
-		spin_unlock_bh(&data->lock);
-		percpu_ref_get(&ctx->file_data->refs);
+		io_sqe_files_set_node(data, ref_node);
 	} else
 		destroy_fixed_file_ref_node(ref_node);
 


