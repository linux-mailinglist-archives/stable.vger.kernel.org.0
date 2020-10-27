Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D293F29C2DD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821134AbgJ0Rkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902311AbgJ0Ock (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B9D20773;
        Tue, 27 Oct 2020 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809152;
        bh=P4a75jnVXDWT0V3ovpmOnRfZTRnN5zdieUF7mNfbbWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sopvvfvjOuRHGOhFtQha4SZZieybEbyE7B2D+BtezPkhX2PRiBADVF1QS0JqzD2Vn
         LJfdqWg/bmX/Xqq0/lgXCSPP5mCnIWwkKA5CPy0m7dv36j7xgjUJYF04jTU5xLgYPh
         m9PUBeLl7IaEVXr781ejbLsmfPLyZc/1aDA2TUBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/408] media: s5p-mfc: Fix a reference count leak
Date:   Tue, 27 Oct 2020 14:50:33 +0100
Message-Id: <20201027135459.501425037@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 78741ce98c2e36188e2343434406b0e0bc50b0e7 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Fixes: c5086f130a77 ("[media] s5p-mfc: Use clock gating only on MFC v5 hardware")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 7d52431c2c837..62d2320a72186 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -79,8 +79,10 @@ int s5p_mfc_power_on(void)
 	int i, ret = 0;
 
 	ret = pm_runtime_get_sync(pm->device);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(pm->device);
 		return ret;
+	}
 
 	/* clock control */
 	for (i = 0; i < pm->num_clocks; i++) {
-- 
2.25.1



