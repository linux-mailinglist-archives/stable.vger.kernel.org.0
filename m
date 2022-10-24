Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B1160AF9F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJXPx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiJXPxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2CC74354;
        Mon, 24 Oct 2022 07:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD769B819ED;
        Mon, 24 Oct 2022 12:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A83C433C1;
        Mon, 24 Oct 2022 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615774;
        bh=8mnCUW+Rps6TFUAaxrP76MpD1G7Y2ngePtLG5pxuT3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2Ky1isxnnfeP+pJDo0ZsGOsmrANxQA5rSBF/B6B88Fjwjo6L5LUrfD57diDNYj4u
         EMexQ5SAUt429PjPgH3VazQepDZ8zAsr9VgZfzSiPf/hXsTuntkzdf5P6GJAIDDAja
         KLJo/USD/yPzQ26hS6Ms/E44JN9YEkggt11gS5a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 378/530] crypto: qat - fix default value of WDT timer
Date:   Mon, 24 Oct 2022 13:32:02 +0200
Message-Id: <20221024113102.150285867@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>

[ Upstream commit cc40b04c08400d86d2d6ea0159e0617e717f729c ]

The QAT HW supports an hardware mechanism to detect an accelerator hang.
The reporting of a hang occurs after a watchdog timer (WDT) expires.

The value of the WDT set previously was too small and was causing false
positives.
Change the default value of the WDT to 0x7000000ULL to avoid this.

Fixes: 1c4d9d5bbb5a ("crypto: qat - enable detection of accelerators hang")
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
index b8fca1ff7aab..0b7086cae00b 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
@@ -99,7 +99,7 @@ do { \
  * Timeout is in cycles. Clock speed may vary across products but this
  * value should be a few milli-seconds.
  */
-#define ADF_SSM_WDT_DEFAULT_VALUE	0x200000
+#define ADF_SSM_WDT_DEFAULT_VALUE	0x7000000ULL
 #define ADF_SSM_WDT_PKE_DEFAULT_VALUE	0x8000000
 #define ADF_SSMWDTL_OFFSET		0x54
 #define ADF_SSMWDTH_OFFSET		0x5C
-- 
2.35.1



