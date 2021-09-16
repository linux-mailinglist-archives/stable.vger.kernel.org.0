Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F4840E26E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbhIPQiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243228AbhIPQgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E87E619E0;
        Thu, 16 Sep 2021 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809304;
        bh=wyLFZYGnNSC+Y8OC1gRai2iv4BEqsO2o7Sujeuxyb6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaGS68kIPHRHjVjqyBIyYGD5BRKr3AF2h5vkuql2DteINhUIusTsuQUh/K0O2CHP3
         qKW+j1524xgDCRj1YUw4CO/gFIUAgQLRCB5rigEg+39cRirIBms/RSN3LawlvCXLnd
         +NybOzfJUJP7NX1StbfoFD0IGlg0vEuS37MCtwTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 104/380] scsi: smartpqi: Fix an error code in pqi_get_raid_map()
Date:   Thu, 16 Sep 2021 17:57:41 +0200
Message-Id: <20210916155807.578131929@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d1f6581a6796c4e9fd8a4a24e8b77463d18f0df1 ]

Return -EINVAL on failure instead of success.

Link: https://lore.kernel.org/r/20210810084613.GB23810@kili
Fixes: a91aaae0243b ("scsi: smartpqi: allow for larger raid maps")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5db16509b6e1..f573517e8f6e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1322,6 +1322,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 				"requested %u bytes, received %u bytes\n",
 				raid_map_size,
 				get_unaligned_le32(&raid_map->structure_size));
+			rc = -EINVAL;
 			goto error;
 		}
 	}
-- 
2.30.2



