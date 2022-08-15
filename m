Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6486359499B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244066AbiHOXIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345355AbiHOXEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE03C1403B7;
        Mon, 15 Aug 2022 12:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F6FAB8114A;
        Mon, 15 Aug 2022 19:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62DFC433D6;
        Mon, 15 Aug 2022 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593514;
        bh=UVGljkG5EKmxr9mq0ibBIU6gvDealofYMdBg/P96AB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4kTmEtf0PB1L1hNuv5Y7LZoATXRXjWE/Jxorr+1zlIJjbT8tZejj7wtWN27upV2s
         Q+gJbPNmu4qggkONroSpBEZc3ipO7E9aOvH/HzyXvndIJm7NgutaBC6BlBA0ZqFFDc
         DaBankDTuG0p6chkaDtRdWT+AJiJX/ocnOFa37T4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0281/1157] soc: qcom: Make QCOM_RPMPD depend on PM
Date:   Mon, 15 Aug 2022 19:53:57 +0200
Message-Id: <20220815180450.841615185@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit a6232f2aa99ce470799992e99e0012945bb5308f ]

QCOM_RPMPD requires PM_GENERIC_DOMAINS/_OF, which in turns requires
CONFIG_PM. I forgot about the latter in my earlier patch (it's still
in -next as of the time of committing, hence no Fixes: tag). Fix it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220707212158.32684-1-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index e718b8735444..4472fb22ba04 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -129,6 +129,7 @@ config QCOM_RPMHPD
 
 config QCOM_RPMPD
 	tristate "Qualcomm RPM Power domain driver"
+	depends on PM
 	depends on QCOM_SMD_RPM
 	help
 	  QCOM RPM Power domain driver to support power-domains with
-- 
2.35.1



