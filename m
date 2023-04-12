Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A106DEF42
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjDLItV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjDLItU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F035A93D1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0FCF6313C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EFBC433D2;
        Wed, 12 Apr 2023 08:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289311;
        bh=5cY+KYllyQz3wkeEM6rYhYYVqe7C1LBhwHvgXUr+uno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoI328+CjLkTieZfVg072dXgu0DL1BIdsPGRLBZ+q0B4ou6MQTuzvGWrftf5mRZNd
         Fbl388FR9pwno4ErptARjJK1k6FONkOXioMVK+SH2qucYiJnwBh9gLNrx7fUiuFCT0
         zv+6uW1423EOyKP3OstzyFkGkpCs5cWAf5Sr4b3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Roulin <aroulin@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 050/173] ethtool: reset #lanes when lanes is omitted
Date:   Wed, 12 Apr 2023 10:32:56 +0200
Message-Id: <20230412082840.132555507@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
index 126e06c713a3a..2d91f2a8c7626 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -282,11 +282,12 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
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



