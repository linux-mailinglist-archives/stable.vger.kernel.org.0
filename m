Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3EE5FD2B0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJMBhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJMBh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A362150481;
        Wed, 12 Oct 2022 18:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA7C616E2;
        Thu, 13 Oct 2022 00:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C7EC433C1;
        Thu, 13 Oct 2022 00:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620473;
        bh=pZTA8+b6t89yvqWaduEatUoC/Fpvy1u8fwa7q8EqwVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaXfSvPAke1/qRyo9d3HC3HnmuwWB/RQzHuSkIXv7acTrjXUK3OmHSib1S7FvEU5F
         fNFVfxCtAZWD2BSXrmmtQNo+VRUJDZsuaocIYjb4GCt2iGnzIu4fug+t7uE1AZKLSZ
         f5DsBAB9NmyGsahRm7kGEinknB/HNUh+mYj7SrlZQWcO0EVjh67vrNjyvW6IMBjwjg
         vpcuIIp9IgEH/YhVaKZvRoocfOzZ+5ptimZfeYQJdc4wFYnTqbYnwdQXSCHNdqrZU/
         jrJ4yZk/xBe0nwOkzNTvSpBPqJ8nonxe43R0gslPDI4AkE4wFdqL1UmQgJaCYqBk8M
         gBxgxQqEbqeTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Chang <waynec@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, quic_linyyuan@quicinc.com,
        rajaram.regupathy@intel.com, tiwai@suse.de,
        saranya.gopal@intel.com, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 61/63] usb: typec: ucsi: Don't warn on probe deferral
Date:   Wed, 12 Oct 2022 20:18:35 -0400
Message-Id: <20221013001842.1893243-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit fce703a991b7e8c7e1371de95b9abaa832ecf9c3 ]

Deferred probe is an expected return value for fwnode_usb_role_switch_get().
Given that the driver deals with it properly, there's no need to output a
warning that may potentially confuse users.

--
V2 -> V3: remove the Fixes and Cc
V1 -> V2: adjust the coding style for better reading format.
 drivers/usb/typec/ucsi/ucsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220927134512.2651067-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 6364f0d467ea..74fb5a4c6f21 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1067,11 +1067,9 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
 	cap->fwnode = ucsi_find_fwnode(con);
 	con->usb_role_sw = fwnode_usb_role_switch_get(cap->fwnode);
-	if (IS_ERR(con->usb_role_sw)) {
-		dev_err(ucsi->dev, "con%d: failed to get usb role switch\n",
-			con->num);
-		return PTR_ERR(con->usb_role_sw);
-	}
+	if (IS_ERR(con->usb_role_sw))
+		return dev_err_probe(ucsi->dev, PTR_ERR(con->usb_role_sw),
+			"con%d: failed to get usb role switch\n", con->num);
 
 	/* Delay other interactions with the con until registration is complete */
 	mutex_lock(&con->lock);
-- 
2.35.1

