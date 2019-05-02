Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12211F41
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfEBPWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfEBPWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:22:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8638214DA;
        Thu,  2 May 2019 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810553;
        bh=aK1j+ztpyv7vMhEEePNUn/E/rZXm/tqeKprs5SZhO24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3AX4piTPTLLHB2YSUcnO6QPCcz7EoEldpqNM2J7KOiFAOY22iDQvq7/kCWStgKRz
         ++YIXbW/E0O3uQHvB8A8YwSmFk40NqBYW5eYzu9Q9RPP75MtTlyfjxC8wKT2Lqg1w/
         DJqExesx7wMn9AOHVzuGCnsADkSOy2OOeF6sE8OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Manish Rangankar <mrangankar@marvell.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.9 24/32] scsi: qla4xxx: fix a potential NULL pointer dereference
Date:   Thu,  2 May 2019 17:21:10 +0200
Message-Id: <20190502143321.601253652@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
References: <20190502143314.649935114@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fba1bdd2a9a93f3e2181ec1936a3c2f6b37e7ed6 ]

In case iscsi_lookup_endpoint fails, the fix returns -EINVAL to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f9f899ec9427..c158967b59d7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3207,6 +3207,8 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
 		return -EINVAL;
 	ep = iscsi_lookup_endpoint(transport_fd);
+	if (!ep)
+		return -EINVAL;
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
-- 
2.19.1



