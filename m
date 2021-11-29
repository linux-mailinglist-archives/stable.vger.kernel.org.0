Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1896F461E00
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379280AbhK2Sb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:28 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48602 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378849AbhK2S31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BC77CE13F9;
        Mon, 29 Nov 2021 18:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE56CC53FD2;
        Mon, 29 Nov 2021 18:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210366;
        bh=x4WhqPn1skGoKyCfANKh4dgRIuLWcoEaJA8mHcJpKkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQU0dYDVr9Ksx0xXJxZAVoV2niSgC8U7CjRRCHEXEm8rVjbQpiqV4zOnhIZI5fqwl
         PkIbckhuPdwjpo7yIUBW+FKO1srPKNZDEg/rM7s4qUjVh+UWQ8aGIJvRcvQm/JCDqX
         jzzVU8cU+YrooQAm6jvP4yFRC2dzJDJO0dnhiboA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/92] scsi: core: sysfs: Fix setting device state to SDEV_RUNNING
Date:   Mon, 29 Nov 2021 19:18:31 +0100
Message-Id: <20211129181709.481514029@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit eb97545d6264b341b06ba7603f52ff6c0b2af6ea ]

This fixes an issue added in commit 4edd8cd4e86d ("scsi: core: sysfs: Fix
hang when device state is set via sysfs") where if userspace is requesting
to set the device state to SDEV_RUNNING when the state is already
SDEV_RUNNING, we return -EINVAL instead of count. The commmit above set ret
to count for this case, when it should have set it to 0.

Link: https://lore.kernel.org/r/20211120164917.4924-1-michael.christie@oracle.com
Fixes: 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set via sysfs")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 16432d42a50aa..6faf1d6451b0c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -796,7 +796,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&sdev->state_mutex);
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
-		ret = count;
+		ret = 0;
 	} else {
 		ret = scsi_device_set_state(sdev, state);
 		if (ret == 0 && state == SDEV_RUNNING)
-- 
2.33.0



