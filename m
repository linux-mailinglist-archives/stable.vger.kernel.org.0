Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65D91C1628
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgEANke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgEANkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:40:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F29C205C9;
        Fri,  1 May 2020 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340432;
        bh=S1pFrNshqtwbqsTvzoUTRMylnIQecyR9t7n1Hbdwejo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aayDskhJW/67XlbXXR3OZUAtuLPqjDHdp8RntAdvNFWH+OArlDEQ2mHg6gDDaoOzU
         WH3S/oZ2jMW88kJVdXyf1/4kw8jrYlLONSwaTOTNkQNWa+85GjlHmtqlzTHuIbcUeU
         OWyDuhZlDSy5VP+dvxdABn/HzH1i+x7SLfF/JDq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/83] scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Date:   Fri,  1 May 2020 15:23:42 +0200
Message-Id: <20200501131540.585278307@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
index 35be1be87d2a1..9425354aef99c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2073,6 +2073,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_tail = 0;
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 
 	del_timer(&udev->cmd_timer);
 
-- 
2.20.1



