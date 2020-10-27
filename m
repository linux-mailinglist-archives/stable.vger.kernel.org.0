Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7129B6A5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797114AbgJ0PXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797471AbgJ0PXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E86A520657;
        Tue, 27 Oct 2020 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812225;
        bh=EvSr6iME9Pn8juqN3utg0mh0k+DBER0BhSes0lO4a5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+s6fjFYZ585gW2DOreYFLcdRpQhRb74MQjj0H5PIPWL5VvxwLZ6s2PsMFBP7sIKB
         DWPl1iOkWF8QzctZ70F4p+cfc+eNwUC2ZDWZBw5b/kctMomfnsBEADQU6qiIupFbc8
         6ZYV8qsWj0ib0Rku2UM4DV0aVIKGGWSusCvketYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 135/757] media: staging/intel-ipu3: css: Correctly reset some memory
Date:   Tue, 27 Oct 2020 14:46:25 +0100
Message-Id: <20201027135456.929239508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 08913a8e458e03f886a1a1154a6501fcb9344c39 ]

The intent here is to reset the whole 'scaler_coeffs_luma' array, not just
the first element.

Fixes: e11110a5b744 ("media: staging/intel-ipu3: css: Compute and program ccs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-css-params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css-params.c b/drivers/staging/media/ipu3/ipu3-css-params.c
index fbd53d7c097cd..e9d6bd9e9332a 100644
--- a/drivers/staging/media/ipu3/ipu3-css-params.c
+++ b/drivers/staging/media/ipu3/ipu3-css-params.c
@@ -159,7 +159,7 @@ imgu_css_scaler_calc(u32 input_width, u32 input_height, u32 target_width,
 
 	memset(&cfg->scaler_coeffs_chroma, 0,
 	       sizeof(cfg->scaler_coeffs_chroma));
-	memset(&cfg->scaler_coeffs_luma, 0, sizeof(*cfg->scaler_coeffs_luma));
+	memset(&cfg->scaler_coeffs_luma, 0, sizeof(cfg->scaler_coeffs_luma));
 	do {
 		phase_step_correction++;
 
-- 
2.25.1



