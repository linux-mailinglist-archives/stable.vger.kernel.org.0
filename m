Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2899129AEF8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443715AbgJ0OGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754606AbgJ0OGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:06:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E4E22258;
        Tue, 27 Oct 2020 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807569;
        bh=UFpjtS7RJt3OBGdx9vh541bXz4OvrDAqawAjNxjpJiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykvtONjA/GzlvjAnMKBJw0F7ghogG0NH491XAl79DWhMMWBcLOE0i7bF8DoESH6ku
         aEFgYnn6nGlfAdzh6Z8fZ/nca0iXxR+U7RmH4Q+ujeW31PHwhiWlhQF+XtiLFkNmrU
         mrUs7mMECbndxecIwUVeGis2S6wS/bHvbc1spBbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 070/139] overflow: Include header file with SIZE_MAX declaration
Date:   Tue, 27 Oct 2020 14:49:24 +0100
Message-Id: <20201027134905.445783349@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a4947e84f23474803b62a2759b5808147e4e15f9 ]

The various array_size functions use SIZE_MAX define, but missed limits.h
causes to failure to compile code that needs overflow.h.

 In file included from drivers/infiniband/core/uverbs_std_types_device.c:6:
 ./include/linux/overflow.h: In function 'array_size':
 ./include/linux/overflow.h:258:10: error: 'SIZE_MAX' undeclared (first use in this function)
   258 |   return SIZE_MAX;
       |          ^~~~~~~~

Fixes: 610b15c50e86 ("overflow.h: Add allocation size calculation helpers")
Link: https://lore.kernel.org/r/20200913102928.134985-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/overflow.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 40b48e2133cb8..38a47cc62cf3a 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -3,6 +3,7 @@
 #define __LINUX_OVERFLOW_H
 
 #include <linux/compiler.h>
+#include <linux/limits.h>
 
 /*
  * In the fallback code below, we need to compute the minimum and
-- 
2.25.1



