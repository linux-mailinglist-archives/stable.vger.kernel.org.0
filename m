Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E12A515A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgKCUkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbgKCUkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B842224E;
        Tue,  3 Nov 2020 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436008;
        bh=QcMjzDod7yModzs0Cjm2McJaOvIUz808lnQ7EbXfL0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZzt6uD25dm/fZqWkk9mCYbg/GAaQQ1Ni9DYBrJ/Vg9S+OtCbmhXHXWTIJ0r85Fg8
         ULyYgOqakiKUHdO9cs4vhJNqFlGmVi2qx4XOJ5nxC3soLvFAQVirEouOSsTBDNTukx
         mKeKVjqV7Cp5Ls2iK5fdfSoNJ8Km8DtfiDG+7e4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 015/391] firmware: arm_scmi: Expand SMC/HVC message pool to more than one
Date:   Tue,  3 Nov 2020 21:31:06 +0100
Message-Id: <20201103203349.005811778@linuxfoundation.org>
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

[ Upstream commit 7adb2c8aaaa6a387af7140e57004beba2c04a4c6 ]

SMC/HVC can transmit only one message at the time as the shared memory
needs to be protected and the calls are synchronous.

However, in order to allow multiple threads to send SCMI messages
simultaneously, we need a larger poll of memory.

Let us just use value of 20 to keep it in sync mailbox transport
implementation. Any other value must work perfectly.

Link: https://lore.kernel.org/r/20201008143722.21888-4-etienne.carriere@linaro.org
Fixes: 1dc6558062da ("firmware: arm_scmi: Add smc/hvc transport")
Cc: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Etienne Carriere <etienne.carriere@linaro.org>
[sudeep.holla: reworded the commit message to indicate the practicality]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index a1537d123e385..22f83af6853a1 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -149,6 +149,6 @@ static struct scmi_transport_ops scmi_smc_ops = {
 const struct scmi_desc scmi_smc_desc = {
 	.ops = &scmi_smc_ops,
 	.max_rx_timeout_ms = 30,
-	.max_msg = 1,
+	.max_msg = 20,
 	.max_msg_size = 128,
 };
-- 
2.27.0



