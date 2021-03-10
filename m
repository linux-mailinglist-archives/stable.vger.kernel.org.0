Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83F1333DC6
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCJNYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232832AbhCJNYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0369D64FEF;
        Wed, 10 Mar 2021 13:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382672;
        bh=SrpHNz+9s1NbwOcx1sv9lILKLb86ARnZkK3UFGGccyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ze2dN8wHr5y9WeVrxl3TCrcEhxoGB4uBTzTFS0G0jGvTs10tD2b9xohnhJ/Se1gfS
         pekZRWQuLeIasvUy2DNxeePc+X0UMKh9RoCMXFyQTGHv98fafnFyAxXrpyQOqpJxJ4
         RSqdwgRbvdvlpQTcce9xR/Ln/H2Znl+wbq3S9nWg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/49] net: ipa: ignore CHANNEL_NOT_RUNNING errors
Date:   Wed, 10 Mar 2021 14:23:25 +0100
Message-Id: <20210310132322.413240905@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alex Elder <elder@linaro.org>

[ Upstream commit f849afcc8c3b27d7b50827e95b60557f24184df0 ]

IPA v4.2 has a hardware quirk that requires the AP to allocate GSI
channels for the modem to use.  It is recommended that these modem
channels get stopped (with a HALT generic command) by the AP when
its IPA driver gets removed.

The AP has no way of knowing the current state of a modem channel.
So when the IPA driver issues a HALT command it's possible the
channel is not running, and in that case we get an error indication.
This error simply means we didn't need to stop the channel, so we
can ignore it.

This patch adds an explanation for this situation, and arranges for
this condition to *not* report an error message.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2a65efd3e8da..48ee43b89fec 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1052,10 +1052,32 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	u32 result;
 	u32 val;
 
+	/* This interrupt is used to handle completions of the two GENERIC
+	 * GSI commands.  We use these to allocate and halt channels on
+	 * the modem's behalf due to a hardware quirk on IPA v4.2.  Once
+	 * allocated, the modem "owns" these channels, and as a result we
+	 * have no way of knowing the channel's state at any given time.
+	 *
+	 * It is recommended that we halt the modem channels we allocated
+	 * when shutting down, but it's possible the channel isn't running
+	 * at the time we issue the HALT command.  We'll get an error in
+	 * that case, but it's harmless (the channel is already halted).
+	 *
+	 * For this reason, we silently ignore a CHANNEL_NOT_RUNNING error
+	 * if we receive it.
+	 */
 	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
 	result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
-	if (result != GENERIC_EE_SUCCESS_FVAL)
+
+	switch (result) {
+	case GENERIC_EE_SUCCESS_FVAL:
+	case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
+		break;
+
+	default:
 		dev_err(gsi->dev, "global INT1 generic result %u\n", result);
+		break;
+	}
 
 	complete(&gsi->completion);
 }
-- 
2.30.1



