Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D466BB210
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjCOMc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjCOMcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4DD6702E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0FB161ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5432C433EF;
        Wed, 15 Mar 2023 12:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883494;
        bh=vsP5zue/IExoFhZ69eEvRir84B0LNiO1AYO1Gr4lC48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaHLeKwc7+C5Wg+8eIHXGRMEj+jRQ0x94nTHn56a+Dsqvy4693zKH4xuzMmSUb6Or
         dDOPzzcv6CjTd1IZ97yQgrN7vUFbdRYTxDrUIdH6u/h/hci8f5aUPf0wRAvuC7KKqT
         LnFlXoWJFpXVBibNUr5KDdYa3kIeVSF04TqwyYBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 012/143] drm/amdgpu: fix error checking in amdgpu_read_mm_registers for nv
Date:   Wed, 15 Mar 2023 13:11:38 +0100
Message-Id: <20230315115740.834117668@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

commit b42fee5e0b44344cfe4c38e61341ee250362c83f upstream.

Properly skip non-existent registers as well.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2442
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -393,9 +393,10 @@ static int nv_read_register(struct amdgp
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(nv_allowed_read_registers); i++) {
 		en = &nv_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-		    reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
-				   + en->reg_offset))
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+					+ en->reg_offset))
 			continue;
 
 		*value = nv_get_register_value(adev,


