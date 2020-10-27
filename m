Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E137829C14D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818856AbgJ0RYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900796AbgJ0OyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 949BA2231B;
        Tue, 27 Oct 2020 14:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810451;
        bh=biHJM8C+ItQFetRuYpsBSWjkyDAu9VvbvfyiUyE33Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvJDFpwGeaM7jVWiiuVZ+KlrR0y3HFiARUBn/uJQQWasYiJhufUAdpYhYq5dB/ghX
         HJZqAOqbZnem7n2bLPB4GTVZe9G5OHdYknSldtChvvn3tCTYxmcvPStwysqVSg7uoo
         LHGBjag7iImVaRedom6YBVxQlUCFknssNqsnhnz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 113/633] media: m5mols: Check function pointer in m5mols_sensor_power
Date:   Tue, 27 Oct 2020 14:47:36 +0100
Message-Id: <20201027135527.999038698@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 52438c4463ac904d14bf3496765e67750766f3a6 ]

clang static analysis reports this error

m5mols_core.c:767:4: warning: Called function pointer
  is null (null dereference) [core.CallAndMessage]
    info->set_power(&client->dev, 0);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In other places, the set_power ptr is checked.
So add a check.

Fixes: bc125106f8af ("[media] Add support for M-5MOLS 8 Mega Pixel camera ISP")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index de295114ca482..21666d705e372 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -764,7 +764,8 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 
 		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
 		if (ret) {
-			info->set_power(&client->dev, 0);
+			if (info->set_power)
+				info->set_power(&client->dev, 0);
 			return ret;
 		}
 
-- 
2.25.1



