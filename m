Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BEE246CC4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgHQQ1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731139AbgHQQSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:18:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3322207FB;
        Mon, 17 Aug 2020 16:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681080;
        bh=AeWOSZs2Ggfl1t1WNA/c3wR5SFzllGTVFS/NVXtR+ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWsAAnSJMclLadHb4sLLTJtuE2fVlOF0tBeu34x580tm2fM/bPCDibb1558F8sGJP
         BLIqMMtTvMcI9iyWD06XLP4cAW9IAjShJiJSB8tYD3RTJ/80OpHFt5YEYgwZ3P10oh
         y1hpYn4CEREyy7kFX/w4JVBPBRWmHh28Ck1NaUSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 166/168] xen/balloon: fix accounting in alloc_xenballooned_pages error path
Date:   Mon, 17 Aug 2020 17:18:17 +0200
Message-Id: <20200817143741.956665749@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 1951fa33ec259abdf3497bfee7b63e7ddbb1a394 upstream.

target_unpopulated is incremented with nr_pages at the start of the
function, but the call to free_xenballooned_pages will only subtract
pgno number of pages, and thus the rest need to be subtracted before
returning or else accounting will be skewed.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200727091342.52325-2-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/balloon.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -632,6 +632,12 @@ int alloc_xenballooned_pages(int nr_page
  out_undo:
 	mutex_unlock(&balloon_mutex);
 	free_xenballooned_pages(pgno, pages);
+	/*
+	 * NB: free_xenballooned_pages will only subtract pgno pages, but since
+	 * target_unpopulated is incremented with nr_pages at the start we need
+	 * to remove the remaining ones also, or accounting will be screwed.
+	 */
+	balloon_stats.target_unpopulated -= nr_pages - pgno;
 	return ret;
 }
 EXPORT_SYMBOL(alloc_xenballooned_pages);


