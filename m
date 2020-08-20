Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2216024BF08
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgHTNjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgHTJ3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:29:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B8A2075E;
        Thu, 20 Aug 2020 09:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915745;
        bh=ifY08RktxRwj5+E/Tr2wAaVytBAVd0Gw42ZhtSRJAxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KibHYYbGH7UxkXmCssSaaDPSYVsVjliLmSqvIc4+sGb0ToqATVvpxr70K0q2HzlAm
         vVQcr9twatlXhq3b+KF11DhOlXfUb6Uw7YYlG/pyF8GVUCprEhEscw45YErlHjY4ZL
         andHM43jZHEGYB5AZs8dEEdPU8y5toBcUStUa7Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Mathew King <mathewk@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 119/232] platform/chrome: cros_ec_ishtp: Fix a double-unlock issue
Date:   Thu, 20 Aug 2020 11:19:30 +0200
Message-Id: <20200820091618.583013949@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit aaa3cbbac326c95308e315f1ab964a3369c4d07d ]

In function cros_ec_ishtp_probe(), "up_write" is already called
before function "cros_ec_dev_init". But "up_write" will be called
again after the calling of the function "cros_ec_dev_init" failed.
Thus add a call of the function “down_write” in this if branch
for the completion of the exception handling.

Fixes: 26a14267aff2 ("platform/chrome: Add ChromeOS EC ISHTP driver")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Tested-by: Mathew King <mathewk@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_ishtp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_ishtp.c b/drivers/platform/chrome/cros_ec_ishtp.c
index ed794a7ddba9b..81364029af367 100644
--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -681,8 +681,10 @@ static int cros_ec_ishtp_probe(struct ishtp_cl_device *cl_device)
 
 	/* Register croc_ec_dev mfd */
 	rv = cros_ec_dev_init(client_data);
-	if (rv)
+	if (rv) {
+		down_write(&init_lock);
 		goto end_cros_ec_dev_init_error;
+	}
 
 	return 0;
 
-- 
2.25.1



