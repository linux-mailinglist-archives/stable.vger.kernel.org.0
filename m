Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BF69E0CB
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfH0IGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732950AbfH0IGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7978E2173E;
        Tue, 27 Aug 2019 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893163;
        bh=0DycLuveW5FDNilqnGAQJPiUrr9aDswSq/e6SVSBy+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZQeaAhYKkDd0MG1r1T0LekVP6dt/NPr7zABcpXOLaxVSrRQeM7HiBDiPD1Mp55Mm
         xB6re7Gs6O8ZJBHRLL8B5GU8AsNOon1ajxI2m+Yuk0GfkvzlIweIuR4Hm91gSn5qai
         WsZf34DBOLWDrZ4hHJtUb7jRnhsEqE+3PX3buRZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Tao <kontais@zoho.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.2 141/162] dm table: fix invalid memory accesses with too high sector number
Date:   Tue, 27 Aug 2019 09:51:09 +0200
Message-Id: <20190827072743.560713694@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1cfd5d3399e87167b7f9157ef99daa0e959f395d upstream.

If the sector number is too high, dm_table_find_target() should return a
pointer to a zeroed dm_target structure (the caller should test it with
dm_target_is_valid).

However, for some table sizes, the code in dm_table_find_target() that
performs btree lookup will access out of bound memory structures.

Fix this bug by testing the sector number at the beginning of
dm_table_find_target(). Also, add an "inline" keyword to the function
dm_table_get_size() because this is a hot path.

Fixes: 512875bd9661 ("dm: table detect io beyond device")
Cc: stable@vger.kernel.org
Reported-by: Zhang Tao <kontais@zoho.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1334,7 +1334,7 @@ void dm_table_event(struct dm_table *t)
 }
 EXPORT_SYMBOL(dm_table_event);
 
-sector_t dm_table_get_size(struct dm_table *t)
+inline sector_t dm_table_get_size(struct dm_table *t)
 {
 	return t->num_targets ? (t->highs[t->num_targets - 1] + 1) : 0;
 }
@@ -1359,6 +1359,9 @@ struct dm_target *dm_table_find_target(s
 	unsigned int l, n = 0, k = 0;
 	sector_t *node;
 
+	if (unlikely(sector >= dm_table_get_size(t)))
+		return &t->targets[t->num_targets];
+
 	for (l = 0; l < t->depth; l++) {
 		n = get_child(n, k);
 		node = get_node(t, l, n);


