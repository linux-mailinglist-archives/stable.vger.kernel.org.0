Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0647163E052
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiK3Szz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiK3Szx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5841A63D75
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA69561D56
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CB7C433D6;
        Wed, 30 Nov 2022 18:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834552;
        bh=3ZKDYn4TXzPdV99ktQiPeVb2rB0u5wdZ2/vq/tGf8dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJsn+H9hHuzlYtPS4p1RuNebTRBTODtvYKJgFanv9jI6bRqUbJns57xJRAEkWbga/
         5HLpaQhG8zCSP+uIEwORZ4GhY51Wu+81yVpAafcs1iXaFFutsZS/DBKEUftey3qRCG
         1NbwzTG6FVfa4q0XHdluzy/TXx9EzJKo48gTrx6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Claudio Suarez <cssk@net-c.es>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 288/289] drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"
Date:   Wed, 30 Nov 2022 19:24:33 +0100
Message-Id: <20221130180550.631852007@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

commit 602ad43c3cd8f15cbb25ce9bb494129edb2024ed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -328,7 +328,6 @@ static void amdgpu_connector_free_edid(s
 
 	kfree(amdgpu_connector->edid);
 	amdgpu_connector->edid = NULL;
-	drm_connector_update_edid_property(connector, NULL);
 }
 
 static int amdgpu_connector_ddc_get_modes(struct drm_connector *connector)


