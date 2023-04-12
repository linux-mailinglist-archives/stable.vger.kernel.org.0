Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053556DEE3A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjDLIlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjDLIkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FCF7A9F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D8046300E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF1CC433D2;
        Wed, 12 Apr 2023 08:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288626;
        bh=uKRlQqf54VqYTAbgcmCVIc2lO0zRoCrjTI61V3EbSwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+dCfbj7O+lM4sUoK9flIYvuhwf+uz5Wkg81xE1YZPeO2DhugprIFF8xTiQLuIE1X
         rX90TPcLpFogYPZx76nOJLFz58WPfRSom8JPTdAXtjwHmJqPiZyrBTwK4szgEVHgSG
         kwreRe5wucaZz5AUD6dBNgR8ZWnnTekSLaLsxv5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Roulin <aroulin@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/93] ethtool: reset #lanes when lanes is omitted
Date:   Wed, 12 Apr 2023 10:33:49 +0200
Message-Id: <20230412082825.174866420@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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

From: Andy Roulin <aroulin@nvidia.com>

[ Upstream commit e847c7675e19ef344913724dc68f83df31ad6a17 ]

If the number of lanes was forced and then subsequently the user
omits this parameter, the ksettings->lanes is reset. The driver
should then reset the number of lanes to the device's default
for the specified speed.

However, although the ksettings->lanes is set to 0, the mod variable
is not set to true to indicate the driver and userspace should be
notified of the changes.

The consequence is that the same ethtool operation will produce
different results based on the initial state.

If the initial state is:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: on

then executing 'ethtool -s swp1 speed 50000 autoneg off' will yield:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: off

While if the initial state is:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 1
        Duplex: Full
        Auto-negotiation: off

executing the same 'ethtool -s swp1 speed 50000 autoneg off' results in:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 1
        Duplex: Full
        Auto-negotiation: off

This patch fixes this behavior. Omitting lanes will always results in
the driver choosing the default lane width for the chosen speed. In this
scenario, regardless of the initial state, the end state will be, e.g.,

$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: off

Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
Signed-off-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/ac238d6b-8726-8156-3810-6471291dbc7f@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/linkmodes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index f9eda596f3014..3d05b9bf34854 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -277,11 +277,12 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 					    "lanes configuration not supported by device");
 			return -EOPNOTSUPP;
 		}
-	} else if (!lsettings->autoneg) {
-		/* If autoneg is off and lanes parameter is not passed from user,
-		 * set the lanes parameter to 0.
+	} else if (!lsettings->autoneg && ksettings->lanes) {
+		/* If autoneg is off and lanes parameter is not passed from user but
+		 * it was defined previously then set the lanes parameter to 0.
 		 */
 		ksettings->lanes = 0;
+		*mod = true;
 	}
 
 	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
-- 
2.39.2



