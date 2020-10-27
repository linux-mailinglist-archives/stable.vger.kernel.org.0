Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C85A29B9B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802742AbgJ0PvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802121AbgJ0Ppm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1CB121D42;
        Tue, 27 Oct 2020 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813541;
        bh=RRZmttM4P2Oj0fsEhSeJe4ruELQyq7AWGADE60/xUAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ug5dJ6/ooEljCsVPCKNMcRZa0Dw+9exVLDay0GsM3ehXS4R9A9DwhPZuCGkOPJxDw
         NrSxltx1Fy+FxrhJzDn6g6SQow98dIZoh6W4X/r/z38LvyO0EuqV/f6tjI3MzoejOY
         6nGGPa5Z6O/9gyf7G11TjpvH+L+eFAfht7PIAlnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 587/757] memory: brcmstb_dpfe: fix array index out of bounds
Date:   Tue, 27 Oct 2020 14:53:57 +0100
Message-Id: <20201027135518.067024639@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Mayer <mmayer@broadcom.com>

[ Upstream commit f42ae4bbf94c15aa720afb9d176ecbfe140d792e ]

We would overrun the error_text array if we hit a TIMEOUT condition,
because we were using the error code "ETIMEDOUT" (which is 110) as an
array index.

We fix the problem by correcting the array index and by providing a
function to retrieve error messages rather than accessing the array
directly. The function includes a bounds check that prevents the array
from being overrun.

Link: https://lore.kernel.org/linux-arm-kernel/38d00022-730c-948a-917c-d86382df8cb9@canonical.com/
Link: https://lore.kernel.org/r/20200822205000.15841-1-mmayer@broadcom.com
Fixes: 2f330caff577 ("memory: brcmstb: Add driver for DPFE")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Markus Mayer <mmayer@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 60e8633b11758..ddff687c79eaa 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -188,11 +188,6 @@ struct brcmstb_dpfe_priv {
 	struct mutex lock;
 };
 
-static const char * const error_text[] = {
-	"Success", "Header code incorrect", "Unknown command or argument",
-	"Incorrect checksum", "Malformed command", "Timed out",
-};
-
 /*
  * Forward declaration of our sysfs attribute functions, so we can declare the
  * attribute data structures early.
@@ -307,6 +302,20 @@ static const struct dpfe_api dpfe_api_v3 = {
 	},
 };
 
+static const char *get_error_text(unsigned int i)
+{
+	static const char * const error_text[] = {
+		"Success", "Header code incorrect",
+		"Unknown command or argument", "Incorrect checksum",
+		"Malformed command", "Timed out", "Unknown error",
+	};
+
+	if (unlikely(i >= ARRAY_SIZE(error_text)))
+		i = ARRAY_SIZE(error_text) - 1;
+
+	return error_text[i];
+}
+
 static bool is_dcpu_enabled(struct brcmstb_dpfe_priv *priv)
 {
 	u32 val;
@@ -445,7 +454,7 @@ static int __send_command(struct brcmstb_dpfe_priv *priv, unsigned int cmd,
 	}
 	if (resp != 0) {
 		mutex_unlock(&priv->lock);
-		return -ETIMEDOUT;
+		return -ffs(DCPU_RET_ERR_TIMEDOUT);
 	}
 
 	/* Compute checksum over the message */
@@ -691,7 +700,7 @@ static ssize_t generic_show(unsigned int command, u32 response[],
 
 	ret = __send_command(priv, command, response);
 	if (ret < 0)
-		return sprintf(buf, "ERROR: %s\n", error_text[-ret]);
+		return sprintf(buf, "ERROR: %s\n", get_error_text(-ret));
 
 	return 0;
 }
-- 
2.25.1



