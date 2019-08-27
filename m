Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB7E9E0BE
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbfH0IFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729765AbfH0IF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 130E12173E;
        Tue, 27 Aug 2019 08:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893128;
        bh=x+xEPs0CBIJx4GXlOK7jjKFoEurAThDtKPGy7tpzfW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vp+yFYVKi7BLNH0h8yQtTRUwZver7ti/ThcEIIW1P26hg2K2wfz3ai13OSxJXAB46
         hneX/hFtfiQa93KWPn44XWX0REehzA9Rpa3pn0WGFX/e8iQVADzrf5kjMB7ZBjr7Nv
         DY10vmBJZWVrIEgTyj7FNW3lpuQRZOYIwPkDvXqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 130/162] IB/hfi1: Unsafe PSN checking for TID RDMA READ Resp packet
Date:   Tue, 27 Aug 2019 09:50:58 +0200
Message-Id: <20190827072743.056412316@linuxfoundation.org>
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

From: Kaike Wan <kaike.wan@intel.com>

commit 35d5c8b82e2c32e8e29ca195bb4dac60ba7d97fc upstream.

When processing a TID RDMA READ RESP packet that causes KDETH EFLAGS
errors, the packet's IB PSN is checked against qp->s_last_psn and
qp->s_psn without the protection of qp->s_lock, which is not safe.

This patch fixes the issue by acquiring qp->s_lock first.

Fixes: 9905bf06e890 ("IB/hfi1: Add functions to receive TID RDMA READ response")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/20190815192039.105923.7852.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -2689,12 +2689,12 @@ static bool handle_read_kdeth_eflags(str
 	u32 fpsn;
 
 	lockdep_assert_held(&qp->r_lock);
+	spin_lock(&qp->s_lock);
 	/* If the psn is out of valid range, drop the packet */
 	if (cmp_psn(ibpsn, qp->s_last_psn) < 0 ||
 	    cmp_psn(ibpsn, qp->s_psn) > 0)
-		return ret;
+		goto s_unlock;
 
-	spin_lock(&qp->s_lock);
 	/*
 	 * Note that NAKs implicitly ACK outstanding SEND and RDMA write
 	 * requests and implicitly NAK RDMA read and atomic requests issued


