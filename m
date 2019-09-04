Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977D5A8ECE
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388354AbfIDSAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388352AbfIDSAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:00:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF16A22CEA;
        Wed,  4 Sep 2019 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620007;
        bh=Ui+0UrEl6Wdi7CRb8+V3zC+O+5oPfmhX1x6ySkn9Rs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZoWJPR0Izd8t6T219ZXxesPcP3VJLij6puVezaVZbiwCkrJD5fU8bRD0Hc3km9fH
         DWAGvPI0N38/gstKU9n85hDBfSikdPOA5fls766iZmeXmP8r4uYoBQ1qtseXFWDtEY
         v0cj0bprfE06vwbQ+VXKevzj/CWCJlCxPMwXS04I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Tao <kontais@zoho.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 39/83] dm table: fix invalid memory accesses with too high sector number
Date:   Wed,  4 Sep 2019 19:53:31 +0200
Message-Id: <20190904175307.275806394@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
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
@@ -1263,7 +1263,7 @@ void dm_table_event(struct dm_table *t)
 }
 EXPORT_SYMBOL(dm_table_event);
 
-sector_t dm_table_get_size(struct dm_table *t)
+inline sector_t dm_table_get_size(struct dm_table *t)
 {
 	return t->num_targets ? (t->highs[t->num_targets - 1] + 1) : 0;
 }
@@ -1288,6 +1288,9 @@ struct dm_target *dm_table_find_target(s
 	unsigned int l, n = 0, k = 0;
 	sector_t *node;
 
+	if (unlikely(sector >= dm_table_get_size(t)))
+		return &t->targets[t->num_targets];
+
 	for (l = 0; l < t->depth; l++) {
 		n = get_child(n, k);
 		node = get_node(t, l, n);


