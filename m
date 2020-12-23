Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDF52E1E39
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgLWPeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 350FB2337F;
        Wed, 23 Dec 2020 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737586;
        bh=00Q9qhWdSO+2oz2mWhLCyHmpYgRrjVthSubvHaP/amE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/oodU3aWezrb8Z8sCNKBMuG5pFTKetdVrb67MioN8AIxuvDQRzrS7W56vuFaHo4x
         /diGwtWIQXZid1wUN2XvIMfrlfI2AMcxCsH0M6IvpJMI6TSqvl75HIBa9OS/UXJmqG
         gzAYKCQCD1xxgkF8fRUwrp76p7+ikK4B3r7mFy9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 19/40] coresight: etm4x: Skip setting LPOVERRIDE bit for qcom, skip-power-up
Date:   Wed, 23 Dec 2020 16:33:20 +0100
Message-Id: <20201223150516.474876503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

commit ac0f82b1b4956e348a6b2de8104308144ffb6ef7 upstream.

There is a bug on the systems supporting to skip power up
(qcom,skip-power-up) where setting LPOVERRIDE bit(low-power
state override behaviour) will result in CPU hangs/lockups
even on the implementations which supports it. So skip
setting the LPOVERRIDE bit for such platforms.

Fixes: 02510a5aa78d ("coresight: etm4x: Add support to skip trace unit power up")
Cc: stable@vger.kernel.org
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -779,7 +779,7 @@ static void etm4_init_arch_data(void *in
 	 * LPOVERRIDE, bit[23] implementation supports
 	 * low-power state override
 	 */
-	if (BMVAL(etmidr5, 23, 23))
+	if (BMVAL(etmidr5, 23, 23) && (!drvdata->skip_power_up))
 		drvdata->lpoverride = true;
 	else
 		drvdata->lpoverride = false;


