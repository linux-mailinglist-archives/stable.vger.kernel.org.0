Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730C6CA5B3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404341AbfJCQfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404335AbfJCQft (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4813520830;
        Thu,  3 Oct 2019 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120548;
        bh=wacoWmoaqhJ4gxuQ3wZXfgOE/GMA7IuQ3de0W36+LKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayCRoYtSCKmbfmRVXrfcPlPzZYvkWehMViahfeIJz3+zMAEYJ2leHZD74mJDWhC9q
         KK5o+LcutR244vHVoEDU1POsRiQkk9eVBe4Ei6Af3J3HBromn8zZsJ1k8UGM500xmJ
         u1FsdWXAkoNkDaGXNJqdZLFk07IWSsVpbIT1zwlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.2 263/313] gfs2: clear buf_in_tr when ending a transaction in sweep_bh_for_rgrps
Date:   Thu,  3 Oct 2019 17:54:01 +0200
Message-Id: <20191003154558.940882423@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit f0b444b349e33ae0d3dd93e25ca365482a5d17d4 upstream.

In function sweep_bh_for_rgrps, which is a helper for punch_hole,
it uses variable buf_in_tr to keep track of when it needs to commit
pending block frees on a partial delete that overflows the
transaction created for the delete. The problem is that the
variable was initialized at the start of function sweep_bh_for_rgrps
but it was never cleared, even when starting a new transaction.

This patch reinitializes the variable when the transaction is
ended, so the next transaction starts out with it cleared.

Fixes: d552a2b9b33e ("GFS2: Non-recursive delete")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/bmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1670,6 +1670,7 @@ out_unlock:
 			brelse(dibh);
 			up_write(&ip->i_rw_mutex);
 			gfs2_trans_end(sdp);
+			buf_in_tr = false;
 		}
 		gfs2_glock_dq_uninit(rd_gh);
 		cond_resched();


