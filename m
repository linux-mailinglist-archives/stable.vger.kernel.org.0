Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F05594A86
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348503AbiHPAE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352047AbiHPAAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007FB4C618;
        Mon, 15 Aug 2022 13:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9147E61058;
        Mon, 15 Aug 2022 20:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1A5C433D7;
        Mon, 15 Aug 2022 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594884;
        bh=iR18bYAv9SkGFsw+uXDPCla5JonkaXLutaTp16BST7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbxPokLpyMPbNksmcCHfpgMwBy4HSk0U9xu2Pj4fLNkCJe5am/6UdWckpdnUBt5sA
         fLSMNSXCdxF2GhWvs0KyK0VrrEAisVeMY/O9rM94D8NtjDBgcXUUeceypLftkBQ22K
         xMqaLQ0g/d5J9284mlCZYIGikXhuOqcf6JOsZsuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0546/1157] drm/amd/display: fix signedness bug in execute_synaptics_rc_command()
Date:   Mon, 15 Aug 2022 19:58:22 +0200
Message-Id: <20220815180501.496657347@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 06ac561fb0edf868f7b292fb4a3c8ffbbb1e14bb ]

The "ret" variable needs to be signed for the error handling to work.

Fixes: 2ca97adccdc9 ("drm/amd/display: Add Synaptics Fifo Reset Workaround")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 7c799ddc1d27..82c04af09d18 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -571,7 +571,7 @@ static bool execute_synaptics_rc_command(struct drm_dp_aux *aux,
 	unsigned char rc_cmd = 0;
 	unsigned char rc_result = 0xFF;
 	unsigned char i = 0;
-	uint8_t ret = 0;
+	int ret;
 
 	if (is_write_cmd) {
 		// write rc data
-- 
2.35.1



