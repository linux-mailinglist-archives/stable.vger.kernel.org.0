Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E8A6CC49D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbjC1PGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjC1PGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF7EB65
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC00DB81D81
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F6FC433EF;
        Tue, 28 Mar 2023 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015917;
        bh=rgbxGXgtBGzX2TXTlLFoE5MhmnQh0pJ0IQKb8hN1d8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTcgmqzr1ptw77pTROlNIVwnPlItE3lxfy+dIbbEVrb27GpWw1qSCvfLcZfutqrFL
         wPCLP5xnhssHVo0UVcqP13H76OrWeY3vTOh9TUa6ZFFYU8wWHF6Z3KkrfOlZf03Ijh
         twaZ9x0b4qt54soJQowDAVBR72QyPC2f0mvGmcKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ma Jun <Jun.Ma2@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 224/224] drm/amdkfd: Fix the memory overrun
Date:   Tue, 28 Mar 2023 16:43:40 +0200
Message-Id: <20230328142626.610524578@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ma Jun <Jun.Ma2@amd.com>

commit 4cc16d64b6cdb179a26fb389cae9dce788e88f5d upstream.

Fix the memory overrun issue caused by wrong array size.

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527133 ("Memory - corruptions")
Fixes: c0cc999f3c32e6 ("drm/amdkfd: Fix the warning of array-index-out-of-bounds")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1111,7 +1111,7 @@ static int kfd_parse_subtype_cache(struc
 			props->cache_latency = cache->cache_latency;
 
 			memcpy(props->sibling_map, cache->sibling_map,
-					sizeof(props->sibling_map));
+					CRAT_SIBLINGMAP_SIZE);
 
 			/* set the sibling_map_size as 32 for CRAT from ACPI */
 			props->sibling_map_size = CRAT_SIBLINGMAP_SIZE;


