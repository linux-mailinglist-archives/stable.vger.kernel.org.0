Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FD026F07D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgIRCoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbgIRCKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5CA22208;
        Fri, 18 Sep 2020 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395033;
        bh=ZTL5jCG7jOOIjWhvX+LYQwkt2VOk6APcn1Oums1GkMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xt4bO6k49E8sXmL5E0XaCYoTayVF01c5uHcWTT9DrpuzBObJXU0BzCox511aAeX+t
         p8M1TW9MmWt75xovUz/o3sUNX8WcWRBTc4XrRu5HJ+KxKzq6qrS9GWwqmN4Pfu4wxt
         kjU9UaXpd5NyNPkS9/dLKG3jsBeSep0jUtb1RThE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Ravier <gabravier@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 125/206] tools: gpio-hammer: Avoid potential overflow in main
Date:   Thu, 17 Sep 2020 22:06:41 -0400
Message-Id: <20200918020802.2065198-125-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Ravier <gabravier@gmail.com>

[ Upstream commit d1ee7e1f5c9191afb69ce46cc7752e4257340a31 ]

If '-o' was used more than 64 times in a single invocation of gpio-hammer,
this could lead to an overflow of the 'lines' array. This commit fixes
this by avoiding the overflow and giving a proper diagnostic back to the
user

Signed-off-by: Gabriel Ravier <gabravier@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/gpio-hammer.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/gpio/gpio-hammer.c b/tools/gpio/gpio-hammer.c
index 4bcb234c0fcab..3da5462a0c7d3 100644
--- a/tools/gpio/gpio-hammer.c
+++ b/tools/gpio/gpio-hammer.c
@@ -138,7 +138,14 @@ int main(int argc, char **argv)
 			device_name = optarg;
 			break;
 		case 'o':
-			lines[i] = strtoul(optarg, NULL, 10);
+			/*
+			 * Avoid overflow. Do not immediately error, we want to
+			 * be able to accurately report on the amount of times
+			 * '-o' was given to give an accurate error message
+			 */
+			if (i < GPIOHANDLES_MAX)
+				lines[i] = strtoul(optarg, NULL, 10);
+
 			i++;
 			break;
 		case '?':
@@ -146,6 +153,14 @@ int main(int argc, char **argv)
 			return -1;
 		}
 	}
+
+	if (i >= GPIOHANDLES_MAX) {
+		fprintf(stderr,
+			"Only %d occurences of '-o' are allowed, %d were found\n",
+			GPIOHANDLES_MAX, i + 1);
+		return -1;
+	}
+
 	nlines = i;
 
 	if (!device_name || !nlines) {
-- 
2.25.1

