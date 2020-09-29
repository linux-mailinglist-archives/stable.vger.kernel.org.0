Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5EF27CC99
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgI2Mhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbgI2LR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:17:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E637B21D7D;
        Tue, 29 Sep 2020 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378271;
        bh=ZTL5jCG7jOOIjWhvX+LYQwkt2VOk6APcn1Oums1GkMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ht8299NDG6xff4nocRlEmPzWyHVtx4K6YWzaGPMjh18uaEAbi8JTAVUt5TwXtFPfC
         obaaR55SkGOYqpVuL5L8la7wPODSxA1dJQY/rkHU0agJhA3v/5UOaQGtkU3Kp2If1i
         OlfbYGBx5o4qLHnwZOxi+6a469WmIMjINYwzo3XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Ravier <gabravier@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/166] tools: gpio-hammer: Avoid potential overflow in main
Date:   Tue, 29 Sep 2020 13:00:03 +0200
Message-Id: <20200929105939.761389534@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



