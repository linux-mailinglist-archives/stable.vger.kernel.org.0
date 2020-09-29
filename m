Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A41B27CAE3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgI2MWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbgI2LfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 477CB23CCD;
        Tue, 29 Sep 2020 11:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378934;
        bh=GvwKOQpyOmBbreWaEVUSgWTTIcSBLsc38SJBQGiz2JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2ijCAoYg4XpbI+WSVx76Da4++J8mxXdGK0S5V5OagzWQS9OIp/0s2ACpWt/Vz24b
         X9H3j+9uT+XaJxUijR+iMxzBED4oBdG5W1aGM4Ul9qholhhCrobmC+5i/XccqmfwxC
         9tSaMblmUBKrXqdiCuVDV2iQ8+aLhoU2fr1CVEZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Ron Minnich <rminnich@google.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/245] mtd: parser: cmdline: Support MTD names containing one or more colons
Date:   Tue, 29 Sep 2020 13:00:43 +0200
Message-Id: <20200929105956.324962675@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit eb13fa0227417e84aecc3bd9c029d376e33474d3 ]

Looks like some drivers define MTD names with a colon in it, thus
making mtdpart= parsing impossible. Let's fix the parser to gracefully
handle that case: the last ':' in a partition definition sequence is
considered instead of the first one.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Ron Minnich <rminnich@google.com>
Tested-by: Ron Minnich <rminnich@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/cmdlinepart.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 3ea44cff9b759..c29205ee82e20 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -231,12 +231,29 @@ static int mtdpart_setup_real(char *s)
 		struct cmdline_mtd_partition *this_mtd;
 		struct mtd_partition *parts;
 		int mtd_id_len, num_parts;
-		char *p, *mtd_id;
+		char *p, *mtd_id, *semicol;
+
+		/*
+		 * Replace the first ';' by a NULL char so strrchr can work
+		 * properly.
+		 */
+		semicol = strchr(s, ';');
+		if (semicol)
+			*semicol = '\0';
 
 		mtd_id = s;
 
-		/* fetch <mtd-id> */
-		p = strchr(s, ':');
+		/*
+		 * fetch <mtd-id>. We use strrchr to ignore all ':' that could
+		 * be present in the MTD name, only the last one is interpreted
+		 * as an <mtd-id>/<part-definition> separator.
+		 */
+		p = strrchr(s, ':');
+
+		/* Restore the ';' now. */
+		if (semicol)
+			*semicol = ';';
+
 		if (!p) {
 			pr_err("no mtd-id\n");
 			return -EINVAL;
-- 
2.25.1



