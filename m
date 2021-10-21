Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A04435700
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhJUAX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231657AbhJUAXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 164C16128E;
        Thu, 21 Oct 2021 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775690;
        bh=+EA6kfUUKMaZYnxrvRcN5iXLSF39LaiQS0puWiMjOlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9D5SA5w4hGl6DY2T64Gup5Tgdm4cVOp2y37GKj/J0KS+8fKJM39dHfXC5Cn10/Vn
         PAYroh2vvcJvXdRR3a3oukUkKlLJ8nTCVABJZgcRbKepzBCxVYD0eyXQM6uYkPe8ER
         Ft5vjo/NKaq66VWaoOp9/fXgqy5ucR5xo9tls8wxQXUJi81CmcNS+9jclpiGKvwHt6
         iy4f+HVA+2qYupLoJpO67DlwuLBgZvf77kc8QTjP2fXRE2VyenBanh3dQb4DZwisb8
         Kyy88GyVTQPEm2FUmgwqJc0o5U/QrTGLO/b+I9u+pu26NwnEGu90OQ4Ri2DSEqXMpw
         86TPHmiJRqYWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 17/26] platform/x86: intel_scu_ipc: Increase virtual timeout to 10s
Date:   Wed, 20 Oct 2021 20:20:14 -0400
Message-Id: <20211021002023.1128949-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 5c02b581ce84eea240d25c8318a1f65133a04415 ]

Commit a7d53dbbc70a ("platform/x86: intel_scu_ipc: Increase virtual
timeout from 3 to 5 seconds") states that the recommended timeout range
is 5-10 seconds. Adjust the timeout value to the higher of those i.e 10
seconds, to account for situations where the 5 seconds is insufficient
for disconnect command success.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20210928101932.2543937-3-pmalani@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 9171a46a9e3f..c78cd12ffca7 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -75,7 +75,7 @@ struct intel_scu_ipc_dev {
 #define IPC_READ_BUFFER		0x90
 
 /* Timeout in jiffies */
-#define IPC_TIMEOUT		(5 * HZ)
+#define IPC_TIMEOUT		(10 * HZ)
 
 static struct intel_scu_ipc_dev *ipcdev; /* Only one for now */
 static DEFINE_MUTEX(ipclock); /* lock used to prevent multiple call to SCU */
-- 
2.33.0

