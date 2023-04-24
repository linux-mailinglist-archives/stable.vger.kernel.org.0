Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774BE6ECF51
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDXNjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjDXNje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:39:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0EC93C9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51DD6245D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3EFC4339E;
        Mon, 24 Apr 2023 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343545;
        bh=9sQTzdzQIRmdNZ+niKlHkq4sOuPXASqIJ/yStmcsx48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jx+8t0Jmvf1YA1imUAZHaoyf6Nh03bY0fAb5sd+b4qULZusbtzyBfLhUWWLnU31zb
         lNAmZh34Jd5w7mPw7Ee7zqWLFpnH0EXRTy8384QOEhdGQRntU7nh/qD2l7raalEXiY
         0nAPwFC11iXLE38Ih8ccbCPuuhWuMgBaW8r+zdRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonathan Denose <jdenose@google.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/29] Input: i8042 - add quirk for Fujitsu Lifebook A574/H
Date:   Mon, 24 Apr 2023 15:18:36 +0200
Message-Id: <20230424131121.457556572@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Denose <jdenose@chromium.org>

[ Upstream commit f5bad62f9107b701a6def7cac1f5f65862219b83 ]

Fujitsu Lifebook A574/H requires the nomux option to properly
probe the touchpad, especially when waking from sleep.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230303152623.45859-1-jdenose@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index b2ab20c16cc77..da2bf8259330e 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -605,6 +605,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	{
+		/* Fujitsu Lifebook A574/H */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMVA0501PZ"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Gigabyte M912 */
 		.matches = {
-- 
2.39.2



