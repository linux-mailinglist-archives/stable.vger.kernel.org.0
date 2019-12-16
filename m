Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49FF121783
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfLPSGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbfLPSGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C7E206E0;
        Mon, 16 Dec 2019 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519591;
        bh=pLnYl+1UmRwuAdwhBN5NkuD9Nu/Q41VUUiohA3ym19g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buoNUAzOCQ5Feggr/Prarb9YBKzAfGg5xiLbDqerhYcLP81pjTwxZvleWQ/kW7vpp
         cez0T9Mqps5Gv7vQfl66ziVGX+DK395Borr89cAx4UxJDpEm9Ih2zL0RHCQvjZXrIL
         dsyWvYf3abvVPhbDT7RDFtZFfuZ7SrfqhMWW7IEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/140] regulator: 88pm800: fix warning same module names
Date:   Mon, 16 Dec 2019 18:49:56 +0100
Message-Id: <20191216174828.185156004@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 6f10419187d0d5fe395e2a2f2a64370961bf02a3 ]

When building with CONFIG_MFD_88PM800 and CONFIG_REGULATOR_88PM800
enabled as loadable modules, we see the following warning:

warning: same module names found:
  drivers/regulator/88pm800.ko
  drivers/mfd/88pm800.ko

Rework so that the file is named 88pm800-regulator.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/{88pm800.c => 88pm800-regulator.c} | 0
 drivers/regulator/Makefile                           | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/regulator/{88pm800.c => 88pm800-regulator.c} (100%)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800-regulator.c
similarity index 100%
rename from drivers/regulator/88pm800.c
rename to drivers/regulator/88pm800-regulator.c
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 801d9a34a2037..bba9c4851faf3 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_88PG86X) += 88pg86x.o
-obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
+obj-$(CONFIG_REGULATOR_88PM800) += 88pm800-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_CPCAP) += cpcap-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
-- 
2.20.1



