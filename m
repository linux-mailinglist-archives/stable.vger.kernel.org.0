Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3944C6AF15B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbjCGSmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjCGSmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0A7B3712
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FC49B819D1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA26C433EF;
        Tue,  7 Mar 2023 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213938;
        bh=pOW9jUQ8Pv41eciZ5I3OJUacuILbVwVqho4pEpAG9Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1C5s3PgBscKvWViyVV997SR5XnWS9CJdRdTkScBtShXqmlrKkCdCRxsiRU3Ct7VB
         cJ2v8CJVYiAFBox23xuKJLt6pLyyQEmXsxV+1WxI6hUiB6Pd561CGElHNYUbjMLbsh
         HNLnt+K8dE7osfPm4hFhdUyrgZWe0oXfnlLu2rT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hansen Dsouza <hansen.dsouza@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 637/885] drm/amd/display: Enable P-state validation checks for DCN314
Date:   Tue,  7 Mar 2023 17:59:31 +0100
Message-Id: <20230307170029.834319370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 37d184b548db0f64d4a878960b2c6988b38a3e7e ]

[Why]
To align with DCN31 behavior. This helps avoid p-state hangs in
the case where underflow does occur.

[How]
Flip the bit to true.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index c80c8c8f51e97..5985ce8df4e08 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -897,7 +897,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.max_downscale_src_width = 4096,/*upto true 4k*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
-	.sanity_checks = false,
+	.sanity_checks = true,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
 	.dwb_fi_phase = -1, // -1 = disable,
 	.dmub_command_table = true,
-- 
2.39.2



