Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA0B4CFA5B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbiCGKQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241305AbiCGKKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE7929CAC;
        Mon,  7 Mar 2022 01:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D1A60A25;
        Mon,  7 Mar 2022 09:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7BAC340F3;
        Mon,  7 Mar 2022 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646752;
        bh=FjR30AB8M1wluAjKILJJaXCGejpbEBNh6lLDeYPU04c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=te9weEX9zYqeGTrWbD6zTpCYOKqxi2eF3rXhKMrSUkXN2tQIt4TXnxpBrNER8htd0
         d81NJrZ+0TtoGKlPyuQ8u5vghpv+7GMHJJdape8lKGZFM073vygRlu144Tyy15a1O5
         5Ig9uLyYZRZD8WCreaJ4QbD5gdxvBingYo49Xx5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 082/186] net: ipa: add an interconnect dependency
Date:   Mon,  7 Mar 2022 10:18:40 +0100
Message-Id: <20220307091656.380149513@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit 1dba41c9d2e2dc94b543394974f63d55aa195bfe upstream.

In order to function, the IPA driver very clearly requires the
interconnect framework to be enabled in the kernel configuration.
State that dependency in the Kconfig file.

This became a problem when CONFIG_COMPILE_TEST support was added.
Non-Qualcomm platforms won't necessarily enable CONFIG_INTERCONNECT.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 38a4066f593c5 ("net: ipa: support COMPILE_TEST")
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20220301113440.257916-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -2,6 +2,7 @@ config QCOM_IPA
 	tristate "Qualcomm IPA support"
 	depends on NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
+	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select QCOM_MDT_LOADER if ARCH_QCOM


