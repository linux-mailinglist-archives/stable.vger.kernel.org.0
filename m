Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4971AE65D4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfJ0VFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbfJ0VFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:05:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F06208C0;
        Sun, 27 Oct 2019 21:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210337;
        bh=VTE3iNMsGVPx5aIFWaap7QbAngR+xbH2tN1CHoJh/kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkJdXVecpL55Mgo9lUuILKUBxZF/31gUC4l/haqzUoiTrdEZWg+CLvVfh5ifDFYw7
         gMtEpl+J/qJNTjjBxwOxYRdbpbfgRfGyapakRIT1pSgoBxpfACMwwABevjefAeFc+8
         o2NJTMbE+rb6Qt2rnciUeP3z7OnmXADt+E2Sr//k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/49] scsi: qla2xxx: Fix unbound sleep in fcport delete path.
Date:   Sun, 27 Oct 2019 22:00:41 +0100
Message-Id: <20191027203121.970264406@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit c3b6a1d397420a0fdd97af2f06abfb78adc370df ]

There are instances, though rare, where a LOGO request cannot be sent out
and the thread in free session done can wait indefinitely. Fix this by
putting an upper bound to sleep.

Link: https://lore.kernel.org/r/20190912180918.6436-3-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 11f45cb998927..d13e91e164258 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -572,6 +572,7 @@ static void qlt_free_session_done(struct work_struct *work)
 
 	if (logout_started) {
 		bool traced = false;
+		u16 cnt = 0;
 
 		while (!ACCESS_ONCE(sess->logout_completed)) {
 			if (!traced) {
@@ -581,6 +582,9 @@ static void qlt_free_session_done(struct work_struct *work)
 				traced = true;
 			}
 			msleep(100);
+			cnt++;
+			if (cnt > 200)
+				break;
 		}
 
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf087,
-- 
2.20.1



