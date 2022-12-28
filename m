Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7C5657B54
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiL1PUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiL1PUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6113B1400A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0183FB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655F4C433EF;
        Wed, 28 Dec 2022 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240817;
        bh=DaTVzkMLITirh9+cuKYTn3zonT7QupSNy4dL1ilEick=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaeY0K1QFhTyi+JlP1C4NZ+RDKzY6Vm6a+ps8Iu4StbP5j0jFU/FpT/E0VxaABOhE
         Axq9YFuee9E8gztc85QTCyFHXx8x0gWMVogt0SncjCV2xIW5T885GAurMGgKUgz0f3
         qpL46uLjX7S7dbnP5837zxuc+OFkPL2oouC5UzHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0188/1073] wifi: fix multi-link element subelement iteration
Date:   Wed, 28 Dec 2022 15:29:36 +0100
Message-Id: <20221228144333.117577755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index b6e6d5b40774..181e758c70c1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4588,7 +4588,7 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 		return 0;
 	}
 
-	return common + mle->variable[0];
+	return sizeof(*mle) + common + mle->variable[0];
 }
 
 /**
-- 
2.35.1



