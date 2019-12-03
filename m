Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3967A111FCF
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfLCWiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbfLCWiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6BB20863;
        Tue,  3 Dec 2019 22:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412734;
        bh=IC6o68mrLdx4mysFXDFXgdZP+YGES3DYn46twtdjoEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/jGHXz7Tkrc/xgNH9cAEX1HqNIZ4NsgPzzwZ7KELSwIQCudpTkNUQPgfV9XMjL32
         bUNx7Tnjv0JXshuHArqBKYTpWdBJIId8Qt8n5C/sZoUz3XoVG2XtfLpO7Cck38HFE2
         zPlvjD+BkuIsMKTDhQBJ15EIdVR3nRzpoGMHI+A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Joel Stanley <joel@jms.id.au>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 42/46] Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"
Date:   Tue,  3 Dec 2019 23:36:02 +0100
Message-Id: <20191203212805.427358245@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit 6e78c01fde9023e0701f3af880c1fd9de6e4e8e3 upstream.

This reverts commit f2538f999345405f7d2e1194c0c8efa4e11f7b3a. The patch
stopped JFFS2 from being able to mount an existing filesystem with the
following errors:

 jffs2: error: (77) jffs2_build_inode_fragtree: Add node to tree failed -22
 jffs2: error: (77) jffs2_do_read_inode_internal: Failed to build final fragtree for inode #5377: error -22

Fixes: f2538f999345 ("jffs2: Fix possible null-pointer dereferences...")
Cc: stable@vger.kernel.org
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/nodelist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jffs2/nodelist.c
+++ b/fs/jffs2/nodelist.c
@@ -226,7 +226,7 @@ static int jffs2_add_frag_to_fragtree(st
 		lastend = this->ofs + this->size;
 	} else {
 		dbg_fragtree2("lookup gave no frag\n");
-		return -EINVAL;
+		lastend = 0;
 	}
 
 	/* See if we ran off the end of the fragtree */


