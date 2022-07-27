Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CC4583065
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbiG0Rh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbiG0RhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D786863D6;
        Wed, 27 Jul 2022 09:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0114B821D6;
        Wed, 27 Jul 2022 16:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC9AC433D6;
        Wed, 27 Jul 2022 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940595;
        bh=zZ/9f23sDmN1CWFHzWyAvJwPqv0U6mY2o48R35fTxeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzkGse2VtFMioMdEbauj9D441BG93AeTpW7WDI/BQmpHpoFWCnkkjc5e+eKVNYelW
         NjEEjTdFIswDREEBUMVhR34wgF5IEvkbynFT/C36UdxEIb+g24WO+UzL05dMsvUx3F
         78j431osvuhTE/ieyp7DcKIKZYxXpqkWR0C3oTUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jun Zhang <xuejun.zhang@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 080/158] iavf: Fix missing state logs
Date:   Wed, 27 Jul 2022 18:12:24 +0200
Message-Id: <20220727161024.705697137@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit d8fa2fd791a72087c1ce3336fbeefec4057c37c8 ]

Fix debug prints, by adding missing state prints.

Extend iavf_state_str by strings for __IAVF_INIT_EXTENDED_CAPS and
__IAVF_INIT_CONFIG_ADAPTER.

Without this patch, when enabling debug prints for iavf.h, user will
see:
iavf 0000:06:0e.0: state transition from:__IAVF_INIT_GET_RESOURCES to:__IAVF_UNKNOWN_STATE
iavf 0000:06:0e.0: state transition from:__IAVF_UNKNOWN_STATE to:__IAVF_UNKNOWN_STATE

Fixes: 605ca7c5c670 ("iavf: Fix kernel BUG in free_msi_irqs")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 2a7b3c085aa9..0ea0361cd86b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -464,6 +464,10 @@ static inline const char *iavf_state_str(enum iavf_state_t state)
 		return "__IAVF_INIT_VERSION_CHECK";
 	case __IAVF_INIT_GET_RESOURCES:
 		return "__IAVF_INIT_GET_RESOURCES";
+	case __IAVF_INIT_EXTENDED_CAPS:
+		return "__IAVF_INIT_EXTENDED_CAPS";
+	case __IAVF_INIT_CONFIG_ADAPTER:
+		return "__IAVF_INIT_CONFIG_ADAPTER";
 	case __IAVF_INIT_SW:
 		return "__IAVF_INIT_SW";
 	case __IAVF_INIT_FAILED:
-- 
2.35.1



