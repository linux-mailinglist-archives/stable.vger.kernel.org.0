Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A05A50509C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiDRM0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbiDRM0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A967EE03D;
        Mon, 18 Apr 2022 05:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 529BDB80ED6;
        Mon, 18 Apr 2022 12:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D0C385A1;
        Mon, 18 Apr 2022 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284408;
        bh=O0gvCtnZhBJtodvmay0VSXZVJisqZkVG+Lo2qywGmHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9STqwmKj4+OFb548ZLrr46NlOrgKlWcKzGO9nzXFuFfwyaIL/qm5+FE4vUh1NbfY
         PtrjsVbJfs6O7Krj3de6SkMtmLZwQ+C++vFMd1JuCseIqMiclJeqU9UVhl0UVQ4b1K
         txJER9PTfVnlo9IlD4B/uZ3JCBmvimR2fDaEMCiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 088/219] mac80211: fix ht_capa printout in debugfs
Date:   Mon, 18 Apr 2022 14:10:57 +0200
Message-Id: <20220418121208.976039363@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit fb4bccd863ccccd36ad000601856609e259a1859 ]

Don't use sizeof(pointer) when calculating scnprintf offset.

Fixes: 01f84f0ed3b4 ("mac80211: reduce stack usage in debugfs")
Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://lore.kernel.org/r/20220406175659.20611-1-greearb@candelatech.com
[correct the Fixes tag]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 9479f2787ea7..88d9cc945a21 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -441,7 +441,7 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 #define PRINT_HT_CAP(_cond, _str) \
 	do { \
 	if (_cond) \
-			p += scnprintf(p, sizeof(buf)+buf-p, "\t" _str "\n"); \
+			p += scnprintf(p, bufsz + buf - p, "\t" _str "\n"); \
 	} while (0)
 	char *buf, *p;
 	int i;
-- 
2.35.1



