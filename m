Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B708553C08
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 22:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355019AbiFUUza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355600AbiFUUyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:54:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E42531383;
        Tue, 21 Jun 2022 13:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC4AF61883;
        Tue, 21 Jun 2022 20:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAB6C341C5;
        Tue, 21 Jun 2022 20:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844581;
        bh=660kXd77qcPDVa686VT/y/8vzyFt3StpZ0wADPOdaDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8bwBp3NXr1k11e1U5rUm1i97tzcM0g5iRluWXf8uV8gFk0sb/jtqAjhfE4SKXba7
         OOSl61UnKZV7uctymdhtjSPIqTdH+p0AoGNY1gZrdh+L97v94mHnAlMDcxaCSxME3O
         EEFClZQNe1K920IPgmHNJ1wYMNLGJ/ZuNiYLzILdVHUfVRwyPq0Cl26KqUgYWapmqL
         oNi9RsBeUB8PAPg9Y6oJvCHVl2d0L2dmC0OFNGWU/gr7JiMuZq7fjGY7UNZa+qkYQo
         2DQfFXI2UcDX3EiAH1LuNFtrQKN6gXMWYFK/pJ9m7cdRXBaXk5nztAELrB2VHrISb5
         DuhiYC75rVX5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 04/22] mei: me: set internal pg flag to off on hardware reset
Date:   Tue, 21 Jun 2022 16:49:10 -0400
Message-Id: <20220621204928.249907-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
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
index 719fee9af156..0954a5cb63d1 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1154,6 +1154,8 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 			ret = mei_me_d0i3_exit_sync(dev);
 			if (ret)
 				return ret;
+		} else {
+			hw->pg_state = MEI_PG_OFF;
 		}
 	}
 
-- 
2.35.1

