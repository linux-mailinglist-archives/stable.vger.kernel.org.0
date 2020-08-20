Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165D524B2F4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgHTJj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgHTJj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E27820724;
        Thu, 20 Aug 2020 09:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916366;
        bh=NxMp6abjy8xTlR5yqGiFRuvZAaLxlVIyUALxmIvN0ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5f1Iou373/HDkXyZ4h19XhkTdVpeXm1a8IWzzxFYLgHDbGZOGzNC8NO+6ACBRwVu
         EomC22YI9Hs1GHBpflg4kMRELeh+vf6r0jvAQ3t9lSubC3JOsjNmejhNIzpm3bZjTX
         dMkuFyLp6A7OtWSIlYjuKQJeArCv/OQOxmugFkcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Mathew King <mathewk@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/204] platform/chrome: cros_ec_ishtp: Fix a double-unlock issue
Date:   Thu, 20 Aug 2020 11:20:01 +0200
Message-Id: <20200820091611.515635319@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
index 93a71e93a2f15..41d60af618c9d 100644
--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -660,8 +660,10 @@ static int cros_ec_ishtp_probe(struct ishtp_cl_device *cl_device)
 
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



