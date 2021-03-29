Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6579634CA1C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhC2Ie6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234794AbhC2Idh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9AF161996;
        Mon, 29 Mar 2021 08:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006817;
        bh=2bB1BsYi0wvmxmdT/8Bv5WpePpyBBSxXMSL7H9MiJmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qK3dDGykwyhIqpRwW4v9fHuR8HqNuYXKL2fbtb4MW2tAEpEtxjtILBWsXLpdjUAC
         EzgNJ34BARCqSIPoNhrvdfVeGEoHy0VD6zJZmTYF9nFueMJw4OkqW4H3LTHL/r7kA1
         tU94ydjIeB06+je6gqM0XwE5ZLPw8QhlcX3v7OnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqin Liu <yongqin.liu@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 109/254] soc: ti: omap-prm: Fix occasional abort on reset deassert for dra7 iva
Date:   Mon, 29 Mar 2021 09:57:05 +0200
Message-Id: <20210329075636.791911470@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit effe89e40037038db7711bdab5d3401fe297d72c ]

On reset deassert, we must wait a bit after the rstst bit change before
we allow clockdomain autoidle again. Otherwise we get the following oops
sometimes on dra7 with iva:

Unhandled fault: imprecise external abort (0x1406) at 0x00000000
44000000.ocp:L3 Standard Error: MASTER MPU TARGET IVA_CONFIG (Read Link):
At Address: 0x0005A410 : Data Access in User mode during Functional access
Internal error: : 1406 [#1] SMP ARM
...
(sysc_write_sysconfig) from [<c0782cb0>] (sysc_enable_module+0xcc/0x260)
(sysc_enable_module) from [<c0782f0c>] (sysc_runtime_resume+0xc8/0x174)
(sysc_runtime_resume) from [<c0a3e1ac>] (genpd_runtime_resume+0x94/0x224)
(genpd_runtime_resume) from [<c0a33f0c>] (__rpm_callback+0xd8/0x180)

It is unclear what all devices this might affect, but presumably other
devices with the rstst bit too can be affected. So let's just enable the
delay for all the devices with rstst bit for now. Later on we may want to
limit the list to the know affected devices if needed.

Fixes: d30cd83f6853 ("soc: ti: omap-prm: add support for denying idle for reset clockdomain")
Reported-by: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 17ea6a74a988..51143a68a889 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -830,8 +830,12 @@ static int omap_reset_deassert(struct reset_controller_dev *rcdev,
 		       reset->prm->data->name, id);
 
 exit:
-	if (reset->clkdm)
+	if (reset->clkdm) {
+		/* At least dra7 iva needs a delay before clkdm idle */
+		if (has_rstst)
+			udelay(1);
 		pdata->clkdm_allow_idle(reset->clkdm);
+	}
 
 	return ret;
 }
-- 
2.30.1



