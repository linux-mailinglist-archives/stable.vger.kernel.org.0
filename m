Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8B062134D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiKHNtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiKHNs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1008F7664
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:48:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D698E6130A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6064C433C1;
        Tue,  8 Nov 2022 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915337;
        bh=6ImvMZXhEhgyWhlAeBArjonfP1CNJg7qSdSHO26xB90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwQFEgajhoGvCJCRgXQXooSDpgUO0NgguR/kO/GgiZjIe1YY+1K2+cEhb0PIIJL8i
         v/tLKS2uFdraXJrg2X9D4NY6juajVV6LkO6ZJDgKF7jKx/74NHm3rYjHGUDWr3r+T+
         U42b7tfhRw5XodRMZzbYptI4PXhjYn7nu8ITdj0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/74] media: dvb-frontends/drxk: initialize err to 0
Date:   Tue,  8 Nov 2022 14:39:00 +0100
Message-Id: <20221108133335.041652995@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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
index 0a4875b391d9..2dccc9d0be12 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6684,7 +6684,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
-- 
2.35.1



