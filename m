Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8357D61499A
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiKALkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiKALih (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:38:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92BF1E3E9;
        Tue,  1 Nov 2022 04:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13417615FE;
        Tue,  1 Nov 2022 11:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82E7C433D7;
        Tue,  1 Nov 2022 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302312;
        bh=pgEpeLqWWA/iYrLgMSS01/VSurWQ4R6k9M+CT2jmfRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4xiX/oojOLK+pU5WbC3ebtg80NqHWzOtlh+L478i/LYL48TV5rcGp98EbzBwfXQe
         cna7o4fn+QKjF1GZQrdMkzU23pIhW+BTuUjDv7QOCKxXz4Zlzdloo56r6Uq7m/HY/0
         a/UhBIxdrhN485FxenxMnOaI5XDPg2OkegtL9TgAL0M7xeKWaQgIZSZQqF1tO40NDE
         LCXnvfYRf0oMN7TZwChTB+oZL9DhBde8uz5aYB7SRckVv+LtOblSI6gCLbwM2gdjly
         TjKuJ8FJgCcqbxYI8OnMQ9+SErEIqfPYUEvwLPFz9jem3QKr2XGGi167A+Po/8OpMh
         owS2V8O4Uvpqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] media: dvb-frontends/drxk: initialize err to 0
Date:   Tue,  1 Nov 2022 07:31:44 -0400
Message-Id: <20221101113147.801048-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113147.801048-1-sashal@kernel.org>
References: <20221101113147.801048-1-sashal@kernel.org>
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
index c595adc61c6f..f6cf1b0b992c 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6697,7 +6697,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
-- 
2.35.1

