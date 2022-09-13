Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FDF5B7641
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiIMQSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiIMQSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:18:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C780C78217;
        Tue, 13 Sep 2022 08:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F086F614E5;
        Tue, 13 Sep 2022 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1EAC433C1;
        Tue, 13 Sep 2022 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079812;
        bh=8qsHYCJV1ZTyzzOv+TkfjsHrwXn5+dFsnO0D33wFLSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNm268IkcoCm6xJA8GzBu8wF4gWgmch1mGZNzs4uJlE861Rp2pjhUev6uTsMGaLRy
         eAXYK/m2LcOycP6I4nA9N8iAV+Ex6p8PB/kPsI3qy0KkCT/l9W5/CUwdrBQyLJURBL
         7w3Eo6HkkQDo6q1ng2+LJ9zob0Dkgoog+iuHhR58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/42] wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
Date:   Tue, 13 Sep 2022 16:07:34 +0200
Message-Id: <20220913140342.404648165@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d776763f48084926b5d9e25507a3ddb7c9243d5e ]

The return type is supposed to be ssize_t, which is signed long,
but "r" was declared as unsigned int.  This means that on 64 bit systems
we return positive values instead of negative error codes.

Fixes: 80a3511d70e8 ("cfg80211: add debugfs HT40 allow map")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YutvOQeJm0UjLhwU@kili
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 5d453916a4179..6a7f4432440a5 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -68,9 +68,10 @@ static ssize_t ht40allow_map_read(struct file *file,
 {
 	struct wiphy *wiphy = file->private_data;
 	char *buf;
-	unsigned int offset = 0, buf_size = PAGE_SIZE, i, r;
+	unsigned int offset = 0, buf_size = PAGE_SIZE, i;
 	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
+	ssize_t r;
 
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf)
-- 
2.35.1



