Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69D0676FE7
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjAVP03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjAVP02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A8A22DC1
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67FA6B80B1E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B0C433D2;
        Sun, 22 Jan 2023 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401185;
        bh=FB4KCU5GV+C2KFU1OZ9OPHHkE7B56aHwxhF55RSkCTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2i4XSknj/IbtQrnLOtYSb6fZekBitUWil3B6xPSTZ6GrgxtMFmGmaYK02j6Xj6CEM
         mmxXuS0NzAicnfJX4qZS8JeIPpUpAFGedeMkWLhqR0flYxJxwURaeYtHISiOSGxFZx
         7QTadnjvG7ZMak6a1LhmJ/GZVFD90EgU4K+lAwNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Melissa Wen <mwen@igalia.com>,
        Joshua Ashton <joshua@froggi.es>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 143/193] drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix
Date:   Sun, 22 Jan 2023 16:04:32 +0100
Message-Id: <20230122150252.922640897@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Ashton <joshua@froggi.es>

commit 973a9c810c785ac270a6d50d8cf862b0c1643a10 upstream.

The YCC conversion matrix for RGB -> COLOR_SPACE_YCBCR2020_TYPE is
missing the values for the fourth column of the matrix.

The fourth column of the matrix is essentially just a value that is
added given that the color is 3 components in size.
These values are needed to bias the chroma from the [-1, 1] -> [0, 1]
range.

This fixes color being very green when using Gamescope HDR on HDMI
output which prefers YCC 4:4:4.

Fixes: 40df2f809e8f ("drm/amd/display: color space ycbcr709 support")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -90,8 +90,8 @@ static const struct out_csc_color_matrix
 		{ 0xE00, 0xF349, 0xFEB7, 0x1000, 0x6CE, 0x16E3,
 				0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} },
 	{ COLOR_SPACE_YCBCR2020_TYPE,
-		{ 0x1000, 0xF149, 0xFEB7, 0x0000, 0x0868, 0x15B2,
-				0x01E6, 0x0000, 0xFB88, 0xF478, 0x1000, 0x0000} },
+		{ 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
+				0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
 	{ COLOR_SPACE_YCBCR709_BLACK_TYPE,
 		{ 0x0000, 0x0000, 0x0000, 0x1000, 0x0000, 0x0000,
 				0x0000, 0x0200, 0x0000, 0x0000, 0x0000, 0x1000} },


