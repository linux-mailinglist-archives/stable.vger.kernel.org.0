Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD46419C32
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhI0R0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238013AbhI0RYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C02B6613CF;
        Mon, 27 Sep 2021 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762933;
        bh=ba5EEh/I08Xl0pCyRsGryz+inYCK3L39IttSecK1Px8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/ALWg2jeFGzPoh9XYuIlLKOtUNv+zTaZcWOtVh1b306lVaSXdPVvuKbKN/pCxBTT
         mCchHmhtmxwufuiV8nOW1cgtvXfT5pY4d4IEmEikEvoYtpGVUB7sOJ5NijOMMoWaoG
         Q8FeSDyHWFmijNfbwrd3H44xJ6Tkka4Tnc1brPJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 106/162] scsi: qla2xxx: Restore initiator in dual mode
Date:   Mon, 27 Sep 2021 19:02:32 +0200
Message-Id: <20210927170237.111569177@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 5f8579038842d77e6ce05e1df6bf9dd493b0e3ef ]

In dual mode in case of disabling the target, the whole port goes offline
and initiator is turned off too.

Fix restoring initiator mode after disabling target in dual mode.

Link: https://lore.kernel.org/r/20210915153239.8035-1-d.bogdanov@yadro.com
Fixes: 0645cb8350cd ("scsi: qla2xxx: Add mode control for each physical port")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f8f471157109..70b507d177f1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7014,7 +7014,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				return 0;
 			break;
 		case QLA2XXX_INI_MODE_DUAL:
-			if (!qla_dual_mode_enabled(vha))
+			if (!qla_dual_mode_enabled(vha) &&
+			    !qla_ini_mode_enabled(vha))
 				return 0;
 			break;
 		case QLA2XXX_INI_MODE_ENABLED:
-- 
2.33.0



