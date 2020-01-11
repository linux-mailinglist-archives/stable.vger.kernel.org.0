Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D70137D9C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAKJ7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgAKJ7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:59:33 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DCC2084D;
        Sat, 11 Jan 2020 09:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736773;
        bh=HIFgJAD1bqTpIP40iXmXuL5OzcjYdUclAnMKce2y3oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvQ3w0WbhEEN+SywXZte2j7Nc4j81o80jckpti/9xiybg40kZ56Z4cXVdtPMYSza/
         gA3RfOjfYNI+arWCvm6s436TpRIB4YzUxfnWLjSgG+xz00V3Jr08K/Pfv58Tex7EMF
         WHulImLI2ydaHyeTiip4GQFDxBMeLSlnNzKlcq9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Min <chanho.min@lge.com>,
        Jinsuk Choi <jjinsuk.choi@lge.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 21/91] mm/zsmalloc.c: fix the migrated zspage statistics.
Date:   Sat, 11 Jan 2020 10:49:14 +0100
Message-Id: <20200111094851.756485766@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
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
@@ -2138,6 +2138,11 @@ int zs_page_migrate(struct address_space
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


