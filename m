Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541686D4ACF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbjDCOug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbjDCOuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF062A583
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A41061F85
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F1C433D2;
        Mon,  3 Apr 2023 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533347;
        bh=o+J+h/Pf6H4iY4wyfLOfx223YbGFHOC8o6OrZ8khBYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWFlUDbHHPJN+s9d0rQ9z0SH1+fSx1jGxbfFcYuzfF9LZX7m+F5KkrxdxKYDrMrdJ
         8kLsV4/PMrjBnvamNxJYcy+bGqeWG6J+lODxtIUnbWNDOZfQAKcvi1xY0zBIdVpw1i
         YZ/u1MQK75NIc51Dpw0DNt/0i4Oyr2XZ3m3ZAi80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Chan <michael.chan@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 118/187] bnxt_en: Add missing 200G link speed reporting
Date:   Mon,  3 Apr 2023 16:09:23 +0200
Message-Id: <20230403140419.850054128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 581bce7bcb7e7f100908728e7b292e266c76895b ]

bnxt_fw_to_ethtool_speed() is missing the case statement for 200G
link speed reported by firmware.  As a result, ethtool will report
unknown speed when the firmware reports 200G link speed.

Fixes: 532262ba3b84 ("bnxt_en: ethtool: support PAM4 link speeds up to 200G")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 56355e64815e2..3056e5bb7d6fa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1225,6 +1225,7 @@ struct bnxt_link_info {
 #define BNXT_LINK_SPEED_40GB	PORT_PHY_QCFG_RESP_LINK_SPEED_40GB
 #define BNXT_LINK_SPEED_50GB	PORT_PHY_QCFG_RESP_LINK_SPEED_50GB
 #define BNXT_LINK_SPEED_100GB	PORT_PHY_QCFG_RESP_LINK_SPEED_100GB
+#define BNXT_LINK_SPEED_200GB	PORT_PHY_QCFG_RESP_LINK_SPEED_200GB
 	u16			support_speeds;
 	u16			support_pam4_speeds;
 	u16			auto_link_speeds;	/* fw adv setting */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7658a06b8d059..6bd18eb5137f4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1714,6 +1714,8 @@ u32 bnxt_fw_to_ethtool_speed(u16 fw_link_speed)
 		return SPEED_50000;
 	case BNXT_LINK_SPEED_100GB:
 		return SPEED_100000;
+	case BNXT_LINK_SPEED_200GB:
+		return SPEED_200000;
 	default:
 		return SPEED_UNKNOWN;
 	}
-- 
2.39.2



