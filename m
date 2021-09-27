Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3C419A76
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbhI0RJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235872AbhI0RIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 044F161178;
        Mon, 27 Sep 2021 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762388;
        bh=lVYqZrryC168AjHVf/FwVMbxe437VprS3TaZ2XqupLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phhdjndn4HICtR7/Kkll2f2Nn3Xv+5sf+QURyvg3S01cdzGT2gotcuA0q1rA3UsOC
         BcYyeE/Yf0uNlc8kMgl+zofK5ehleIzXNVxRditcVV0laqU5GC0l+UPMIE3BSGIwJT
         dyKnGGEZFFsYrJ/E5j5jU4dkrQFw7I0Gf4rL04MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/68] scsi: qla2xxx: Restore initiator in dual mode
Date:   Mon, 27 Sep 2021 19:02:36 +0200
Message-Id: <20210927170221.355660718@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
index 643b8ae36cbe..5dae7ac0d3ef 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6803,7 +6803,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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



