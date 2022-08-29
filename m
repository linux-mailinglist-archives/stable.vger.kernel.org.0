Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769FC5A4A06
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiH2LcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiH2LbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7C67C51D;
        Mon, 29 Aug 2022 04:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 192426119E;
        Mon, 29 Aug 2022 11:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B3C433C1;
        Mon, 29 Aug 2022 11:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771918;
        bh=3dS8Cl8OdudEu8+bE1purv/USvTN3iusgBurK2pHTfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGYcVOkj6cxbm73RSYQ+euU8a/4zozO2c+Wg817UJoYYGVRXeWqz/H0m2h1eu5rhJ
         KTq2vSgS7stTb8bi4iOipER3pFarhzKJuUewRgiRpfvUeIjt4PlMrFRPw7m9dbgReS
         pscRtmjSm0h/Jfx5+d0WKN5hcL0963Kyv2tKZoz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 140/158] drm/amdkfd: Fix isa version for the GC 10.3.7
Date:   Mon, 29 Aug 2022 12:59:50 +0200
Message-Id: <20220829105814.955906840@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Prike Liang <Prike.Liang@amd.com>

commit ee8086dbc1585d9f4020a19447388246a5cff5c8 upstream.

Correct the isa version for handling KFD test.

Fixes: 7c4f4f197e0c ("drm/amdkfd: Add GC 10.3.6 and 10.3.7 KFD definitions")
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -377,12 +377,8 @@ struct kfd_dev *kgd2kfd_probe(struct amd
 				f2g = &gfx_v10_3_kfd2kgd;
 			break;
 		case IP_VERSION(10, 3, 6):
-			gfx_target_version = 100306;
-			if (!vf)
-				f2g = &gfx_v10_3_kfd2kgd;
-			break;
 		case IP_VERSION(10, 3, 7):
-			gfx_target_version = 100307;
+			gfx_target_version = 100306;
 			if (!vf)
 				f2g = &gfx_v10_3_kfd2kgd;
 			break;


