Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60343531A3C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbiEWRno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbiEWRiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6AA8BD12;
        Mon, 23 May 2022 10:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 818B261261;
        Mon, 23 May 2022 17:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D15C385A9;
        Mon, 23 May 2022 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327062;
        bh=E0vUSpxPLIELQGfG4YeyedZtqjlmxegQcKpK3CCbthE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnxiVdAXZqZUMYWVp5U8psj/GIaYqbsxP9toPrQm/uZtxUQ0ieno1zCjrhRqe6udG
         XaCWGJr7zr+Tb1G62CwIjgpwPsHtCTD6SzyB2oxTVdlpsPugsaIBlZPepNZd069xxC
         XXwm45Wies2mR2kAK13I5MNyMQl1hqKPl9385YYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 145/158] drm/amd/display: undo clearing of z10 related function pointers
Date:   Mon, 23 May 2022 19:05:02 +0200
Message-Id: <20220523165854.271190940@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Yang <Eric.Yang2@amd.com>

[ Upstream commit 9b9bd3f640640f94272a461b2dfe558f91b322c5 ]

[Why]
Z10 and S0i3 have some shared path. Previous code clean up ,
incorrectly removed these pointers, which breaks s0i3 restore

[How]
Do not clear the function pointers based on Z10 disable.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
index d7559e5a99ce..e708f07fe75a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
@@ -153,9 +153,4 @@ void dcn31_hw_sequencer_construct(struct dc *dc)
 		dc->hwss.init_hw = dcn20_fpga_init_hw;
 		dc->hwseq->funcs.init_pipes = NULL;
 	}
-	if (dc->debug.disable_z10) {
-		/*hw not support z10 or sw disable it*/
-		dc->hwss.z10_restore = NULL;
-		dc->hwss.z10_save_init = NULL;
-	}
 }
-- 
2.35.1



