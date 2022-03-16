Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0414DB247
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351439AbiCPOPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356134AbiCPOPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D630A1C93A;
        Wed, 16 Mar 2022 07:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CEA161240;
        Wed, 16 Mar 2022 14:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9BCC340E9;
        Wed, 16 Mar 2022 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440056;
        bh=cmOGP0m+pkZjBJC0zI+CTqKgqlFbBneVJbZRza4TXBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5hfQwxf33hqWYzZPW4VtGu+gPVX3PUCtwmVOuKvJ3tPXWh7ENeR3pvBJYRPE+PT/
         vgnr9uw+qzudOkUrgEWZ+yhMCE/RXvorqT+g2IibbVh2fKFulZhXlaS3aufP55fEp4
         ynZ9yr1A6WCPLivwEps5G3JGLRouq6Bx+7m3v71mDf6x0Pd/+zVWfI5v6LVljUGJ9/
         PempAwz13AcjQDliUBuv9Vem3htUGyIlSxC6NJBLm2vHKinCQyKJWigh4aAINfn4It
         y93548VLhjobvodibEMhTjimiBPCLWYIce2Tm4b36/6gY5Pmdhaavo4urZ6LB5j6Mv
         af99vvaJ+MOjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Michael=20H=C3=BCbner?= <michaelh.95@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 03/13] HID: Add support for open wheel and no attachment to T300
Date:   Wed, 16 Mar 2022 10:13:44 -0400
Message-Id: <20220316141354.247750-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141354.247750-1-sashal@kernel.org>
References: <20220316141354.247750-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hübner <michaelh.95@t-online.de>

[ Upstream commit 0a5a587501b54e8c6d86960b047d4491fd40dcf2 ]

Different add ons to the wheel base report different models. Having
no wheel mounted to the base and using the open wheel attachment is
added here.

Signed-off-by: Michael Hübner <michaelh.95@t-online.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 03b935ff02d5..a4e20f9e598b 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -64,7 +64,9 @@ struct tm_wheel_info {
  */
 static const struct tm_wheel_info tm_wheels_infos[] = {
 	{0x0306, 0x0006, "Thrustmaster T150RS"},
+	{0x0200, 0x0005, "Thrustmaster T300RS (Missing Attachment)"},
 	{0x0206, 0x0005, "Thrustmaster T300RS"},
+	{0x0209, 0x0005, "Thrustmaster T300RS (Open Wheel Attachment)"},
 	{0x0204, 0x0005, "Thrustmaster T300 Ferrari Alcantara Edition"},
 	{0x0002, 0x0002, "Thrustmaster T500RS"}
 	//{0x0407, 0x0001, "Thrustmaster TMX"}
-- 
2.34.1

