Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B9A3CA97E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbhGOTG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241438AbhGOTFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D15A613F1;
        Thu, 15 Jul 2021 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375731;
        bh=+KNdvSiSTwrRQseY2ACMiYBWQDELdkM7Ft8ARJ2W67w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/RZ/IuwQL90s2SVkRLnbad9ZZzaLEeUsFtqoXgeTBBhpm6WtYHLPQ4w46l7wuCQx
         3288wYN81HAeECyCatsI0pgIDcDDFJq6qZFfTk6VBklm1eh5g4ZcQi+BNHHjMvb+t2
         bT7dIbYSehLX/e6rmosYCATJLCqxoLvy8Gy/+wUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.12 213/242] coresight: Propagate symlink failure
Date:   Thu, 15 Jul 2021 20:39:35 +0200
Message-Id: <20210715182630.681224360@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

commit 51dd19a7e9f8fbbb7cd92b8a357091911eae7f78 upstream.

If the symlink is unable to be created, the driver goes
ahead and continues device creation. Instead lets propagate
the failure, and fail the probe.

Link: https://lore.kernel.org/r/20210526204042.2681700-1-jeremy.linton@arm.com
Fixes: 8a7365c2d418 ("coresight: Expose device connections via sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210614175901.532683-7-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1367,7 +1367,7 @@ static int coresight_fixup_device_conns(
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int coresight_remove_match(struct device *dev, void *data)


