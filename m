Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EB361493B
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKALfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiKALez (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433521CB13;
        Tue,  1 Nov 2022 04:31:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BD8B81CCC;
        Tue,  1 Nov 2022 11:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B248C433B5;
        Tue,  1 Nov 2022 11:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302226;
        bh=bCGwGWfkxqFfeUoRZcBIrTw7GLMqslGvE9WpxKhxs5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3jUIb6wqnEcpIaTmvD5s8vFcGgszbkD4A17paVsR/KxXz0EV4DI9O25K++C14cCW
         l2Wvovfmv/ndL1QVCa2jmleL9TXeSRC2g8+GssrMNhzUi0WY01GSmImnH3diJFZIOe
         K4mt3x0dgPbRfjNRtqo3reBD6jTa2wf/GbOMwyI2DvAHav3ZNmov7FKBYKzEJ3S8Qj
         e1Y9o7Nb8hDDtpLOROzWQiFGQ7vADAnZHh5S0txdYAbhRMI3pryavA0ci3O3YCYOTW
         0S57np1CdoGR++1FTMr8WcOcA0+Pt/j5hnuQ6vUm32ooE6RZhvHIj0RolPsR0xtsbV
         mudAUo3DAOmqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/14] media: dvb-frontends/drxk: initialize err to 0
Date:   Tue,  1 Nov 2022 07:30:01 -0400
Message-Id: <20221101113012.800271-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113012.800271-1-sashal@kernel.org>
References: <20221101113012.800271-1-sashal@kernel.org>
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
index a57470bf71bf..2134e25096aa 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6672,7 +6672,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
-- 
2.35.1

