Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50722A59CD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbgKCWK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgKCUhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:37:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB4EF2224E;
        Tue,  3 Nov 2020 20:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435860;
        bh=byPK70+5pE06e1/UUMLk8VuJsIfZZaPpFggvr2BzTDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T15OmLJCoXVpKvZNs0nAZfhmcanmAkWdSoVVjv09wU4Ex09AmR/ucDga7Xl2vl0ny
         DEAFmBWLkS9QRp0fxLEu3lO0Gldm5x1FKyewYiCxy5YN8LucoMUC7lN9mZR7Bg9RwP
         WCefo7yEgGsoaLc+CbKKBPzZcAP761F9DQzwFxk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 014/391] firmware: arm_scmi: Fix ARCH_COLD_RESET
Date:   Tue,  3 Nov 2020 21:31:05 +0100
Message-Id: <20201103203348.952852393@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Etienne Carriere <etienne.carriere@linaro.org>

[ Upstream commit 45b9e04d5ba0b043783dfe2b19bb728e712cb32e ]

The defination for ARCH_COLD_RESET is wrong. Let us fix it according to
the SCMI specification.

Link: https://lore.kernel.org/r/20201008143722.21888-5-etienne.carriere@linaro.org
Fixes: 95a15d80aa0d ("firmware: arm_scmi: Add RESET protocol in SCMI v2.0")
Signed-off-by: Etienne Carriere <etienne.carriere@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/reset.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/reset.c b/drivers/firmware/arm_scmi/reset.c
index 3691bafca0574..86bda46de8eb8 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -36,9 +36,7 @@ struct scmi_msg_reset_domain_reset {
 #define EXPLICIT_RESET_ASSERT	BIT(1)
 #define ASYNCHRONOUS_RESET	BIT(2)
 	__le32 reset_state;
-#define ARCH_RESET_TYPE		BIT(31)
-#define COLD_RESET_STATE	BIT(0)
-#define ARCH_COLD_RESET		(ARCH_RESET_TYPE | COLD_RESET_STATE)
+#define ARCH_COLD_RESET		0
 };
 
 struct scmi_msg_reset_notify {
-- 
2.27.0



