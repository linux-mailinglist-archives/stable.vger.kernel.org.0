Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D389613F470
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389637AbgAPRJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389635AbgAPRJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7217021D56;
        Thu, 16 Jan 2020 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194554;
        bh=Kqk6fl6f5LB8HMHeUsBnSkg3ZQMA6NTi9LKibYodp1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAbdnb4yE2Pz6f4szPh27+ZCQM3txynKywa5dHxd4APcz1TkUBqdNhSkB5jVRe4Xj
         8N1w6Y1OjTlcePvhA6SrNNvVampeozlxJvWZvCcKkr/X3o06kOdJS9kCBp7zeeYWTz
         C6mQanpOAnMcFsrUCISIAO866Ab3mVCQ7U0Y9lFo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bryan O'Donoghue <pure.logic@nexus-software.ie>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 436/671] nvmem: imx-ocotp: Change TIMING calculation to u-boot algorithm
Date:   Thu, 16 Jan 2020 12:01:14 -0500
Message-Id: <20200116170509.12787-173-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

[ Upstream commit 159dbaf57b2f4f67ecb59b2c87d071e45ed41d7e ]

The RELAX field of the OCOTP block is turning out as a zero on i.MX8MM.
This messes up the subsequent re-load of the fuse shadow registers.

After some discussion with people @ NXP its clear we have missed a trick
here in Linux.

The OCOTP fuse programming time has a physical minimum 'burn time' that is
not related to the ipg_clk.

We need to define the RELAX, STROBE_READ and STROBE_PROG fields in terms of
desired timings to allow for the burn-in to safely complete. Right now only
the RELAX field is calculated in terms of an absolute time and we are
ending up with a value of zero.

This patch inherits the u-boot timings for the OCOTP_TIMING calculation on
the i.MX6 and i.MX8. Those timings are known to work and critically specify
values such as STROBE_PROG as a minimum timing.

Fixes: 0642bac7da42 ("nvmem: imx-ocotp: add write support")

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Suggested-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/imx-ocotp.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
index 04421a73f74a..09281aca86c2 100644
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -50,7 +50,9 @@
 #define IMX_OCOTP_BM_CTRL_ERROR		0x00000200
 #define IMX_OCOTP_BM_CTRL_REL_SHADOWS	0x00000400
 
-#define DEF_RELAX			20	/* > 16.5ns */
+#define TIMING_STROBE_PROG_US		10	/* Min time to blow a fuse */
+#define TIMING_STROBE_READ_NS		37	/* Min time before read */
+#define TIMING_RELAX_NS			17
 #define DEF_FSOURCE			1001	/* > 1000 ns */
 #define DEF_STROBE_PROG			10000	/* IPG clocks */
 #define IMX_OCOTP_WR_UNLOCK		0x3E770000
@@ -182,12 +184,38 @@ static void imx_ocotp_set_imx6_timing(struct ocotp_priv *priv)
 	 * fields with timing values to match the current frequency of the
 	 * ipg_clk. OTP writes will work at maximum bus frequencies as long
 	 * as the HW_OCOTP_TIMING parameters are set correctly.
+	 *
+	 * Note: there are minimum timings required to ensure an OTP fuse burns
+	 * correctly that are independent of the ipg_clk. Those values are not
+	 * formally documented anywhere however, working from the minimum
+	 * timings given in u-boot we can say:
+	 *
+	 * - Minimum STROBE_PROG time is 10 microseconds. Intuitively 10
+	 *   microseconds feels about right as representative of a minimum time
+	 *   to physically burn out a fuse.
+	 *
+	 * - Minimum STROBE_READ i.e. the time to wait post OTP fuse burn before
+	 *   performing another read is 37 nanoseconds
+	 *
+	 * - Minimum RELAX timing is 17 nanoseconds. This final RELAX minimum
+	 *   timing is not entirely clear the documentation says "This
+	 *   count value specifies the time to add to all default timing
+	 *   parameters other than the Tpgm and Trd. It is given in number
+	 *   of ipg_clk periods." where Tpgm and Trd refer to STROBE_PROG
+	 *   and STROBE_READ respectively. What the other timing parameters
+	 *   are though, is not specified. Experience shows a zero RELAX
+	 *   value will mess up a re-load of the shadow registers post OTP
+	 *   burn.
 	 */
 	clk_rate = clk_get_rate(priv->clk);
 
-	relax = clk_rate / (1000000000 / DEF_RELAX) - 1;
-	strobe_prog = clk_rate / (1000000000 / 10000) + 2 * (DEF_RELAX + 1) - 1;
-	strobe_read = clk_rate / (1000000000 / 40) + 2 * (DEF_RELAX + 1) - 1;
+	relax = DIV_ROUND_UP(clk_rate * TIMING_RELAX_NS, 1000000000) - 1;
+	strobe_read = DIV_ROUND_UP(clk_rate * TIMING_STROBE_READ_NS,
+				   1000000000);
+	strobe_read += 2 * (relax + 1) - 1;
+	strobe_prog = DIV_ROUND_CLOSEST(clk_rate * TIMING_STROBE_PROG_US,
+					1000000);
+	strobe_prog += 2 * (relax + 1) - 1;
 
 	timing = readl(priv->base + IMX_OCOTP_ADDR_TIMING) & 0x0FC00000;
 	timing |= strobe_prog & 0x00000FFF;
-- 
2.20.1

