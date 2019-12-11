Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5B811B00A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfLKPS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732040AbfLKPSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1062324654;
        Wed, 11 Dec 2019 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077534;
        bh=cZRXYZr3dnqdd2ZANv1oCOypDbcNrsP6ksZp+LUmUVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0KVAoL5cYDPuofzMR6XCplmEoxGCPrS9VW+mxaaPGae4z0DZpoIEFYRAD5T/w5co
         qqi8OAnppLKS5IZq8jR+l4Du7OpGuHfv5W8McKWcNjWBecPGW4VVKYKHof91bYlfJP
         8RNRcozqyWOQGE1lX1DZhKH5q324KHOAkGjnRYf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng-Yi Chiang <cychiang@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/243] regulator: Fix return value of _set_load() stub
Date:   Wed, 11 Dec 2019 16:03:50 +0100
Message-Id: <20191211150343.689372303@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit f1abf67217de91f5cd3c757ae857632ca565099a ]

The stub implementation of _set_load() returns a mode value which is
within the bounds of valid return codes for success (the documentation
just says that failures are negative error codes) but not sensible or
what the actual implementation does.  Fix it to just return 0.

Reported-by: Cheng-Yi Chiang <cychiang@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 25602afd48447..f3f76051e8b00 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -508,7 +508,7 @@ static inline int regulator_get_error_flags(struct regulator *regulator,
 
 static inline int regulator_set_load(struct regulator *regulator, int load_uA)
 {
-	return REGULATOR_MODE_NORMAL;
+	return 0;
 }
 
 static inline int regulator_allow_bypass(struct regulator *regulator,
-- 
2.20.1



