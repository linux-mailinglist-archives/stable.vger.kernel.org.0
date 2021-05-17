Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB1383655
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbhEQPbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244403AbhEQP3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31BC61CBA;
        Mon, 17 May 2021 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262245;
        bh=bDdVezbQV24ZSV5CqB+afjH1cjjLiMUa02Hsb2TYgis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwpkYa646FR2no1AJ+t0wf2CiSPl4+lGJOE8/0GAezK3RceFqp5jR4d7o2wWlnTBO
         79IyAYIpMwlVPwI6FdKPDiWTXSTHW4hABn17KCS3INcIJm8X57C7gKO8FbhW90uIPm
         LBxPBZgCLom3F7oC5j5EqSCuZViBnUGPgOeXjPLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/289] scsi: qla2xxx: Prevent PRLI in target mode
Date:   Mon, 17 May 2021 16:01:05 +0200
Message-Id: <20210517140309.865578700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anastasia Kovaleva <a.kovaleva@yadro.com>

[ Upstream commit fcb16d9a8ecf1e9bfced0fc654ea4e2caa7517f4 ]

In a case when the initiator in P2P mode by some circumstances does not
send PRLI, the target, in a case when the target port's WWPN is less than
initiator's, changes the discovery state in DSC_GNL. When gnl completes it
sends PRLI to the initiator.

Usually the initiator in P2P mode always sends PRLI. We caught this issue
on Linux stable v5.4.6 https://www.spinics.net/lists/stable/msg458515.html.

Fix this particular corner case in the behaviour of the P2P mod target
login state machine.

Link: https://lore.kernel.org/r/20210422153414.4022-1-a.kovaleva@yadro.com
Fixes: a9ed06d4e640 ("scsi: qla2xxx: Allow PLOGI in target mode")
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 52e8b555bd1d..6faf34fa6220 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1190,6 +1190,9 @@ static int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_work_evt *e;
 
+	if (vha->host->active_mode == MODE_TARGET)
+		return QLA_FUNCTION_FAILED;
+
 	e = qla2x00_alloc_work(vha, QLA_EVT_PRLI);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
-- 
2.30.2



