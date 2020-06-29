Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E820DC43
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbgF2UNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732855AbgF2TaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26ACC252C5;
        Mon, 29 Jun 2020 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445090;
        bh=zh3w4o0Y23rKmjhva/TWDI8xmmR/vxEp2DQZZKcF/KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2awdFTBk0CpMAG+sdvFSLqdq2Trc20wcSXFpxpZ1qSyfBIojXtT9oyB8hjZ3huqy
         RpAZiYBIl4HxJ1DCb+4mb94oFKf2rXRAiHLQtvWJDvHS9kPouYS3a1s+eZIC544/3X
         JhlLc6/sH7TOdV0jrS6etFEx+K60h6G5OZW/MOV8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 01/78] scsi: scsi_devinfo: handle non-terminated strings
Date:   Mon, 29 Jun 2020 11:36:49 -0400
Message-Id: <20200629153806.2494953-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

commit ba69ead9e9e9bb3cec5faf03526c36764ac8942a upstream.

devinfo->vendor and devinfo->model aren't necessarily
zero-terminated.

Fixes: b8018b973c7c "scsi_devinfo: fixup string compare"
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_devinfo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 9654898f3e512..6748e82c6352f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -449,7 +449,8 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			/*
 			 * vendor strings must be an exact match
 			 */
-			if (vmax != strlen(devinfo->vendor) ||
+			if (vmax != strnlen(devinfo->vendor,
+					    sizeof(devinfo->vendor)) ||
 			    memcmp(devinfo->vendor, vskip, vmax))
 				continue;
 
@@ -457,7 +458,7 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			 * @model specifies the full string, and
 			 * must be larger or equal to devinfo->model
 			 */
-			mlen = strlen(devinfo->model);
+			mlen = strnlen(devinfo->model, sizeof(devinfo->model));
 			if (mmax < mlen || memcmp(devinfo->model, mskip, mlen))
 				continue;
 			return devinfo;
-- 
2.25.1

