Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4C92A513E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgKCUil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729979AbgKCUij (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0580A2224E;
        Tue,  3 Nov 2020 20:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435918;
        bh=bLUzBrhHhUKdPfSc2km8Z/3HgvV7ygst9xX0JGdFW6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgDHQ1wNzLOJR9bV5qS33ZV9U5I8K5QFgXSirJhhh3TW+bF/9RcXLidFAIeaLVwz+
         AVWGouvSYMEkEQZdqtcMMmXXXf1jffpBtI9OvaJTuIbm5Lu/EVRzXITGtcRl6JF9J8
         NQ6vHK4IWpbrTQEcJ4Zd9OiqD8YJ7eOYxd82rKMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>,
        Mike Tipton <mdtipton@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 039/391] interconnect: qcom: sdm845: Enable keepalive for the MM1 BCM
Date:   Tue,  3 Nov 2020 21:31:30 +0100
Message-Id: <20201103203350.304025384@linuxfoundation.org>
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

From: Georgi Djakov <georgi.djakov@linaro.org>

[ Upstream commit 5be1805dc3961ce0465bcb0beab85fe8580af08d ]

After enabling interconnect scaling for display on the db845c board,
in certain configurations the board hangs, while the following errors
are observed on the console:

  Error sending AMC RPMH requests (-110)
  qcom_rpmh TCS Busy, retrying RPMH message send: addr=0x50000
  qcom_rpmh TCS Busy, retrying RPMH message send: addr=0x50000
  qcom_rpmh TCS Busy, retrying RPMH message send: addr=0x50000
  ...

In this specific case, the above is related to one of the sequencers
being stuck, while client drivers are returning from probe and trying
to disable the currently unused clock and interconnect resources.
Generally we want to keep the multimedia NoC enabled like the rest of
the NoCs, so let's set the keepalive flag on it too.

Fixes: aae57773fbe0 ("interconnect: qcom: sdm845: Split qnodes into their respective NoCs")
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Mike Tipton <mdtipton@codeaurora.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Link: https://lore.kernel.org/r/20201012194034.26944-1-georgi.djakov@linaro.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sdm845.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/sdm845.c b/drivers/interconnect/qcom/sdm845.c
index f6c7b969520d0..86f08c0f4c41b 100644
--- a/drivers/interconnect/qcom/sdm845.c
+++ b/drivers/interconnect/qcom/sdm845.c
@@ -151,7 +151,7 @@ DEFINE_QBCM(bcm_mc0, "MC0", true, &ebi);
 DEFINE_QBCM(bcm_sh0, "SH0", true, &qns_llcc);
 DEFINE_QBCM(bcm_mm0, "MM0", false, &qns_mem_noc_hf);
 DEFINE_QBCM(bcm_sh1, "SH1", false, &qns_apps_io);
-DEFINE_QBCM(bcm_mm1, "MM1", false, &qxm_camnoc_hf0_uncomp, &qxm_camnoc_hf1_uncomp, &qxm_camnoc_sf_uncomp, &qxm_camnoc_hf0, &qxm_camnoc_hf1, &qxm_mdp0, &qxm_mdp1);
+DEFINE_QBCM(bcm_mm1, "MM1", true, &qxm_camnoc_hf0_uncomp, &qxm_camnoc_hf1_uncomp, &qxm_camnoc_sf_uncomp, &qxm_camnoc_hf0, &qxm_camnoc_hf1, &qxm_mdp0, &qxm_mdp1);
 DEFINE_QBCM(bcm_sh2, "SH2", false, &qns_memnoc_snoc);
 DEFINE_QBCM(bcm_mm2, "MM2", false, &qns2_mem_noc);
 DEFINE_QBCM(bcm_sh3, "SH3", false, &acm_tcu);
-- 
2.27.0



