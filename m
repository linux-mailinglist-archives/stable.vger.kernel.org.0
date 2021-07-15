Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5AD3CA7EC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbhGOS5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241166AbhGOS4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 699DB613E3;
        Thu, 15 Jul 2021 18:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375218;
        bh=/xAl3+ufaRYvViM9X/jH9KVK3SbaGpRy3LXtVJ1+Zs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZmB4vfmZvUFQTY+cYHnTxBtnQu+60c7dXiQcOUi8tTNiFYWCoBh6u51PCKM9x8YP
         VCXMD5K4kN8IFyIhnPBNrIaxmvOf1+/nw7m5+eyYmGaQQPDIRWgm1bYEN3bVkmhxEb
         f8nWrgmypcT81kjb8vMq8kt2y19cm82wtKPMRXRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 193/215] coresight: Propagate symlink failure
Date:   Thu, 15 Jul 2021 20:39:25 +0200
Message-Id: <20210715182633.257572675@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
@@ -1347,7 +1347,7 @@ static int coresight_fixup_device_conns(
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int coresight_remove_match(struct device *dev, void *data)


