Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF40312C784
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfL2RnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730435AbfL2RnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB2821744;
        Sun, 29 Dec 2019 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641391;
        bh=8bdOIu18jZB6fruSVNfOW/sII9TzV1EYlcWBJzTdZ1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIH/E6ModobQX+0SdeHfeYTmUExYWEYalTDdMn80KJz7NNAMvsjWyev4qaqq4SFi1
         i2YGccOX9iAgfU8/A49MdvsDlXlkuVxf/ir59cXj+SrCYSCB62noU0WvuBPQ1SX57Q
         90AQQloEcl1AieDeJX+mV7DHu+DjIKs2yPuatU84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/434] drm/mipi-dbi: fix a loop in debugfs code
Date:   Sun, 29 Dec 2019 18:21:39 +0100
Message-Id: <20191229172705.060721032@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d72cf01f410aa09868d98b672f3f92328c96b32d ]

This code will likely crash if we try to do a zero byte write.  The code
looks like this:

        /* strip trailing whitespace */
        for (i = count - 1; i > 0; i--)
                if (isspace(buf[i]))
			...

We're writing zero bytes so count = 0.  You would think that "count - 1"
would be negative one, but because "i" is unsigned it is a large
positive numer instead.  The "i > 0" condition is true and the "buf[i]"
access will be out of bounds.

The fix is to make "i" signed and now everything works as expected.  The
upper bound of "count" is capped in __kernel_write() at MAX_RW_COUNT so
we don't have to worry about it being higher than INT_MAX.

Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[noralf: Adjust title]
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190821072456.GJ26957@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dbi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
index 1961f713aaab..c4ee2709a6f3 100644
--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -1187,8 +1187,7 @@ static ssize_t mipi_dbi_debugfs_command_write(struct file *file,
 	struct mipi_dbi_dev *dbidev = m->private;
 	u8 val, cmd = 0, parameters[64];
 	char *buf, *pos, *token;
-	unsigned int i;
-	int ret, idx;
+	int i, ret, idx;
 
 	if (!drm_dev_enter(&dbidev->drm, &idx))
 		return -ENODEV;
-- 
2.20.1



