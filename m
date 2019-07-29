Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7869B798E7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbfG2TdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfG2TdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:33:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09A0B2171F;
        Mon, 29 Jul 2019 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428797;
        bh=hpH3G4a7G/KVsYa4id/3HXxZbpYaTdI/T6rleRNvGhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nM2pZJCvhBGc2bFdiOt9QB+QbLhZT2UOa064zDr15HIX8O21p1YO4+pPvBCrpFf1Q
         1z/SrTGg1CIgZqqekx+X37at0/M0wINYXUwsTQfoHTxU7ORbP5Kcca1sTGcwVWYJ74
         jh/nFLsbfkEVPj7qy93laEFugCQlWHXMPSSetO+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Dominique Martinet <dominique.martinet@cea.fr>
Subject: [PATCH 4.14 150/293] 9p/xen: Add cleanup path in p9_trans_xen_init
Date:   Mon, 29 Jul 2019 21:20:41 +0200
Message-Id: <20190729190836.072990654@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 80a316ff16276b36d0392a8f8b2f63259857ae98 upstream.

If xenbus_register_frontend() fails in p9_trans_xen_init,
we should call v9fs_unregister_trans() to do cleanup.

Link: http://lkml.kernel.org/r/20190430143933.19368-1-yuehaibing@huawei.com
Cc: stable@vger.kernel.org
Fixes: 868eb122739a ("xen/9pfs: introduce Xen 9pfs transport driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/9p/trans_xen.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -530,13 +530,19 @@ static struct xenbus_driver xen_9pfs_fro
 
 static int p9_trans_xen_init(void)
 {
+	int rc;
+
 	if (!xen_domain())
 		return -ENODEV;
 
 	pr_info("Initialising Xen transport for 9pfs\n");
 
 	v9fs_register_trans(&p9_xen_trans);
-	return xenbus_register_frontend(&xen_9pfs_front_driver);
+	rc = xenbus_register_frontend(&xen_9pfs_front_driver);
+	if (rc)
+		v9fs_unregister_trans(&p9_xen_trans);
+
+	return rc;
 }
 module_init(p9_trans_xen_init);
 


