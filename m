Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26BA29AFEE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507990AbgJ0OOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756588AbgJ0OOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:14:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D126C2222C;
        Tue, 27 Oct 2020 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808062;
        bh=UFpjtS7RJt3OBGdx9vh541bXz4OvrDAqawAjNxjpJiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ko57DJCUqcrL6EQ85Ee2cbKYgm/wJB5eGtsnqOHvUQUBKz/zp8h8xWwwupqiRupDL
         s9DAf+6j3RKbFSkROX5Uly5PGUPXpzFHT1fiqHqTL+ECaG3TqE4C0nECO/EqCPVohR
         6MscVSnmLoy9TTpntxvJgN76TmNLvU41fgw/gQ5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/191] overflow: Include header file with SIZE_MAX declaration
Date:   Tue, 27 Oct 2020 14:49:16 +0100
Message-Id: <20201027134914.558157448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
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



