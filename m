Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D85D29B1D4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760566AbgJ0OfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760557AbgJ0OfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6917322202;
        Tue, 27 Oct 2020 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809307;
        bh=eT0ceFRk/iuU9MUwUY2nKLoERlcqX5PPx5dsG3Pe9nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQX/lzbNMLNKXL7Ha6z80voRG5g6DLpyCkc33YR8ARuDISAO6iy3r/2rlYApIZ0Ds
         S05PBBAZmK4K+VKcKrIzG/QCImRXVq1aG0JGb56xeRYtYhYTQSjVVna3pM/U2ofWXq
         B1w3SGM8DmZPvx/vOf3cpnXpmZ0h+LQIr/F3ACl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/408] scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()
Date:   Tue, 27 Oct 2020 14:50:57 +0100
Message-Id: <20201027135500.626372692@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit bbf2d06a9d767718bfe6028d6288c03edb98554a ]

In the case of a failed retry, a positive value EIO is returned here.  I
think this is a typo error. It is necessary to return an error value.

[mkp: caller checks != 0 but the rest of the file uses -Exxx so fix this up
to be consistent]

Link: https://lore.kernel.org/r/20200802111528.4974-1-tianjia.zhang@linux.alibaba.com
Fixes: 0691094ff3f2 ("scsi: qla2xxx: Add logic to detect ABTS hang and response completion")
Cc: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a7acc266cec06..d84d95cac2a13 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5677,7 +5677,7 @@ static int qlt_chk_unresolv_exchg(struct scsi_qla_host *vha,
 		/* found existing exchange */
 		qpair->retry_term_cnt++;
 		if (qpair->retry_term_cnt >= 5) {
-			rc = EIO;
+			rc = -EIO;
 			qpair->retry_term_cnt = 0;
 			ql_log(ql_log_warn, vha, 0xffff,
 			    "Unable to send ABTS Respond. Dumping firmware.\n");
-- 
2.25.1



