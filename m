Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3F614909
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiKALbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiKALbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:31:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A228FC9;
        Tue,  1 Nov 2022 04:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2751D615DD;
        Tue,  1 Nov 2022 11:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD779C433D6;
        Tue,  1 Nov 2022 11:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302174;
        bh=3pi6VpVbHUr/+LFC7PGNGuXnVVJseL7deo424ek7vhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9FkNcFD0myKMisbRbMuAw01hkTK+GxXH70xJE9G/uRbEU3IZpYp1otJex1ggwDen
         L6OoojhyPZR12uo0F1uR9epfoucwGwPZwuj91Aod297wbA1rSly8hyLbneMReDOcaY
         jMgzK7bIsJpHh0rFin+77SzJMCyt2UeTE47jwYJe3xx954vTcUBFI0xSF4R2JFPJes
         dHIcYbTzCOERN3VYwHrCZg38rwur4Eu3KEg3joNY0nSYrE795E1RwgIJoee7yZOJjg
         4oZQGe0JSmVU64Nk0ja6ZsrcFMFGRh77E7FknLad4kmbJXePVcDb5OKQ5GRBURZyBU
         a27pEUJ0Wu1CA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/19] media: dvb-frontends/drxk: initialize err to 0
Date:   Tue,  1 Nov 2022 07:29:07 -0400
Message-Id: <20221101112919.799868-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 20694e96ca089ce6693c2348f8f628ee621e4e74 ]

Fix a compiler warning:

drivers/media/dvb-frontends/drxk_hard.c: In function 'drxk_read_ucblocks':
drivers/media/dvb-frontends/drxk_hard.c:6673:21: warning: 'err' may be used uninitialized [-Wmaybe-uninitialized]
 6673 |         *ucblocks = (u32) err;
      |                     ^~~~~~~~~
drivers/media/dvb-frontends/drxk_hard.c:6663:13: note: 'err' was declared here
 6663 |         u16 err;
      |             ^~~

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/drxk_hard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index d7fc2595f15b..efe92eef67db 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6673,7 +6673,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
-- 
2.35.1

