Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAAE5FDFF3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJMSBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJMSBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:01:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121DA44CF8;
        Thu, 13 Oct 2022 11:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B42976192E;
        Thu, 13 Oct 2022 17:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF016C4314D;
        Thu, 13 Oct 2022 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683790;
        bh=ogYEemfj0hCqBP5FiJ/sT1nkQsZaGnWIZS7D7O/DT14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7NraigCqQ53b2ffZpFOz5DUqkLWw/+m00DWqFLaPoR8z5Oz15KqEpuhatELvBWTj
         Nw8oUAznb01PIEOuWGR4Yk+zJ5pASP75/b25uiR20sWcpz9MtXgY1o3KLCO4tK0NDI
         udJkH6f1QScyh9CaAJ+J6xPKePicxM7Qo4TobvTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Soenke Huster <shuster@seemoo.tu-darmstadt.de>,
        Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 43/54] wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
Date:   Thu, 13 Oct 2022 19:52:37 +0200
Message-Id: <20221013175148.379769517@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
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

commit aebe9f4639b13a1f4e9a6b42cdd2e38c617b442d upstream.

In the copy code of the elements, we do the following calculation
to reach the end of the MBSSID element:

	/* copy the IEs after MBSSID */
	cpy_len = mbssid[1] + 2;

This looks fine, however, cpy_len is a u8, the same as mbssid[1],
so the addition of two can overflow. In this case the subsequent
memcpy() will overflow the allocated buffer, since it copies 256
bytes too much due to the way the allocation and memcpy() sizes
are calculated.

Fix this by using size_t for the cpy_len variable.

This fixes CVE-2022-41674.

Reported-by: Soenke Huster <shuster@seemoo.tu-darmstadt.de>
Tested-by: Soenke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2228,7 +2228,7 @@ cfg80211_update_notlisted_nontrans(struc
 	size_t new_ie_len;
 	struct cfg80211_bss_ies *new_ies;
 	const struct cfg80211_bss_ies *old;
-	u8 cpy_len;
+	size_t cpy_len;
 
 	lockdep_assert_held(&wiphy_to_rdev(wiphy)->bss_lock);
 


