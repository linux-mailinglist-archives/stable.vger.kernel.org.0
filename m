Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589A61192A7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLJVEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfLJVEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E76E9206EC;
        Tue, 10 Dec 2019 21:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011848;
        bh=VQ5a4xBBMy6ZGg8kyYiUVjmv92AEpnGHsls0CSS71jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtY7XvbT+Cw7dIpZUlRVZpWvMDkqEytfH7oXA/gP8Y+ZORMowdMDUCxFjbcadBjiE
         V1+2BvlED74IvHGoormdAz6tev4aEhfLdzAVhP0mmHR16m6ICra/7yJgFihEodKH71
         6FSDppgGE22+4jj0AKbav1TBfwcJyv4qnHuo4g4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 004/350] drm/mipi-dbi: fix a loop in debugfs code
Date:   Tue, 10 Dec 2019 15:58:16 -0500
Message-Id: <20191210210402.8367-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1961f713aaab4..c4ee2709a6f32 100644
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

