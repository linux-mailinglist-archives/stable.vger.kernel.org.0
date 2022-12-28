Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884C4657A6B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiL1PLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiL1PKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:10:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F279312D2F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AB58B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3135C433EF;
        Wed, 28 Dec 2022 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240248;
        bh=NRPKHk3u4TgHIlrVRVUc/Qx93ttIyR+OcxlN2OrSFD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Opp/3HuPcZvUrs2NY1XxCxp6dQu6fAaHZTUHxjMg8DCfsxS9mhwk/TQwLYKNhq1mx
         a9CtKqk3gLb7zBK6DnDBLT8eJ38EpGlzEltxnRj8oBGAMBHHta8NL1bm2XFDk3RxaD
         19+/e04rm9o6AZmfg35gm6Lc0yD8vcInST+fzTs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eddie James <eajames@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0100/1146] tpm: tis_i2c: Fix sanity check interrupt enable mask
Date:   Wed, 28 Dec 2022 15:27:19 +0100
Message-Id: <20221228144332.859637635@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 561d6ef75628db9cce433e573aa3cdb6b3bba903 ]

The sanity check mask for TPM_INT_ENABLE register was off by 8 bits,
resulting in failure to probe if the TPM_INT_ENABLE register was a
valid value.

Fixes: bbc23a07b072 ("tpm: Add tpm_tis_i2c backend for tpm_tis_core")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_i2c.c b/drivers/char/tpm/tpm_tis_i2c.c
index 0692510dfcab..635a69dfcbbd 100644
--- a/drivers/char/tpm/tpm_tis_i2c.c
+++ b/drivers/char/tpm/tpm_tis_i2c.c
@@ -49,7 +49,7 @@
 
 /* Masks with bits that must be read zero */
 #define TPM_ACCESS_READ_ZERO 0x48
-#define TPM_INT_ENABLE_ZERO 0x7FFFFF6
+#define TPM_INT_ENABLE_ZERO 0x7FFFFF60
 #define TPM_STS_READ_ZERO 0x23
 #define TPM_INTF_CAPABILITY_ZERO 0x0FFFF000
 #define TPM_I2C_INTERFACE_CAPABILITY_ZERO 0x80000000
-- 
2.35.1



