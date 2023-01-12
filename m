Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E7F66741E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbjALOCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjALOCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F364517D6
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A08A1B81E66
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D0CC433D2;
        Thu, 12 Jan 2023 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532160;
        bh=WNXq4fm9j94kwJshKpNLDIHXQugP0XchznHGWUMzJ9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmaJqUlhectPLHFkegAJoM3tN0ZHVuARs9Eppiduc7cOnMny9NNuuBKMrtmVt7JcF
         DzjDf6trcCv/5XJ5Qmc5d+x+7t3IQTQCGaVA1IWGlmdTg1w3cpFMalxn0ShkiYNJoW
         5Sm1h9xkeFuBOhxDXQjQrcewssi7LSnABjlmw26I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/783] tpm/tpm_crb: Fix error message in __crb_relinquish_locality()
Date:   Thu, 12 Jan 2023 14:45:58 +0100
Message-Id: <20230112135526.087286336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit f5264068071964b56dc02c9dab3d11574aaca6ff ]

The error message in __crb_relinquish_locality() mentions requestAccess
instead of Relinquish. Fix it.

Fixes: 888d867df441 ("tpm: cmd_ready command can be issued only after granting locality")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_crb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index a9dcf31eadd2..35c5227f3a88 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -252,7 +252,7 @@ static int __crb_relinquish_locality(struct device *dev,
 	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
 	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state, mask, value,
 				 TPM2_TIMEOUT_C)) {
-		dev_warn(dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
+		dev_warn(dev, "TPM_LOC_STATE_x.Relinquish timed out\n");
 		return -ETIME;
 	}
 
-- 
2.35.1



