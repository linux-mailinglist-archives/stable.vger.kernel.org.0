Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1BE6BB2DA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjCOMjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbjCOMiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2DA3355
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2213DB81DF9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940A8C433D2;
        Wed, 15 Mar 2023 12:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883849;
        bh=u43F4xL5o6RvI8DWP3xUqSOGEUgFrGIGlZP+lYqUWag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bd3VEQdAs90mIDgfhvRR1DJbzWiR6naq9sRgtOxWuQd9HdMuCkOw70idsClVRM37b
         MwPjStecRxNrTnoYwYhDZdgHTYrSAxPazAMyay3ppT8hBwKVarOGOFpzlgEIFlg1m+
         oNSnLatY1dlq1UKPzVnlbCt7D4X9NSVxkDaKfDDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawking Zhang <Hawking.Zhang@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 012/141] drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15
Date:   Wed, 15 Mar 2023 13:11:55 +0100
Message-Id: <20230315115740.355542059@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 0dcdf8498eae2727bb33cef3576991dc841d4343 upstream.

Properly skip non-existent registers as well.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2442
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -439,8 +439,9 @@ static int soc15_read_register(struct am
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(soc15_allowed_read_registers); i++) {
 		en = &soc15_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-			reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
 					+ en->reg_offset))
 			continue;
 


