Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0514506F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbgAVJnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387898AbgAVJnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A142468D;
        Wed, 22 Jan 2020 09:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686216;
        bh=tUh9PihcYxzFYZBFE2oWj/PpwZ5irhZl9ayz1NK6Wlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGne94NtdD4eVKZzgsSJ+nYy6ei3PQVJVCSaJVuNOAZmIkcv/v9cvYUocmw/FSJRW
         JsilWjCOltvn/x0VtOk+FETqePclYhTyibf4ldBGu0gSzDP5Cn5VwBxxmyNlwdmjbs
         +toKHG6cHdUAcDpmSReklxm4m7/TgWRmtYC4fkN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [PATCH 4.19 090/103] drm/nouveau/bar/gf100: ensure BAR is mapped
Date:   Wed, 22 Jan 2020 10:29:46 +0100
Message-Id: <20200122092815.731691833@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 12e08beb32d64b6070b718630490db83dd321c8c upstream.

If the BAR is zero size, it indicates it was never successfully mapped.
Ensure that the BAR is valid during initialization before attempting to
use it.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c
@@ -94,6 +94,8 @@ gf100_bar_oneinit_bar(struct gf100_bar *
 		return ret;
 
 	bar_len = device->func->resource_size(device, bar_nr);
+	if (!bar_len)
+		return -ENOMEM;
 	if (bar_nr == 3 && bar->bar2_halve)
 		bar_len >>= 1;
 


