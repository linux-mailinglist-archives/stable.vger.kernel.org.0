Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9C417FC98
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgCJNBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbgCJNBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3081A208E4;
        Tue, 10 Mar 2020 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845309;
        bh=r066dt6Ij9pfjakkwrpGOU10oacfiQWN2fwGMx1QBds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1nfBawjzJcTEpEvn/bh3SmgmKqxutNA3/0NXEqf4h/V4EoNQgiqkY37PBi9l7rAv
         Q3YBeCYqRceaW4I264QS6/+GBNSL98iR2BCa1LQdodraACAQtUR5KdclbSsuM+SBz5
         dFYz6b1Jzy4bPIbJu0yGw8fXYUnPPPaqCqS9KTxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 137/189] ASoC: Intel: Skylake: Fix available clock counter incrementation
Date:   Tue, 10 Mar 2020 13:39:34 +0100
Message-Id: <20200310123653.662843187@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit 8308a09e87d2cb51adb186dc7d5a5c1913fb0758 upstream.

Incrementation of avail_clk_cnt was incorrectly moved to error path. Put
it back to success path.

Fixes: 6ee927f2f01466 ('ASoC: Intel: Skylake: Fix NULL ptr dereference when unloading clk dev')
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200224125202.13784-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/skylake/skl-ssp-clk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/skylake/skl-ssp-clk.c
+++ b/sound/soc/intel/skylake/skl-ssp-clk.c
@@ -384,9 +384,11 @@ static int skl_clk_dev_probe(struct plat
 				&clks[i], clk_pdata, i);
 
 		if (IS_ERR(data->clk[data->avail_clk_cnt])) {
-			ret = PTR_ERR(data->clk[data->avail_clk_cnt++]);
+			ret = PTR_ERR(data->clk[data->avail_clk_cnt]);
 			goto err_unreg_skl_clk;
 		}
+
+		data->avail_clk_cnt++;
 	}
 
 	platform_set_drvdata(pdev, data);


