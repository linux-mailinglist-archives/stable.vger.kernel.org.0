Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0543A002D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhFHSko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhFHSjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF64E61429;
        Tue,  8 Jun 2021 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177248;
        bh=zeDmtx43EHaZKjN6Z6DXHvEEVRER+34Jt2Xu80Hy840=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0YsWIFv6oXB6rxe3rvXbLwcXVAiikQc/esmiu4R1U/7CrQOVnJZqaYxN8pBwSZM2
         ljaKn6JY08phA+zZRLztOjyTl+u+xAftgctcGWQwCteZcwZGSXzs29H5mrZjsPh9EG
         1UFItR1PmDNF8BUf8kPFqMaKwiQa616q1bdWMS1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/58] samples: vfio-mdev: fix error handing in mdpy_fb_probe()
Date:   Tue,  8 Jun 2021 20:26:49 +0200
Message-Id: <20210608175932.557275566@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 752774ce7793a1f8baa55aae31f3b4caac49cbe4 ]

Fix to return a negative error code from the framebuffer_alloc() error
handling case instead of 0, also release regions in some error handing
cases.

Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Message-Id: <20210520133641.1421378-1-weiyongjun1@huawei.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/vfio-mdev/mdpy-fb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 2719bb259653..a760e130bd0d 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -117,22 +117,27 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 	if (format != DRM_FORMAT_XRGB8888) {
 		pci_err(pdev, "format mismatch (0x%x != 0x%x)\n",
 			format, DRM_FORMAT_XRGB8888);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	if (width < 100	 || width > 10000) {
 		pci_err(pdev, "width (%d) out of range\n", width);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	if (height < 100 || height > 10000) {
 		pci_err(pdev, "height (%d) out of range\n", height);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	pci_info(pdev, "mdpy found: %dx%d framebuffer\n",
 		 width, height);
 
 	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
-	if (!info)
+	if (!info) {
+		ret = -ENOMEM;
 		goto err_release_regions;
+	}
 	pci_set_drvdata(pdev, info);
 	par = info->par;
 
-- 
2.30.2



