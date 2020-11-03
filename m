Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BC32A577B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbgKCUzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732444AbgKCUxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B59E3223AC;
        Tue,  3 Nov 2020 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436793;
        bh=wxicaN8Xq01Q9Z8XES/h1oYBUXwh7kb/qivCuBkce54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVQn4+4a+IMdwpU1gGp/y3UdkwbohK/H+Q9Sr7eiQHYvzqu+a694l3yYPDpMDMf1Z
         cdUDdFz9zwUOSPu8acFWhpJEke98ke6ccmZwgGNUF+II+Au2bJdTbwxbrz5A5DCKDg
         vMWBAPw5wOGLK2oGuQzKLmlvwtFKybtFZxisS6qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/214] firmware: arm_scmi: Fix ARCH_COLD_RESET
Date:   Tue,  3 Nov 2020 21:34:22 +0100
Message-Id: <20201103203251.081486503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
index ab42c21c55175..6d223f345b6c9 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -35,9 +35,7 @@ struct scmi_msg_reset_domain_reset {
 #define EXPLICIT_RESET_ASSERT	BIT(1)
 #define ASYNCHRONOUS_RESET	BIT(2)
 	__le32 reset_state;
-#define ARCH_RESET_TYPE		BIT(31)
-#define COLD_RESET_STATE	BIT(0)
-#define ARCH_COLD_RESET		(ARCH_RESET_TYPE | COLD_RESET_STATE)
+#define ARCH_COLD_RESET		0
 };
 
 struct reset_dom_info {
-- 
2.27.0



