Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6426E6578CD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiL1Oya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiL1OyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148732E6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82471CE134E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFEDC433D2;
        Wed, 28 Dec 2022 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239255;
        bh=yyBeemMh7SHz2UU8auWCUtpr1CQoYBH0weA+nhdRoXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6NUk/z+KOmAgkm9ICWR/aZ7H2c1BiYZKBARJGTRHjk3anaDRPsSyq0NjC8J7wkpa
         Uw1RNAmhurQHl6Q+vbQLmVwkJG07+qe/NjPSa2ECA+CAPgVEhJ9aiiQhmjWBCcxnj/
         jQwu3fARIQ09AP49P5gGsZ6Mm81U2+ehHta9p5T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/731] Input: joystick - fix Kconfig warning for JOYSTICK_ADC
Date:   Wed, 28 Dec 2022 15:34:54 +0100
Message-Id: <20221228144301.980734260@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6100a19c4fcfe154dd32f8a8ef4e8c0b1f607c75 ]

Fix a Kconfig warning for JOYSTICK_ADC by also selecting
IIO_BUFFER.

WARNING: unmet direct dependencies detected for IIO_BUFFER_CB
  Depends on [n]: IIO [=y] && IIO_BUFFER [=n]
  Selected by [y]:
  - JOYSTICK_ADC [=y] && INPUT [=y] && INPUT_JOYSTICK [=y] && IIO [=y]

Fixes: 2c2b364fddd5 ("Input: joystick - add ADC attached joystick driver.")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20221104201238.31628-1-rdunlap@infradead.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 3b23078bc7b5..db4135bbd279 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -46,6 +46,7 @@ config JOYSTICK_A3D
 config JOYSTICK_ADC
 	tristate "Simple joystick connected over ADC"
 	depends on IIO
+	select IIO_BUFFER
 	select IIO_BUFFER_CB
 	help
 	  Say Y here if you have a simple joystick connected over ADC.
-- 
2.35.1



