Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73EF419B2F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhI0RQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236271AbhI0ROh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6F06135F;
        Mon, 27 Sep 2021 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762630;
        bh=4ixodGxqK1SbwWyKkREENjTlpCpbVyQ5HEqwOaO/UJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sENZCewVqeAOY36yHNviAghImV4yEk7OAd/2A+nz9z8BW2RhdSdp2zoszWk0PRA80
         AHcw62Va+Q85A7YrZY9n16MXr90gTUEy2l0RjKswhHsoUMdhhmvx6dY2GFUL8H9hQ8
         1z75lLKKJ9pFoM6VJjJFE4zy+Xzf6aPF14ivDnzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/103] scsi: qla2xxx: Restore initiator in dual mode
Date:   Mon, 27 Sep 2021 19:02:36 +0200
Message-Id: <20210927170228.000762907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index 6faf34fa6220..b7aac3116f2d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6934,7 +6934,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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



