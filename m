Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E895CB77
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfGBIHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbfGBIHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8663321852;
        Tue,  2 Jul 2019 08:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054823;
        bh=9I0J9Q9BNRma8ZT/GTjIET7njTTlPZtA+u6Uyvd4U58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LD/m4SYMtMeI2b0q8McB9X+sDVJl5WoIiBPUxzBIxDpsRrUOTDwKRG9ihvl1tuxlt
         Y1u503d3HuuoUhJLheq/KGB1aSOFeCVcinwZlfnGu8oUOJJp8WUzsfA0Kd21sKWon5
         pGfD41PoYZ/NIkbJC0ChJUfl1fRb40s2ap5YsNCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 45/72] NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O
Date:   Tue,  2 Jul 2019 10:01:46 +0200
Message-Id: <20190702080126.958242334@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 68f461593f76bd5f17e87cdd0bea28f4278c7268 upstream.

Fix a typo where we're confusing the default TCP retrans value
(NFS_DEF_TCP_RETRANS) for the default TCP timeout value.

Fixes: 15d03055cf39f ("pNFS/flexfiles: Set reasonable default ...")
Cc: stable@vger.kernel.org # 4.8+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/flexfilelayout/flexfilelayoutdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -18,7 +18,7 @@
 
 #define NFSDBG_FACILITY		NFSDBG_PNFS_LD
 
-static unsigned int dataserver_timeo = NFS_DEF_TCP_RETRANS;
+static unsigned int dataserver_timeo = NFS_DEF_TCP_TIMEO;
 static unsigned int dataserver_retrans;
 
 static bool ff_layout_has_available_ds(struct pnfs_layout_segment *lseg);


