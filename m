Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150B952643A
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380738AbiEMO2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380950AbiEMO1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:27:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D16951E5B;
        Fri, 13 May 2022 07:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF62B82C9D;
        Fri, 13 May 2022 14:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D9EC34100;
        Fri, 13 May 2022 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452046;
        bh=YlDEhlXBGYtbdJUL3Q03K95zPl+30yat+t0Bqzl5I2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4Mrgb1CWrj0dhvRk4GSXKILfzZe/FwVKXl2HqFkqT4S2ofZ9zrsarr0X2hQ1daNQ
         S4noEaRJdcaCN7H4xQWgOojv2kd6w5cALTarO1g3QtUlXzf1YioHUWPXBibmmMpIwr
         /W1TS8l3iIHQe6/U2ric5tifPxh7i8Rms4QJS+3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 02/10] regulator: consumer: Add missing stubs to regulator/consumer.h
Date:   Fri, 13 May 2022 16:23:46 +0200
Message-Id: <20220513142228.377014996@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 51dfb6ca3728bd0a0a3c23776a12d2a15a1d2457 upstream.

Add missing stubs to regulator/consumer.h in order to fix COMPILE_TEST
of the kernel. In particular this should fix compile-testing of OPP core
because of a missing stub for regulator_sync_voltage().

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210120205844.12658-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Bjørn Mork <bjorn@mork.no>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/regulator/consumer.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -332,6 +332,12 @@ regulator_get_exclusive(struct device *d
 }
 
 static inline struct regulator *__must_check
+devm_regulator_get_exclusive(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct regulator *__must_check
 regulator_get_optional(struct device *dev, const char *id)
 {
 	return ERR_PTR(-ENODEV);
@@ -486,6 +492,11 @@ static inline int regulator_get_voltage(
 	return -EINVAL;
 }
 
+static inline int regulator_sync_voltage(struct regulator *regulator)
+{
+	return -EINVAL;
+}
+
 static inline int regulator_is_supported_voltage(struct regulator *regulator,
 				   int min_uV, int max_uV)
 {
@@ -578,6 +589,25 @@ static inline int devm_regulator_unregis
 	return 0;
 }
 
+static inline int regulator_suspend_enable(struct regulator_dev *rdev,
+					   suspend_state_t state)
+{
+	return -EINVAL;
+}
+
+static inline int regulator_suspend_disable(struct regulator_dev *rdev,
+					    suspend_state_t state)
+{
+	return -EINVAL;
+}
+
+static inline int regulator_set_suspend_voltage(struct regulator *regulator,
+						int min_uV, int max_uV,
+						suspend_state_t state)
+{
+	return -EINVAL;
+}
+
 static inline void *regulator_get_drvdata(struct regulator *regulator)
 {
 	return NULL;


