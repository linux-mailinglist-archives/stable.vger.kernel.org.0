Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE864CF751
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiCGJpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiCGJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C767D6D39D;
        Mon,  7 Mar 2022 01:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3086AB810C3;
        Mon,  7 Mar 2022 09:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DD1C340E9;
        Mon,  7 Mar 2022 09:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645645;
        bh=Ob/qNd3VHsSqymcYuL8emr4oc6bdPm38KbcwkhBrKsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3NoA6g06B50h/rwz6dAFXPaGzI/HW7NaERZqZiqNVSmBwvfo0C2Q8q7R82F4bgb9
         cQXStFifILJeHyNVmnACXm22nIVeekl0SsYGywNKE6zRppn+AlLy6AwlMS24c+oeZA
         996Jmgtm16dH36mfl/DCEwKmH0V3YSHT56XyVqrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        anton ivanov <anton.ivanov@cambridgegreys.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 097/105] Input: samsung-keypad - properly state IOMEM dependency
Date:   Mon,  7 Mar 2022 10:19:40 +0100
Message-Id: <20220307091646.906230487@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

commit ba115adf61b36b8c167126425a62b0efc23f72c0 upstream.

Make the samsung-keypad driver explicitly depend on CONFIG_HAS_IOMEM, as it
calls devm_ioremap(). This prevents compile errors in some configs (e.g,
allyesconfig/randconfig under UML):

/usr/bin/ld: drivers/input/keyboard/samsung-keypad.o: in function `samsung_keypad_probe':
samsung-keypad.c:(.text+0xc60): undefined reference to `devm_ioremap'

Signed-off-by: David Gow <davidgow@google.com>
Acked-by: anton ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20220225041727.1902850-1-davidgow@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -556,7 +556,7 @@ config KEYBOARD_PMIC8XXX
 
 config KEYBOARD_SAMSUNG
 	tristate "Samsung keypad support"
-	depends on HAVE_CLK
+	depends on HAS_IOMEM && HAVE_CLK
 	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the keypad on your Samsung mobile


