Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ACC4121BF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358912AbhITSIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358466AbhITSGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:06:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0344961A0A;
        Mon, 20 Sep 2021 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158284;
        bh=e0tCBIpXP830zSFWZVwp2PAZyI9TCrwSfKZyz5fKlWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFXlANVjgHIfwew+4zgZ0PfuFgsobnlKgDDBfLgMfrpdGXCgzMcexTzdE1l59Suie
         3k87DSKI7o+N6jCR1zux1XJQfxbsbg3l4znbbCYlQqYCM/f3bCQwWu45pe2L4AMRFg
         8dj2l/uGvFIFlvNevBg9zqPn6yKnib1LxztRtUZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/260] scsi: smartpqi: Fix an error code in pqi_get_raid_map()
Date:   Mon, 20 Sep 2021 18:41:11 +0200
Message-Id: <20210920163932.908728333@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 9bc451004184..80ff00025c03 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1192,6 +1192,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 				"Requested %d bytes, received %d bytes",
 				raid_map_size,
 				get_unaligned_le32(&raid_map->structure_size));
+			rc = -EINVAL;
 			goto error;
 		}
 	}
-- 
2.30.2



