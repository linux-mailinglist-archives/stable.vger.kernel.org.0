Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6082C9D5D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389831AbgLAJWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389155AbgLAJH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04732067D;
        Tue,  1 Dec 2020 09:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813637;
        bh=VAJnG8/aAnLqoLfCaMnKUy66gVg40xhpH/2wKr56+vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGLXTVciPyo+KhqevRxp0/BRnjDM1oC6pPhdLWwFZhd9FOxC11AuxuDhH1vgcAFpt
         Vb87yzgXTd4LzcKpXPeykvsWtJqVBKbV8S/SiEUCsip3Bz1W4i0i7lZmpmSs46Cmps
         /HbVNmwI46WJxjjOTj8hctff23C4HeTj8nBz99+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 001/152] io_uring: get an active ref_node from files_data
Date:   Tue,  1 Dec 2020 09:51:56 +0100
Message-Id: <20201201084711.858351374@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1e5d770bb8a23dd01e28e92f4fb0b1093c8bdbe6 upstream.

An active ref_node always can be found in ctx->files_data, it's much
safer to get it this way instead of poking into files_data->ref_list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6854,9 +6854,8 @@ static int io_sqe_files_unregister(struc
 		return -ENXIO;
 
 	spin_lock(&data->lock);
-	if (!list_empty(&data->ref_list))
-		ref_node = list_first_entry(&data->ref_list,
-				struct fixed_file_ref_node, node);
+	ref_node = container_of(data->cur_refs, struct fixed_file_ref_node,
+				refs);
 	spin_unlock(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);


