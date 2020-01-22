Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E01451AE
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgAVJcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:32:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbgAVJcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:32:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D002071E;
        Wed, 22 Jan 2020 09:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685552;
        bh=wV4sBakQ3b/c4Lez57pR0uixWdNUh8E6EcO69dxaw7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtyTWqphfB8yaehboktIzBSVzaOxgS5fWh0qXkKekJo2qxB6TiEheLaoWQ1EUSHDX
         VVLh12R0EJXpw7yKfkqA676s8kZYdl7zkJ97ZLp8dHwBUnlOvLFz+yql/6jkOidxUY
         AexnrBMf2tmNxPyenehvDZLOLsV1BebTteKKxCTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.4 33/76] media: exynos4-is: Fix recursive locking in isp_video_release()
Date:   Wed, 22 Jan 2020 10:28:49 +0100
Message-Id: <20200122092755.304524185@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -323,7 +323,7 @@ static int isp_video_release(struct file
 		ivc->streaming = 0;
 	}
 
-	vb2_fop_release(file);
+	_vb2_fop_release(file, NULL);
 
 	if (v4l2_fh_is_singular_file(file)) {
 		fimc_pipeline_call(&ivc->ve, close);


