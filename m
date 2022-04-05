Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163E94F2E5C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiDEJDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbiDEIQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9973AD111;
        Tue,  5 Apr 2022 01:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ACB0B81BB7;
        Tue,  5 Apr 2022 08:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C6EC385A5;
        Tue,  5 Apr 2022 08:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145839;
        bh=xFrfaAw0W6wPzfErlhGrafzRHMRpYYTkjh++zOYTdoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btgwtxBGmqMXgD7iID5Xedra67D4IbviHofTHZ+J3LqmGdOh57kMdQhJSov9m3WlS
         ChdSwf6JJA8WPy3DOSYl72kekP8Vn7k9sZxmgCBFXfxVokmB47fNBcjBwzylh+FMWF
         G4da79FLGS8PdggngPSjcGeJXpiuOqTj0dE4zzgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0546/1126] i2c: pasemi: Drop I2C classes from platform driver variant
Date:   Tue,  5 Apr 2022 09:21:33 +0200
Message-Id: <20220405070423.659400652@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 19e138e43a0820bb4dbf8fb5c7691f82e9221f2b ]

Drop I2C device-probing classes from platform variant of the PASemi
controller as it is only used on platforms where I2C devices should
be instantiated in devicetree. (The I2C_CLASS_DEPRECATED flag is not
raised as up to this point no devices relied on the old behavior.)

Fixes: d88ae2932df0 ("i2c: pasemi: Add Apple platform driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Acked-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pasemi-core.c | 1 -
 drivers/i2c/busses/i2c-pasemi-pci.c  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pasemi-core.c b/drivers/i2c/busses/i2c-pasemi-core.c
index 4e161a4089d8..7728c8460dc0 100644
--- a/drivers/i2c/busses/i2c-pasemi-core.c
+++ b/drivers/i2c/busses/i2c-pasemi-core.c
@@ -333,7 +333,6 @@ int pasemi_i2c_common_probe(struct pasemi_smbus *smbus)
 	smbus->adapter.owner = THIS_MODULE;
 	snprintf(smbus->adapter.name, sizeof(smbus->adapter.name),
 		 "PA Semi SMBus adapter (%s)", dev_name(smbus->dev));
-	smbus->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	smbus->adapter.algo = &smbus_algorithm;
 	smbus->adapter.algo_data = smbus;
 
diff --git a/drivers/i2c/busses/i2c-pasemi-pci.c b/drivers/i2c/busses/i2c-pasemi-pci.c
index 1ab1f28744fb..cfc89e04eb94 100644
--- a/drivers/i2c/busses/i2c-pasemi-pci.c
+++ b/drivers/i2c/busses/i2c-pasemi-pci.c
@@ -56,6 +56,7 @@ static int pasemi_smb_pci_probe(struct pci_dev *dev,
 	if (!smbus->ioaddr)
 		return -EBUSY;
 
+	smbus->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	error = pasemi_i2c_common_probe(smbus);
 	if (error)
 		return error;
-- 
2.34.1



