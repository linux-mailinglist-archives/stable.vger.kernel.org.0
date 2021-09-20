Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D47C412424
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348519AbhITSbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379306AbhITS26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:28:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2BEE61362;
        Mon, 20 Sep 2021 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158802;
        bh=8drDd3EAJ6H/8qs3pR5E3EP4p+gz4fhSiFbxHOCXAKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbGmKqr3k8d40AOi1djLAwRAhyGWYSEO0s+t6pRMf6IA07ko2SGvZ9XGWPTqY7yhp
         SxQTRN1WZiQkC0ziAsuts+jOEm98i59RkKHwkK7dpZT+E9ZBUpDComvwJtwpm3lqAV
         6Q8yQN49tGWmGKorMXdn7mb4TznLhb8/XMPqFFHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 030/122] drm/rockchip: cdn-dp-core: Make cdn_dp_core_resume __maybe_unused
Date:   Mon, 20 Sep 2021 18:43:22 +0200
Message-Id: <20210920163916.789275673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 040b8907ccf1c78d020aca29800036565d761d73 upstream.

With the new static annotation, the compiler warns when the functions
are actually unused:

   drivers/gpu/drm/rockchip/cdn-dp-core.c:1123:12: error: 'cdn_dp_resume' defined but not used [-Werror=unused-function]
    1123 | static int cdn_dp_resume(struct device *dev)
         |            ^~~~~~~~~~~~~

Mark them __maybe_unused to suppress that warning as well.

[ Not so 'new' static annotations any more, and I removed the part of
  the patch that added __maybe_unused to cdn_dp_suspend(), because it's
  used by the shutdown/remove code.

  So only the resume function ends up possibly unused if CONFIG_PM isn't
  set     - Linus ]

Fixes: 7c49abb4c2f8 ("drm/rockchip: cdn-dp-core: Make cdn_dp_core_suspend/resume static")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -1122,7 +1122,7 @@ static int cdn_dp_suspend(struct device
 	return ret;
 }
 
-static int cdn_dp_resume(struct device *dev)
+static __maybe_unused int cdn_dp_resume(struct device *dev)
 {
 	struct cdn_dp_device *dp = dev_get_drvdata(dev);
 


