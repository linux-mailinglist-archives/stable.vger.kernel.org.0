Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980F64F347A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiDEIe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239460AbiDEIUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2931F986EA;
        Tue,  5 Apr 2022 01:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C8F60B0A;
        Tue,  5 Apr 2022 08:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA909C385A1;
        Tue,  5 Apr 2022 08:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146424;
        bh=csgVznpz+CbDSMa65uT6mHegJRLSqN9GgMqe8LRJoHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KS736sv6URAg8KSfmKGMLOV2RhN9NlVOcmYWZBVbXeUJvpyWqe0WMRwQ3W3p4d41h
         wFvNwqXBozoUD0RvjiE1uYgA+K+NVuupU/0OtlsUM5T4E1rTHfn8rL0oH156eEAEup
         hK4dh+wE0Xe4RR+BydxhARZ/k/xy2pboys6Qri4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libin Yang <libin.yang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0721/1126] soundwire: intel: fix wrong register name in intel_shim_wake
Date:   Tue,  5 Apr 2022 09:24:28 +0200
Message-Id: <20220405070428.756144289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Libin Yang <libin.yang@intel.com>

[ Upstream commit 3957db3ae3dae6f8b8168791f154567fe49e1fd7 ]

When clearing the sdw wakests status, we should use SDW_SHIM_WAKESTS.

Fixes: 4a17c441c7cb ("soundwire: intel: revisit SHIM programming sequences.")
Signed-off-by: Libin Yang <libin.yang@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220126011451.27853-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 122f7a29d8ca..63101f1ba271 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -448,8 +448,8 @@ static void intel_shim_wake(struct sdw_intel *sdw, bool wake_enable)
 
 		/* Clear wake status */
 		wake_sts = intel_readw(shim, SDW_SHIM_WAKESTS);
-		wake_sts |= (SDW_SHIM_WAKEEN_ENABLE << link_id);
-		intel_writew(shim, SDW_SHIM_WAKESTS_STATUS, wake_sts);
+		wake_sts |= (SDW_SHIM_WAKESTS_STATUS << link_id);
+		intel_writew(shim, SDW_SHIM_WAKESTS, wake_sts);
 	}
 	mutex_unlock(sdw->link_res->shim_lock);
 }
-- 
2.34.1



