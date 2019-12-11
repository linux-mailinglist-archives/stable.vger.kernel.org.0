Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF311AFE3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbfLKPRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732022AbfLKPRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 100D92073D;
        Wed, 11 Dec 2019 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077449;
        bh=80j/E0KDL2Dkz6xUpS+snG/edEeZDfUDIosDXSbukLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clnWkEb+of9dEXheeWhMPuM6rCUHKFFjSLLVHHRHnT2ch2NUMMj+7UVH9AxLqJd+P
         0Jqs7+R6JRmfZs5Cb5j3tt9IkiuF281aMzDXdvXozLlCZNvtrZtJpUmMxeBL7oWdEW
         6GHj1QMfvSjupG5UXHSOqFXcryqxVEPjFRmAtoWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/243] rtc: max77686: Fix the returned value in case of error in max77686_rtc_read_time()
Date:   Wed, 11 Dec 2019 16:03:26 +0100
Message-Id: <20191211150342.097176053@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b28cc6cec3d814f5184cbebb2d1f987e769f534a ]

In case of error, we return 0.
This is spurious and not consistent with the other functions of the driver.
Commit e115a2bf1426 has modified more than what is said in the commit
message. Reverse part of it znd return an error when needed, as it was
previously.

Fixes: e115a2bf1426 ("rtc: max77686: stop validating rtc_time in .read_time")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-max77686.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 8a60900d6b8b5..4aff349ae301a 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -360,7 +360,7 @@ static int max77686_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 out:
 	mutex_unlock(&info->lock);
-	return 0;
+	return ret;
 }
 
 static int max77686_rtc_set_time(struct device *dev, struct rtc_time *tm)
-- 
2.20.1



