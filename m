Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246E6553D3A
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355661AbiFUVCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355742AbiFUVBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:01:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78EB25F9;
        Tue, 21 Jun 2022 13:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF585B81B31;
        Tue, 21 Jun 2022 20:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05383C3411C;
        Tue, 21 Jun 2022 20:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844710;
        bh=VL7bWDXe8ljpJO1MWHeq70mjEul+u0QUCZHVWXXtVrk=;
        h=From:To:Cc:Subject:Date:From;
        b=RvB1uNDNtO7d5Q8Kp3zE11jo0nwgIfL+/7UAtgbzr7K4uR8zMIHiHI03t+w2y+k4b
         5Cm2AX6EANxmuq0ihZ9Pt44hJ8j+HAUAEIsFmmNhBvwlySiHAhs3Yg+DUIhh7x5d3T
         tid0JDMySzRGSJRoC48FNusRv3aAnLhLbgJrfFLNu6uzEtlLdDvaiOPgWlymgmPOvp
         gA0vbTTU/fwT3liNhfPZDnSRPrBhYdvgmR2kmmchRTRQj4WM7fXX9Q/QmhVxSjita2
         ur42xWqBTjc5Yb9o+2cBc6fcV0HE/PdkyHU7dfFgFmxdfyBOfIhzeh09gPzjlgUOgm
         xislqTWYrwsaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 1/3] mei: me: set internal pg flag to off on hardware reset
Date:   Tue, 21 Jun 2022 16:51:45 -0400
Message-Id: <20220621205148.251040-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 9f4639373e6756e1ccf0029f861f1061db3c3616 ]

Link reset flow is always performed in the runtime resumed state.
The internal PG state may be left as ON after the suspend
and will not be updated upon the resume if the D0i3 is not supported.

Ensure that the internal PG state is set to the right value on the flow
entrance in case the firmware does not support D0i3.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20220606144225.282375-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/hw-me.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 56c2101e80ad..082450c27be6 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1061,6 +1061,8 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 			ret = mei_me_d0i3_exit_sync(dev);
 			if (ret)
 				return ret;
+		} else {
+			hw->pg_state = MEI_PG_OFF;
 		}
 	}
 
-- 
2.35.1

