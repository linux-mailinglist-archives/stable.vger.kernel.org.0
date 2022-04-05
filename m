Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0294F272C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiDEIF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiDEIAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D961B6;
        Tue,  5 Apr 2022 00:58:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45320B81B7F;
        Tue,  5 Apr 2022 07:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A579CC340EE;
        Tue,  5 Apr 2022 07:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145485;
        bh=gUqY2/CEJRoMrBNYFSwsJeqcvHhhqZyD6BvwF1bUZOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWJl+ROiZ5tp657nYhACUNbO/5fBS+B7A/Q+OFwuqUIfssMjv+aFyMIA1v/AnKNUa
         BSAlVDCmziGEmnU0DA71yrVO/aUyo32hFb700IBStU1iv7efbha1wcMF3Tq4BO7SvY
         woApmNO8F5D326xLJpy7SHQwlXDYLELuMMFSYFZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Michel Hautbois <jeanmichel.hautbois@ideasonboard.com>,
        Daniel Scally <djrscally@gmail.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0385/1126] media: i2c: Fix pixel array positions in ov8865
Date:   Tue,  5 Apr 2022 09:18:52 +0200
Message-Id: <20220405070418.927440614@linuxfoundation.org>
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

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit 3d1e4228c9dd5c945a5cb621749f358766ee5777 ]

The ov8865's datasheet gives the pixel array as 3296x2528, and the
active portion as the centre 3264x2448. This makes for a top offset
of 40 and a left offset of 16, not 32 and 80.

Fixes: acd25e220921 ("media: i2c: Add .get_selection() support to ov8865")

Reported-by: Jean-Michel Hautbois <jeanmichel.hautbois@ideasonboard.com>
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index d9d016cfa9ac..e0dd0f4849a7 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -457,8 +457,8 @@
 
 #define OV8865_NATIVE_WIDTH			3296
 #define OV8865_NATIVE_HEIGHT			2528
-#define OV8865_ACTIVE_START_TOP			32
-#define OV8865_ACTIVE_START_LEFT		80
+#define OV8865_ACTIVE_START_LEFT		16
+#define OV8865_ACTIVE_START_TOP			40
 #define OV8865_ACTIVE_WIDTH			3264
 #define OV8865_ACTIVE_HEIGHT			2448
 
-- 
2.34.1



