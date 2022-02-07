Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD724ABB01
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351916AbiBGLZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378469AbiBGLPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7029CC0401C4;
        Mon,  7 Feb 2022 03:15:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 879ABB81028;
        Mon,  7 Feb 2022 11:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC37CC004E1;
        Mon,  7 Feb 2022 11:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232542;
        bh=bZY68VpT7CGufdOKN0ip2iobYHcwOX8yhXkeaZpLdgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQfR+uKtNspJChdBaKchg6AGLRT8g7mU0SVrFgIlMHtdHku/73Lux527VrVFhRTyw
         44yoop9ZKaNGsLKMTmPiiR69q3hOKdXHolUXmBabgXxsVRCQH5iXQ0a32j6IKLdSnE
         75lQSrzb/YmGkltdJg9o3aq9LVdjX+nNnab2PfLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/86] yam: fix a memory leak in yam_siocdevprivate()
Date:   Mon,  7 Feb 2022 12:06:06 +0100
Message-Id: <20220207103758.949477972@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 29eb31542787e1019208a2e1047bb7c76c069536 ]

ym needs to be free when ym->cmd != SIOCYAMSMCS.

Fixes: 0781168e23a2 ("yam: fix a missing-check bug")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/yam.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index fdab498725878..3db86f247bf45 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -966,9 +966,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				 sizeof(struct yamdrv_ioctl_mcs));
 		if (IS_ERR(ym))
 			return PTR_ERR(ym);
-		if (ym->cmd != SIOCYAMSMCS)
-			return -EINVAL;
-		if (ym->bitrate > YAM_MAXBITRATE) {
+		if (ym->cmd != SIOCYAMSMCS || ym->bitrate > YAM_MAXBITRATE) {
 			kfree(ym);
 			return -EINVAL;
 		}
-- 
2.34.1



