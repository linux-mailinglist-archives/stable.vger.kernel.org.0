Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6566DEDF2
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjDLIil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDLIi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C4483E5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A2B262FE8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587BDC433EF;
        Wed, 12 Apr 2023 08:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288537;
        bh=CAV92dUJEaWzF2rsEApT8/n2gspYX3igZNIpCkHQtcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE6kAhad+oLBSvQBPD/Wrgbq5aI0ZAbPxfEBSz+IoXQYFrCWecgEoWU2wqhBZofTb
         4vko20phUnJuqDHRn72FzhIEQ3l8MgrPREW5JXlhrndIXJjjaobcexF4rgA1HRqiur
         G9NJ5YIPJ5UQeCL94h4TAYqhRZjIR+IFOlRERg3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/93] iavf: return errno code instead of status code
Date:   Wed, 12 Apr 2023 10:33:17 +0200
Message-Id: <20230412082823.721667346@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 9f4651ea3e07339b460d403ff01b7cc2178fef7b ]

The iavf_parse_cls_flower function returns an integer error code, and
not an iavf_status enumeration.

Fix the function to use the standard errno value EINVAL as its return
instead of using IAVF_ERR_CONFIG.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6650c8e906ce ("iavf/iavf_main: actually log ->src mask when talking about it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f5e6ae2c683f4..bafccf61c654f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3103,7 +3103,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether dest mask %pM\n",
 					match.mask->dst);
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3113,7 +3113,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether src mask %pM\n",
 					match.mask->src);
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3148,7 +3148,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad vlan mask %u\n",
 					match.mask->vlan_id);
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 		vf->mask.tcp_spec.vlan_id |= cpu_to_be16(0xffff);
@@ -3172,7 +3172,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip dst mask 0x%08x\n",
 					be32_to_cpu(match.mask->dst));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3182,13 +3182,13 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
 					be32_to_cpu(match.mask->dst));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
 		if (field_flags & IAVF_CLOUD_FIELD_TEN_ID) {
 			dev_info(&adapter->pdev->dev, "Tenant id not allowed for ip filter\n");
-			return IAVF_ERR_CONFIG;
+			return -EINVAL;
 		}
 		if (match.key->dst) {
 			vf->mask.tcp_spec.dst_ip[0] |= cpu_to_be32(0xffffffff);
@@ -3209,7 +3209,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		if (ipv6_addr_any(&match.mask->dst)) {
 			dev_err(&adapter->pdev->dev, "Bad ipv6 dst mask 0x%02x\n",
 				IPV6_ADDR_ANY);
-			return IAVF_ERR_CONFIG;
+			return -EINVAL;
 		}
 
 		/* src and dest IPv6 address should not be LOOPBACK
@@ -3219,7 +3219,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		    ipv6_addr_loopback(&match.key->src)) {
 			dev_err(&adapter->pdev->dev,
 				"ipv6 addr should not be loopback\n");
-			return IAVF_ERR_CONFIG;
+			return -EINVAL;
 		}
 		if (!ipv6_addr_any(&match.mask->dst) ||
 		    !ipv6_addr_any(&match.mask->src))
@@ -3244,7 +3244,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad src port mask %u\n",
 					be16_to_cpu(match.mask->src));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3254,7 +3254,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad dst port mask %u\n",
 					be16_to_cpu(match.mask->dst));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 		if (match.key->dst) {
-- 
2.39.2



