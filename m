Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BD61C15F5
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbgEANgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730907AbgEANgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C65C216FD;
        Fri,  1 May 2020 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340212;
        bh=qlK1Qsg9nh837m7uoLR3xqSQhl2zVHgNEkg9ggYtcJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3FoyCuJDLTFWzVWczyMNXCssAQuvGDfWsqv1URxoy6q+MVPxpKEmVDVk7yCAi/tq
         DCbkbf2TA+DJSV5H9AWISilnpAcXICXgsbE91mBRItDHmNk/q3YzYHgGuVo8nhrBCZ
         RbNzjWfeecAHE9Nk14WRBeBaZv80HeyFVpy+8Ht0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/46] scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Date:   Fri,  1 May 2020 15:22:59 +0200
Message-Id: <20200501131510.854207385@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 066f79a5fd6d1b9a5cc57b5cd445b3e4bb68a5b2 ]

In case command ring buffer becomes inconsistent, tcmu sets device flag
TCMU_DEV_BIT_BROKEN.  If the bit is set, tcmu rejects new commands from LIO
core with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, and no longer processes
completions from the ring.  The reset_ring attribute can be used to
completely clean up the command ring, so after reset_ring the ring no
longer is inconsistent.

Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN to allow
normal processing.

Link: https://lore.kernel.org/r/20200409101026.17872-1-bstroesser@ts.fujitsu.com
Acked-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7ee0a75ce4526..eff1e36ca03c2 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2067,6 +2067,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_tail = 0;
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 
 	del_timer(&udev->cmd_timer);
 
-- 
2.20.1



