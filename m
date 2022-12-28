Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A48657B9D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiL1PXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiL1PXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A679713EB5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 410F961544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B53C433EF;
        Wed, 28 Dec 2022 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241012;
        bh=oDdBjHRqDV6DkjrLZrQCVMNACC27WqlqIX2ZOprd9AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxyr8f4J7UZcrjYuMVvBXjptwpsHYe9jb1q5zA8GbNXmdWg0N3KwLxb2RpLg3OQEc
         Pn3eG+V9HLrMgNc1wgQh5/zcoPhkqxghFzGaQNPt/VxDkrpkwp3a05mllI6vPSJXUH
         yygn7PlYBGoWbZG6VAWfJCiVJGcY28KxJvm+ui+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0195/1146] wifi: fix multi-link element subelement iteration
Date:   Wed, 28 Dec 2022 15:28:54 +0100
Message-Id: <20221228144335.442737586@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1177aaa7fe9373c762cd5bf5f5de8517bac989d5 ]

The subelements obviously start after the common data, including
the common multi-link element structure definition itself. This
bug was possibly just hidden by the higher bits of the control
being set to 0, so the iteration just found one bogus element
and most of the code could continue anyway.

Fixes: 0f48b8b88aa9 ("wifi: ieee80211: add definitions for multi-link element")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 79690938d9a2..d3088666f3f4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4594,7 +4594,7 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 		return 0;
 	}
 
-	return common + mle->variable[0];
+	return sizeof(*mle) + common + mle->variable[0];
 }
 
 /**
-- 
2.35.1



