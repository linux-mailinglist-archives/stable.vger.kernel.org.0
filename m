Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E299148449
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390395AbgAXLQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390185AbgAXLQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:40 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CE962077C;
        Fri, 24 Jan 2020 11:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864600;
        bh=NkK8E8I7Ljz9BaFANU6oBTZchsYZNsY2jgeUybzQZrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUz9sduDSfP6YwscXNWwZGp4DDMRR9jdku0GoZGZG6szt4b6vIMqudFvcDP2bChTa
         5Ob7OQsG150t+b9r8iKa88o5QPPCE+M6+tVbK+r9yW/H2B48H7QLN/eL13WQAlF3EC
         B4abaDIxhMRSiA6yiVQjjsej6oKfksuRGO6yAT9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 298/639] of: use correct function prototype for of_overlay_fdt_apply()
Date:   Fri, 24 Jan 2020 10:27:48 +0100
Message-Id: <20200124093124.248475233@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit ecb0abc1d8528015957fbd034be8bfe760363b3b ]

When CONFIG_OF_OVERLAY is not enabled the fallback stub for
of_overlay_fdt_apply() does not match the prototype for the case when
CONFIG_OF_OVERLAY is enabled. Update the stub to use the correct
function prototype.

Fixes: 39a751a4cb7e ("of: change overlay apply input data from unflattened to FDT")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index dac0201eacef7..d4f14b0302b63 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1425,7 +1425,8 @@ int of_overlay_notifier_unregister(struct notifier_block *nb);
 
 #else
 
-static inline int of_overlay_fdt_apply(void *overlay_fdt, int *ovcs_id)
+static inline int of_overlay_fdt_apply(void *overlay_fdt, u32 overlay_fdt_size,
+				       int *ovcs_id)
 {
 	return -ENOTSUPP;
 }
-- 
2.20.1



