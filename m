Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59ABD2468
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfJJIow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389002AbfJJIow (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B7321A4A;
        Thu, 10 Oct 2019 08:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697092;
        bh=iIs8NsO0k/7dQiSK4NqID+wPWQI6qa8Agy9tEVixmnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dr5zTfwLzGz9hKuU6f0oFD19PDlrc7k5uYjX+/lFuCuk0so7UXPdkDoOQemtiO3r2
         w1A1KFMfcluAdpY/1edjjklFhRDX9PXPqXCHGLBNxs1tOj6Ydp6v8xEbh6razjLduM
         E5g2Zltgwgdvb8jJH6W+aBbQsa+G3wor7FobRhJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.19 016/114] powerpc/powernv: Restrict OPAL symbol map to only be readable by root
Date:   Thu, 10 Oct 2019 10:35:23 +0200
Message-Id: <20191010083551.627049514@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Donnellan <ajd@linux.ibm.com>

commit e7de4f7b64c23e503a8c42af98d56f2a7462bd6d upstream.

Currently the OPAL symbol map is globally readable, which seems bad as
it contains physical addresses.

Restrict it to root.

Fixes: c8742f85125d ("powerpc/powernv: Expose OPAL firmware symbol map")
Cc: stable@vger.kernel.org # v3.19+
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190503075253.22798-1-ajd@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -680,7 +680,10 @@ static ssize_t symbol_map_read(struct fi
 				       bin_attr->size);
 }
 
-static BIN_ATTR_RO(symbol_map, 0);
+static struct bin_attribute symbol_map_attr = {
+	.attr = {.name = "symbol_map", .mode = 0400},
+	.read = symbol_map_read
+};
 
 static void opal_export_symmap(void)
 {
@@ -697,10 +700,10 @@ static void opal_export_symmap(void)
 		return;
 
 	/* Setup attributes */
-	bin_attr_symbol_map.private = __va(be64_to_cpu(syms[0]));
-	bin_attr_symbol_map.size = be64_to_cpu(syms[1]);
+	symbol_map_attr.private = __va(be64_to_cpu(syms[0]));
+	symbol_map_attr.size = be64_to_cpu(syms[1]);
 
-	rc = sysfs_create_bin_file(opal_kobj, &bin_attr_symbol_map);
+	rc = sysfs_create_bin_file(opal_kobj, &symbol_map_attr);
 	if (rc)
 		pr_warn("Error %d creating OPAL symbols file\n", rc);
 }


