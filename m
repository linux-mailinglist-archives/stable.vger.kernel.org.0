Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008D62F2C9D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbhALKXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbhALKXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 05:23:15 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AFDC061575;
        Tue, 12 Jan 2021 02:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v7oVYvihYS1NhEyMk0M3W6mT8S/xbaNytTvYyF+QUrk=; b=WRYre6xL9UjMvS045nYyetetx9
        zluESmmBaKYWLfTuwMxQ60ENSEGEHKOq9+SZktm7sg2izizsIqdT217Zr0u/zYuKHcVEO13RmCr36
        ynx2S1GSRJwmCpK0dxnyCCAlaYFmF4U6RDAInHwKT1r0ea68gd/M80cUN95elP9v+I1/D8LsooMnw
        spes5jl7nAZkdKcUEgCV3o3wMwu2Dxa+SR55YTzoGzlUu1Tel/B4bhMT7TO1XRgMqLGzcPZUWFt9k
        Sp4Z7HF5DoNMsdTWxnukJeClK7gMmF9TJV720d6ogL9fPCmy9xEYiCHQ8ZR1zV8FI130wUxrfcDbq
        ceW5lDdA==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=toshino.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mperttunen@nvidia.com>)
        id 1kzGor-0007UE-Gt; Tue, 12 Jan 2021 12:22:33 +0200
From:   Mikko Perttunen <mperttunen@nvidia.com>
To:     thierry.reding@gmail.com, jonathanh@nvidia.com
Cc:     talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH v3] i2c: bpmp-tegra: Ignore unknown I2C_M flags
Date:   Tue, 12 Jan 2021 12:22:25 +0200
Message-Id: <20210112102225.3737326-1-mperttunen@nvidia.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: mperttunen@nvidia.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to not to start returning errors when new I2C_M flags are
added, change behavior to just ignore all flags that we don't know
about. This includes the I2C_M_DMA_SAFE flag that already exists.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
v3:
- Ignore all unknown flags instead of just I2C_M_DMA_SAFE
---
 drivers/i2c/busses/i2c-tegra-bpmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-tegra-bpmp.c b/drivers/i2c/busses/i2c-tegra-bpmp.c
index ec7a7e917edd..c0c7d01473f2 100644
--- a/drivers/i2c/busses/i2c-tegra-bpmp.c
+++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
@@ -80,7 +80,7 @@ static int tegra_bpmp_xlate_flags(u16 flags, u16 *out)
 		flags &= ~I2C_M_RECV_LEN;
 	}
 
-	return (flags != 0) ? -EINVAL : 0;
+	return 0;
 }
 
 /**
-- 
2.30.0

