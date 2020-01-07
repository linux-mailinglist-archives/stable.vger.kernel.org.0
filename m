Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3402C13329A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgAGVLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:11:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgAGVLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:11:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5F4C208C4;
        Tue,  7 Jan 2020 21:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431461;
        bh=U1YS3RHoAnAMjr8JJZz4F/JAG1SODn7XzG/Pl+c24s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+cP2m7THojaqi6/bvNQhpophNGl9R1sdtsboB4RZRfk1BCbWhhoBZxJCVdFQZmXy
         RQfj9CeztxM4W7SPumsaMGVBc+lHANSbjrt1TnPi1ELV2K/lO25U9re31y/giWYq8U
         gm4onpwbse6fsyjG+LDPyytf2kMGcAYLlZ9tEiNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Min <chanho.min@lge.com>,
        Jinsuk Choi <jjinsuk.choi@lge.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 29/74] mm/zsmalloc.c: fix the migrated zspage statistics.
Date:   Tue,  7 Jan 2020 21:54:54 +0100
Message-Id: <20200107205200.152076190@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanho Min <chanho.min@lge.com>

commit ac8f05da5174c560de122c499ce5dfb5d0dfbee5 upstream.

When zspage is migrated to the other zone, the zone page state should be
updated as well, otherwise the NR_ZSPAGE for each zone shows wrong
counts including proc/zoneinfo in practice.

Link: http://lkml.kernel.org/r/1575434841-48009-1-git-send-email-chanho.min@lge.com
Fixes: 91537fee0013 ("mm: add NR_ZSMALLOC to vmstat")
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Jinsuk Choi <jjinsuk.choi@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>        [4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/zsmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2088,6 +2088,11 @@ int zs_page_migrate(struct address_space
 		zs_pool_dec_isolated(pool);
 	}
 
+	if (page_zone(newpage) != page_zone(page)) {
+		dec_zone_page_state(page, NR_ZSPAGES);
+		inc_zone_page_state(newpage, NR_ZSPAGES);
+	}
+
 	reset_page(page);
 	put_page(page);
 	page = newpage;


