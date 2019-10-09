Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED13D16A2
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbfJIRbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732063AbfJIRYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:00 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E2921920;
        Wed,  9 Oct 2019 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641839;
        bh=8bnMYcLJcKc4ZU8HhKpFN1Z0TuerJPwW6b+l8HVm9/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKGYLMLAa2Wvzk4k5sY9/cXLyczoZgHVFjQ9HdBOWiuyNL0ejS0xdXN3FqD7iCIlE
         N32dKQRk4WpzxADzu68ifDxCr7x9XCGoKQEeVj/Ap094WqZJQzbCKbfcEykCv5XBLr
         OXZpvtB0yPrK3/3LReQpbMOm3snaze88lGJrcCIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 23/68] nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T
Date:   Wed,  9 Oct 2019 13:05:02 -0400
Message-Id: <20191009170547.32204-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit 19ea025e1d28c629b369c3532a85b3df478cc5c6 ]

Kingston NVME SSD with firmware version E8FK11.T has no interrupt after
resume with actions related to suspend to idle. This patch applied
NVME_QUIRK_SIMPLE_SUSPEND quirk to fix this issue.

Fixes: d916b1be94b6 ("nvme-pci: use host managed power state for suspend")
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204887
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ac2ac06d870b5..3304e2c8a448a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2270,6 +2270,16 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		.vid = 0x14a4,
 		.fr = "22301111",
 		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
+	},
+	{
+		/*
+		 * This Kingston E8FK11.T firmware version has no interrupt
+		 * after resume with actions related to suspend to idle
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=204887
+		 */
+		.vid = 0x2646,
+		.fr = "E8FK11.T",
+		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
 	}
 };
 
-- 
2.20.1

