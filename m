Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A67D658014
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiL1QNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiL1QMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B489B1A839
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55788B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B0FC433D2;
        Wed, 28 Dec 2022 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243875;
        bh=n63OJlO5NFLIXrQiDUEKqQoYYsMh666UlNW/XdXI1lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnElnfkOItP2Q0y5cGxZRefhAAANglz8zEC072ERB/Z8S8uAbX+t3cwc5K2nxTG6p
         p6sfnTpqLyL+O9OZEtxzrTAmnuK8CgmIosn6oPcoZaX8nECiQkXBIry9wnc7b5C0C7
         AgUngTbDU7WPwLh6nsAxG0OUW7+15dzt2xtCKF+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0570/1146] net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path
Date:   Wed, 28 Dec 2022 15:35:09 +0100
Message-Id: <20221228144345.656411570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e095493091e850d5292ad01d8fbf5cde1d89ac53 ]

If dsa_tag_8021q_setup() fails, for example due to the inability of the
device to install a VLAN, the tag_8021q context of the switch will leak.
Make sure it is freed on the error path.

Fixes: 328621f6131f ("net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20221209235242.480344-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 34e5ec5d3e23..89371b16416e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -398,6 +398,7 @@ static void dsa_tag_8021q_teardown(struct dsa_switch *ds)
 int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 {
 	struct dsa_8021q_context *ctx;
+	int err;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -410,7 +411,15 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 
 	ds->tag_8021q_ctx = ctx;
 
-	return dsa_tag_8021q_setup(ds);
+	err = dsa_tag_8021q_setup(ds);
+	if (err)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	kfree(ctx);
+	return err;
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
 
-- 
2.35.1



