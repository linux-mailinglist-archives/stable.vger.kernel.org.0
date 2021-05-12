Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DDF37C71C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhELP6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234348AbhELPxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DE2661A19;
        Wed, 12 May 2021 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833226;
        bh=r+rHAkvJHzsbMu9zSvnkhHt9eHxstOQmjEdQ6fSQdog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqUDkw/U3Ykk9XHIazxFml25o2olBfTjxqmKaGTsLrtCq9rQ9luhymOhlSfzSH3Pd
         1Z7q0pbttldhH+JwxkTh7nvKU5ZXAH3LlA7CZI23aV1vY2ArKk/bmMOMEYqFzAaclh
         5EcBvWR9t0rk79msocp3hE8/nEp0DafGFE36ljgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Matt Merhar <mattmerhar@protonmail.com>
Subject: [PATCH 5.11 033/601] soc/tegra: regulators: Fix locking up when voltage-spread is out of range
Date:   Wed, 12 May 2021 16:41:50 +0200
Message-Id: <20210512144828.914714826@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit ef85bb582c41524e9e68dfdbde48e519dac4ab3d upstream.

Fix voltage coupler lockup which happens when voltage-spread is out
of range due to a bug in the code. The max-spread requirement shall be
accounted when CPU regulator doesn't have consumers. This problem is
observed on Tegra30 Ouya game console once system-wide DVFS is enabled
in a device-tree.

Fixes: 783807436f36 ("soc/tegra: regulators: Add regulators coupler for Tegra30")
Cc: stable@vger.kernel.org
Reported-by: Peter Geis <pgwipeout@gmail.com>
Tested-by: Peter Geis <pgwipeout@gmail.com> # Ouya T30
Tested-by: Matt Merhar <mattmerhar@protonmail.com> # Ouya T30
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/tegra/regulators-tegra30.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/tegra/regulators-tegra30.c
+++ b/drivers/soc/tegra/regulators-tegra30.c
@@ -178,7 +178,7 @@ static int tegra30_voltage_update(struct
 	 * survive the voltage drop if it's running on a higher frequency.
 	 */
 	if (!cpu_min_uV_consumers)
-		cpu_min_uV = cpu_uV;
+		cpu_min_uV = max(cpu_uV, cpu_min_uV);
 
 	/*
 	 * Bootloader shall set up voltages correctly, but if it


