Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30A505320
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbiDRMzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbiDRMzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFBD20F4F;
        Mon, 18 Apr 2022 05:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4924F61014;
        Mon, 18 Apr 2022 12:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F71C385A1;
        Mon, 18 Apr 2022 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285346;
        bh=tCeOiBqGrp+xpXOvWNxrImRBzOezrzh5RKwZ8svsIrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYMyyx21CatBmqeUfDodF+W4HhJCOrgvw+2aNqysI8w5RDyizP2yi3e2kYXKCGF16
         kHqSB7zr8ifwalIVd2wIqopAH1JPII5OvIeQUSGnN+9GqQyJkdPa1gnWZkt47u9UZD
         qDA3QO9ulZWbYNhAQ4muLyva+4LqS5hZtrO3RjD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 180/189] net: ipa: fix a build dependency
Date:   Mon, 18 Apr 2022 14:13:20 +0200
Message-Id: <20220418121208.223621522@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

commit caef14b7530c065fb85d54492768fa48fdb5093e upstream.

An IPA build problem arose in the linux-next tree the other day.
The problem is that a recent commit adds a new dependency on some
code, and the Kconfig file for IPA doesn't reflect that dependency.
As a result, some configurations can fail to build (particularly
when COMPILE_TEST is enabled).

The recent patch adds calls to qmp_get(), qmp_put(), and qmp_send(),
and those are built based on the QCOM_AOSS_QMP config option.  If
that symbol is not defined, stubs are defined, so we just need to
ensure QCOM_AOSS_QMP is compatible with QCOM_IPA, or it's not
defined.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 34a081761e4e3 ("net: ipa: request IPA register values be retained")
Signed-off-by: Alex Elder <elder@linaro.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -4,6 +4,7 @@ config QCOM_IPA
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS


