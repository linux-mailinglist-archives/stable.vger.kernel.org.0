Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE46433A6
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiLETiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiLETiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B9238B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:34:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C4B1B81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97603C433D6;
        Mon,  5 Dec 2022 19:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268895;
        bh=50QhdGtJhKGuCGi6h+XHanbpEno0vLlMeY3iuEc5VGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYUJXdOG3O576RkU94Av/3tJdL5E1TObxOlD8c550OVGUJE7KPXJM8RB9SY2/cvaj
         bKp9RT8siW3h0tEiFCrQTLbdZmzVSTwMiZbqlGZ2T3XKn01Q/euv8bWWOE7kJKyg4C
         /aFNFg0G46PdX5HuUlZCseHsxk9Qai9RkIvHmVJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Claudio Suarez <cssk@net-c.es>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/120] drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"
Date:   Mon,  5 Dec 2022 20:09:13 +0100
Message-Id: <20221205190806.976645539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 602ad43c3cd8f15cbb25ce9bb494129edb2024ed ]

This partially reverts 20543be93ca45968f344261c1a997177e51bd7e1.

Calling drm_connector_update_edid_property() in
amdgpu_connector_free_edid() causes a noticeable pause in
the system every 10 seconds on polled outputs so revert this
part of the change.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2257
Cc: Claudio Suarez <cssk@net-c.es>
Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 34f217544c36..c777aff164b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -328,7 +328,6 @@ static void amdgpu_connector_free_edid(struct drm_connector *connector)
 
 	kfree(amdgpu_connector->edid);
 	amdgpu_connector->edid = NULL;
-	drm_connector_update_edid_property(connector, NULL);
 }
 
 static int amdgpu_connector_ddc_get_modes(struct drm_connector *connector)
-- 
2.35.1



