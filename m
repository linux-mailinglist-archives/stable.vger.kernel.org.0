Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4FD4FD3E0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356069AbiDLHeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355654AbiDLH1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A970E4EDE0;
        Tue, 12 Apr 2022 00:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAA70B81B54;
        Tue, 12 Apr 2022 07:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B69EC385A8;
        Tue, 12 Apr 2022 07:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747272;
        bh=GKounZqJS96t0E4wQdvhNBG6ZpQrjW2xlU2vl6Bc/jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XG+ZwYWlmP+1S2M1aw2PYOvLDhl6NZuFYLDj+VXMGQsx1knlXo3/8LaUHjnG8VRJ+
         50Wxg+lhdHSrkNKmHzkOgP8U1Qk318ZRCNJ1wOFMS0hofzzFRe0GqvFexiXBzs0JHy
         mG8p0Q0Bgg2pGYAEazUYsPsrJ9EPjKxiMBWd3gOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 004/343] net: dsa: felix: fix possible NULL pointer dereference
Date:   Tue, 12 Apr 2022 08:27:02 +0200
Message-Id: <20220412062951.228586224@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 866b7a278cdb51eb158cd8513bc7438fc857804a ]

As the possible failure of the allocation, kzalloc() may return NULL
pointer.
Therefore, it should be better to check the 'sgi' in order to prevent
the dereference of NULL pointer.

Fixes: 23ae3a7877718 ("net: dsa: felix: add stream gate settings for psfp").
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220329090800.130106-1-zhengyongjun3@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 33f0ceae381d..2875b5250856 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1940,6 +1940,10 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 		case FLOW_ACTION_GATE:
 			size = struct_size(sgi, entries, a->gate.num_entries);
 			sgi = kzalloc(size, GFP_KERNEL);
+			if (!sgi) {
+				ret = -ENOMEM;
+				goto err;
+			}
 			vsc9959_psfp_parse_gate(a, sgi);
 			ret = vsc9959_psfp_sgi_table_add(ocelot, sgi);
 			if (ret) {
-- 
2.35.1



