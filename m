Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1537121447
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfLPSJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbfLPSJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28350206EC;
        Mon, 16 Dec 2019 18:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519798;
        bh=IWANP2m/HdiV9PxPUQGlMOT2EXU8H0Be69ffeLkXblc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6/J5QEmmw2c6y2ptCI6bpe1zw40it43KTDYK9Y3nBWhHafAu7WCNm69JPS+s4HY2
         BDe3b7s0tQU70xvYbumbUoAA/uNR1QO3GooCUYWCglWYkNwpNrOYPNw+EoFX+cmb03
         FeUsTBb5hO8Oc5SJjrk7gibY7xGHdR8goQdlfwMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maged Mokhtar <mmokhtar@petasan.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.3 071/180] dm writecache: handle REQ_FUA
Date:   Mon, 16 Dec 2019 18:48:31 +0100
Message-Id: <20191216174830.280901804@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maged Mokhtar <mmokhtar@petasan.org>

commit c1005322ff02110a4df7f0033368ea015062b583 upstream.

Call writecache_flush() on REQ_FUA in writecache_map().

Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1218,7 +1218,8 @@ bio_copy:
 			}
 		} while (bio->bi_iter.bi_size);
 
-		if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks))
+		if (unlikely(bio->bi_opf & REQ_FUA ||
+			     wc->uncommitted_blocks >= wc->autocommit_blocks))
 			writecache_flush(wc);
 		else
 			writecache_schedule_autocommit(wc);


