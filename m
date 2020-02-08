Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9A2156691
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgBHS3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33822 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbgBHS3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:39 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dv-Gm; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CMc-DO; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Seung-Woo Kim" <sw0312.kim@samsung.com>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>
Date:   Sat, 08 Feb 2020 18:19:51 +0000
Message-ID: <lsq.1581185940.63231177@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 052/148] media: exynos4-is: Fix recursive locking in
 isp_video_release()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Seung-Woo Kim <sw0312.kim@samsung.com>

commit 704c6c80fb471d1bb0ef0d61a94617d1d55743cd upstream.

>From isp_video_release(), &isp->video_lock is held and subsequent
vb2_fop_release() tries to lock vdev->lock which is same with the
previous one. Replace vb2_fop_release() with _vb2_fop_release() to
fix the recursive locking.

Fixes: 1380f5754cb0 ("[media] videobuf2: Add missing lock held on vb2_fop_release")
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -322,7 +322,7 @@ static int isp_video_release(struct file
 		ivc->streaming = 0;
 	}
 
-	vb2_fop_release(file);
+	_vb2_fop_release(file, NULL);
 
 	if (v4l2_fh_is_singular_file(file)) {
 		fimc_pipeline_call(&ivc->ve, close);

