Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927805C0385
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiIUQG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiIUQFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DD59F8C3;
        Wed, 21 Sep 2022 08:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6D4263189;
        Wed, 21 Sep 2022 15:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4FFC43140;
        Wed, 21 Sep 2022 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775688;
        bh=VwNcnLR2/LA/fz5sKeoJt9Vzelm+E+Rs4audF7yv7p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1+yq/aofyxj8frjclUkVBNyjhJcUqhnKroNAlsY8Sf7VEGFkC4m6kPyeB83hOiQl
         zhywn4TAzCJCS7KyMH3QvsC+YAloyXL46gtAb5uGDVE3Knq3gQLyr3Ve5oM8DVAdbM
         3Rh74WhjpQHyyPY2H69VIb8Ex+7ONTD0zdikhqv3qvHCqmCyzl0kDOhFm9ZJh/52MO
         OxzAob9OYqSwJw1ge8th/JBlviEiGh87GBVZ+56Zw0UdzAji3oPgr//C+aO14sstCn
         cKvr7TxKqnWzA8V6FfQjcj5fkX37DDtysL1EGKZTsTk9/yVm1rv8MNF50rVioPXgmA
         aPxMxn3wEWsYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, hjc@rock-chips.com,
        airlied@linux.ie, daniel@ffwll.ch, ndesaulniers@google.com,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 3/3] drm/rockchip: Fix return type of cdn_dp_connector_mode_valid
Date:   Wed, 21 Sep 2022 11:54:43 -0400
Message-Id: <20220921155444.235446-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155444.235446-1-sashal@kernel.org>
References: <20220921155444.235446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit b0b9408f132623dc88e78adb5282f74e4b64bb57 ]

The mode_valid field in drm_connector_helper_funcs is expected to be of
type:
enum drm_mode_status (* mode_valid) (struct drm_connector *connector,
				     struct drm_display_mode *mode);

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of cdn_dp_connector_mode_valid should be changed from
int to enum drm_mode_status.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220913205555.155149-1-nhuck@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index 3feab563e50a..3f992e5a75c9 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -284,8 +284,9 @@ static int cdn_dp_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int cdn_dp_connector_mode_valid(struct drm_connector *connector,
-				       struct drm_display_mode *mode)
+static enum drm_mode_status
+cdn_dp_connector_mode_valid(struct drm_connector *connector,
+			    struct drm_display_mode *mode)
 {
 	struct cdn_dp_device *dp = connector_to_dp(connector);
 	struct drm_display_info *display_info = &dp->connector.display_info;
-- 
2.35.1

