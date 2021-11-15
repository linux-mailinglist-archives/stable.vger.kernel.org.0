Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0952D4521F7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376992AbhKPBHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245276AbhKOTT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 234B963526;
        Mon, 15 Nov 2021 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001096;
        bh=YvsW4dQ9soRoPuExYQmjPfee4G+s5F9IoOSJDp+Qk5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qc/Br2OnG1S8TsmYo8ZNKTUJNwIXYTWDi0wU7HSHIlL6akCHlqotsS/knxCshMoA6
         bwW10kpWE4NngdI3TLzaNj2SRrsiY1hd8RaZ/H6DSA8zoUgNQlAIV3M73f1599ibWN
         EvgKTyKKBmhNX4zPRiSnBHSDnKStXaX+ZGcGaik8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 026/917] crypto: s5p-sss - Add error handling in s5p_aes_probe()
Date:   Mon, 15 Nov 2021 17:52:01 +0100
Message-Id: <20211115165429.616544594@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

commit a472cc0dde3eb057db71c80f102556eeced03805 upstream.

The function s5p_aes_probe() does not perform sufficient error
checking after executing platform_get_resource(), thus fix it.

Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/s5p-sss.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2171,6 +2171,8 @@ static int s5p_aes_probe(struct platform
 
 	variant = find_s5p_sss_version(pdev);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	/*
 	 * Note: HASH and PRNG uses the same registers in secss, avoid


