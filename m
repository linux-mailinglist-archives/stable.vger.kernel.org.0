Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD713EBD9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406105AbgAPRxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406093AbgAPRpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1084D2476A;
        Thu, 16 Jan 2020 17:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196708;
        bh=TDPzQ8lOFzd1TlN4bzqYEgSRNq1zXrEqZe6K0L9fOU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQCYMVVCcVm2Q6avsC/PtMZ4/SVBzX4fkNnRB201j+foxpev4Wry/rJOAvEP3RPtM
         pTxKDw2jPaSHO3YI8Z3UViKO3zfWrhAvJy3a0zjb+Z6zE7XAQe7SWK0Bxi1jeQKtCA
         HbuYR5PqyM/IDBbSvSL29bpjRkrRiRG46oGC2krc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 099/174] media: vivid: fix incorrect assignment operation when setting video mode
Date:   Thu, 16 Jan 2020 12:41:36 -0500
Message-Id: <20200116174251.24326-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit d4ec9550e4b2d2e357a46fdc65d8ef3d4d15984c ]

The assigment of FB_VMODE_NONINTERLACE to var->vmode should be a
bit-wise or of FB_VMODE_NONINTERLACE instead of an assignment,
otherwise the previous clearing of the FB_VMODE_MASK bits of
var->vmode makes no sense and is redundant.

Addresses-Coverity: ("Unused value")
Fixes: ad4e02d5081d ("[media] vivid: add a simple framebuffer device for overlay testing")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-osd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-osd.c b/drivers/media/platform/vivid/vivid-osd.c
index e15eef6a94e5..f3afc74f98ed 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -167,7 +167,7 @@ static int _vivid_fb_check_var(struct fb_var_screeninfo *var, struct vivid_dev *
 	var->nonstd = 0;
 
 	var->vmode &= ~FB_VMODE_MASK;
-	var->vmode = FB_VMODE_NONINTERLACED;
+	var->vmode |= FB_VMODE_NONINTERLACED;
 
 	/* Dummy values */
 	var->hsync_len = 24;
-- 
2.20.1

