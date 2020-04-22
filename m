Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6681E1B3C8D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgDVKGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgDVKGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAAC820575;
        Wed, 22 Apr 2020 10:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550001;
        bh=1E9u5VFOzgJ/cOij6J0Pk+XqwsuH2wpFjhlyOy2JwUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoCLsmFOt7cMtIDYy1QsF7wUMCnL/hY091ZjjOJBLgyha361IlKrssGPHptv6qHs9
         wWNnJddv9V3hO6xMBTyA0BX/lQ15j96/g36/9cReXLGhcYr5OHRf9oDVAjNffn6dxo
         6Rh4bPGlh1Rz45PWhRsYy+I9bavdDMITbV6ck3EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hamad Kadmany <hkadmany@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 092/125] wil6210: increase firmware ready timeout
Date:   Wed, 22 Apr 2020 11:56:49 +0200
Message-Id: <20200422095048.145149324@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamad Kadmany <hkadmany@codeaurora.org>

[ Upstream commit 6ccae584014ef7074359eb4151086beef66ecfa9 ]

Firmware ready event may take longer than
current timeout in some scenarios, for example
with multiple RFs connected where each
requires an initial calibration.

Increase the timeout to support these scenarios.

Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wil6210/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -803,7 +803,7 @@ static void wil_bl_crash_info(struct wil
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {


