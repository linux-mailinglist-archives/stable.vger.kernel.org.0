Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F712C65E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbfL2RqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731047AbfL2RqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262D824670;
        Sun, 29 Dec 2019 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641576;
        bh=hXZmK+bkVoyydZcV2t6icF7qk4k967/iyGDHo0RHLoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnZdZOiUoTFUkL/jiNdEa+6ORfKTjZxvfFOiI8bVibpx43aAAe1MnSnN/9l8geAIb
         qB9mz7RNQyoXef7qs8P0orZCTpxibHPRDtR6X76gia8sA7+B7xSnD/Yd2yW74RIdmQ
         Q6YHVRIYxHxRhsSxsq1A75545PNGbPcLn51x9zJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/434] crypto: inside-secure - Fix a maybe-uninitialized warning
Date:   Sun, 29 Dec 2019 18:22:56 +0100
Message-Id: <20191229172709.865939809@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 74e6bd472b6d9e80ec9972989d8991736fe46c51 ]

A previous fixup avoided an unused variable warning but replaced
it with a slightly scarier warning:

drivers/crypto/inside-secure/safexcel.c:1100:6: error: variable 'irq' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]

This is harmless as it is impossible to get into this case, but
the compiler has no way of knowing that. Add an explicit error
handling case to make it obvious to both compilers and humans
reading the source.

Fixes: 212ef6f29e5b ("crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 294debd435b6..991a4425f006 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1120,6 +1120,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irq_name, irq);
 			return irq;
 		}
+	} else {
+		return -ENXIO;
 	}
 
 	ret = devm_request_threaded_irq(dev, irq, handler,
-- 
2.20.1



