Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC5694942
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBMO5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBMO5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:57:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2D01CAF7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EB53B8125B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77440C4339C;
        Mon, 13 Feb 2023 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300222;
        bh=buUfb9RWvWaEncIVXLdJpF3W2yBwRDIlMckinZaUBic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTIbCvYKb2L7zrv9CAfeqZ0eB8bFq44iWw+4ZZs1Pb9R/eBXKkI8MEn33pOeUf2la
         mhT6BGjSILDp/P63HWsqO9/E4SCiQai5kEIMnXhBDl64KZNDV+ptjlMERuxTSvZrf3
         8dzTxnnJNoyGLpVKoKLhjeCgemuEQck8DgSzHnXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xaver Hugl <xaver.hugl@gmail.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Melissa Wen <mwen@igalia.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 111/114] drm/amd/display: fix cursor offset on rotation 180
Date:   Mon, 13 Feb 2023 15:49:06 +0100
Message-Id: <20230213144747.967908317@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Melissa Wen <mwen@igalia.com>

commit 49d0555976f0972af68397ed996375c135b38ba7 upstream.

Cursor gets clipped off in the middle of the screen with hw rotation
180. Fix a miscalculation of cursor offset when it's placed near the
edges in the pipe split case.

Cursor bugs with hw rotation were reported on AMD issue tracker:
https://gitlab.freedesktop.org/drm/amd/-/issues/2247

The issues on rotation 270 was fixed by:
https://lore.kernel.org/amd-gfx/20221118125935.4013669-22-Brian.Chang@amd.com/
that partially addressed the rotation 180 too. So, this patch is the
final bits for rotation 180.

Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 9d84c7ef8a87 ("drm/amd/display: Correct cursor position on horizontal mirror")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3612,7 +3612,7 @@ void dcn10_set_cursor_position(struct pi
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = temp_x + viewport_width;
+						pos_cpy.x = 2 * viewport_width - temp_x;
 					}
 				}
 			} else {


