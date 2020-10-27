Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7929C1CD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899733AbgJ0RZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900515AbgJ0Oxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DFA122281;
        Tue, 27 Oct 2020 14:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810417;
        bh=9CLILCPVgTaUt4VkfpGYMDGq5kPlOrV2Y9UK5QuXMk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRCCt1pn/h96Fj7HkDQ8HDxPaGfTVExdPKuBalLDZ4r3+ATTXq/MH9ITbEsXs2naQ
         pdb+MEpxnexy79CWFNTrA/UCEpNBVtmE2fXytkJgBDNajU8V2pXdjiPoCFUxIIMH4K
         PVr5wAwbyuxXlJ9rUVAaW02Rb9TjOwcWJLaeRu/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 131/633] hwmon: (w83627ehf) Fix a resource leak in probe
Date:   Tue, 27 Oct 2020 14:47:54 +0100
Message-Id: <20201027135528.831109185@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 18360b33a071e5883250fd1e04bfdeff8c3887a3 ]

Smatch has a new check for resource leaks which found a bug in probe:

    drivers/hwmon/w83627ehf.c:2417 w83627ehf_probe()
    warn: 'res->start' not released on lines: 2412.

We need to clean up if devm_hwmon_device_register_with_info() fails.

Fixes: 266cd5835947 ("hwmon: (w83627ehf) convert to with_info interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dr. David Alan Gilbert <linux@treblig.org>
Link: https://lore.kernel.org/r/20200921125212.GA1128194@mwanda
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/w83627ehf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 5a5120121e507..3964ceab2817c 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1951,8 +1951,12 @@ static int w83627ehf_probe(struct platform_device *pdev)
 							 data,
 							 &w83627ehf_chip_info,
 							 w83627ehf_groups);
+	if (IS_ERR(hwmon_dev)) {
+		err = PTR_ERR(hwmon_dev);
+		goto exit_release;
+	}
 
-	return PTR_ERR_OR_ZERO(hwmon_dev);
+	return 0;
 
 exit_release:
 	release_region(res->start, IOREGION_LENGTH);
-- 
2.25.1



