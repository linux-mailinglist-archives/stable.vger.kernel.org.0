Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09751E32F4
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502136AbfJXMtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:51 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35884 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502121AbfJXMtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:50 -0400
Received: by mail-wm1-f50.google.com with SMTP id c22so2490761wmd.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F6Gq4HQU3/N5BtsMMqihacaO4E8duMIPOur1dTD0bwQ=;
        b=FoChUK54o/khbUF9HkBOvWhoa55nwJUwL/kXxUMoZBczI/Fz8m8wDp3H875n6U9e0V
         chr3OJbhYVFkwHbGgAhtRwjGAZq0oSecOCkQjqP75KHb6OINqcfNiXt/EhzC2B87+PAk
         A5C4prFUC50OZZ7xLZc1S5Dnn2/8EySuZWJ5CoyBcBTesw04qh6w5KPKgU9iO31okRjw
         quAgZCfh+eoDwHg6iOcd/mT4bBmcohcV9zOe/nqnjwu8TUgB43G+v8gMxNY+APpZOU91
         ipM+1EP/+8Lk2oKvInrmZi9iV9s/3EWe9BhO+sCVVUFuYfg3MzKmtq1zUKInKBJ2m8fm
         nQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F6Gq4HQU3/N5BtsMMqihacaO4E8duMIPOur1dTD0bwQ=;
        b=NjiH9ZaOemJm2ArRdVVG7JGENupB0MC5KyqKrofg4rTa4+CsbGN7UEckFvd4na0N6Y
         lJ/SyNII5vE70+4oI/jsz17TYL06V7nViUIma1IK8OE/Ivi2w5ZnERV39wgp0xBfqsB2
         Qrk6sSnnjR1phyuvxkOA/orHSsXC/uSxt2TcMx1w1/c+GCEpvly9g01ld99yKMpCBQef
         wYUcCPtpEsl20Huwzky3rN4IghRrKhBNeVIO6vZKefgWZsF8pNN1DZxAtwK8/DAA25fo
         01lv3E1N+BqMtszdCmEZe+/bjmr7gYblp2s6yygN0GzAdtio3cIZRVp302ZZ0IF5muSh
         6jiQ==
X-Gm-Message-State: APjAAAWr5tum+8oPl6z0kg4StXQJlRN43KiV39XJdydnkhnnTOdDzr5d
        bJpFg2wYUJvn5eZlOK9cKkZlyYGBgTmt/rHR
X-Google-Smtp-Source: APXvYqxxQ/0vo4eMMX/ZMSv3QY1RfbqykB7f5VifNrA67xzSSJAVRT/yuq+N7ds2yGQO1hGY15p9ng==
X-Received: by 2002:a1c:650b:: with SMTP id z11mr4787989wmb.149.1571921388660;
        Thu, 24 Oct 2019 05:49:48 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Mian Yousaf Kaukab <ykaukab@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 38/48] arm64: enable generic CPU vulnerabilites support
Date:   Thu, 24 Oct 2019 14:48:23 +0200
Message-Id: <20191024124833.4158-39-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 61ae1321f06c4489c724c803e9b8363dea576da3 ]

Enable CPU vulnerabilty show functions for spectre_v1, spectre_v2,
meltdown and store-bypass.

Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c30cd78b6918..e296ae3e20f4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -49,6 +49,7 @@ config ARM64
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_CPU_AUTOPROBE
+	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IRQ_PROBE
-- 
2.20.1

