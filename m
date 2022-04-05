Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1064F2786
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiDEIHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbiDEH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38C94092D;
        Tue,  5 Apr 2022 00:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E8C36167D;
        Tue,  5 Apr 2022 07:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B008C340EE;
        Tue,  5 Apr 2022 07:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145331;
        bh=VQHR5ZlF7JanqFu+p1ZNTUk2Qwci10zOfKht+9wZfoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaTymCO0phczVcLa1S1cvjoDa77v61+nfWCFgHFJD+8cyvtp7aNGtjDYWhtPNFlX7
         dkSU7xJzLbcFOwadrHhcWH80AMW7PM/QALoQyaMD+jvW7nFtsDy8mAU5urCmGu6Sew
         ktfsqrka287YbjxX/BI17etUUUpHehksydEfvMYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0366/1126] media: hantro: sunxi: Fix VP9 steps
Date:   Tue,  5 Apr 2022 09:18:33 +0200
Message-Id: <20220405070418.370365366@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 17e83a0a1e134401616120b6976f65234e7ccc45 ]

It turns out that postproc on Allwinner H6 needs width and height to be
multiple of 32.

Fixes: 86790a4fdf4b ("media: hantro: Add support for Allwinner H6")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/sunxi_vpu_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/hantro/sunxi_vpu_hw.c b/drivers/staging/media/hantro/sunxi_vpu_hw.c
index 90633406c4eb..c0edd5856a0c 100644
--- a/drivers/staging/media/hantro/sunxi_vpu_hw.c
+++ b/drivers/staging/media/hantro/sunxi_vpu_hw.c
@@ -29,10 +29,10 @@ static const struct hantro_fmt sunxi_vpu_dec_fmts[] = {
 		.frmsize = {
 			.min_width = 48,
 			.max_width = 3840,
-			.step_width = MB_DIM,
+			.step_width = 32,
 			.min_height = 48,
 			.max_height = 2160,
-			.step_height = MB_DIM,
+			.step_height = 32,
 		},
 	},
 };
-- 
2.34.1



