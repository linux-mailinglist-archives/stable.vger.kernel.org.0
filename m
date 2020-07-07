Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891572171DC
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgGGP0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730270AbgGGP0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 500C02078D;
        Tue,  7 Jul 2020 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135581;
        bh=ISNzpa7ny7l40jBlFAU0uG+mNebx2zp/Zz4x0X73iKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6swsNK9Y8CVrBSl90XS0UkOjyRK435JKytFrFML0u4LirvlMZjCO1WmEjW9jTkkQ
         Zy1c2wZdZEktLsJQzuYQ+n8YoCXTIeqrv2t/XkNFLadFPuwKxCyxMZwihCmYl46qj4
         0sQIP6YulB0YhXxcO6wuv22nRM9Txy9sJjm5tt0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.7 098/112] gfs2: fix trans slab error when withdraw occurs inside log_flush
Date:   Tue,  7 Jul 2020 17:17:43 +0200
Message-Id: <20200707145805.638478632@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 58e08e8d83ab03a1ca25d53420bd0b87f2dfe458 upstream.

Log flush operations (gfs2_log_flush()) can target a specific transaction.
But if the function encounters errors (e.g. io errors) and withdraws,
the transaction was only freed it if was queued to one of the ail lists.
If the withdraw occurred before the transaction was queued to the ail1
list, function ail_drain never freed it. The result was:

BUG gfs2_trans: Objects remaining in gfs2_trans on __kmem_cache_shutdown()

This patch makes log_flush() add the targeted transaction to the ail1
list so that function ail_drain() will find and free it properly.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/log.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -987,6 +987,16 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
 
 out:
 	if (gfs2_withdrawn(sdp)) {
+		/**
+		 * If the tr_list is empty, we're withdrawing during a log
+		 * flush that targets a transaction, but the transaction was
+		 * never queued onto any of the ail lists. Here we add it to
+		 * ail1 just so that ail_drain() will find and free it.
+		 */
+		spin_lock(&sdp->sd_ail_lock);
+		if (tr && list_empty(&tr->tr_list))
+			list_add(&tr->tr_list, &sdp->sd_ail1_list);
+		spin_unlock(&sdp->sd_ail_lock);
 		ail_drain(sdp); /* frees all transactions */
 		tr = NULL;
 	}


