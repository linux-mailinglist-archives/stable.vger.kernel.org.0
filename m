Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEEB5FE078
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiJMSKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiJMSJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EC1169CEE;
        Thu, 13 Oct 2022 11:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA8DE61A43;
        Thu, 13 Oct 2022 18:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8987C433C1;
        Thu, 13 Oct 2022 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684090;
        bh=yO7jB7qJ3SzvXbCw+6Kqc+Vb9MrWMZHZx+fu+glnvtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfHkS7CKbQBrvEwGykyecb9oLe7yLh8w26y95OjtWnKjZpvXmBqtYS/OVVGOHhx17
         MTLCjfAXzHEDoXJdi6gEvknz2c3MQ3H1+HSaUeSvqR7Udpypp+2Vh3va48ltYN22ip
         +cjoq0nyl0vp5w4deDEvRFUAjkA9EW9STkabe+3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Soenke Huster <shuster@seemoo.tu-darmstadt.de>,
        Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.0 21/34] wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
Date:   Thu, 13 Oct 2022 19:52:59 +0200
Message-Id: <20221013175147.067414219@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
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
@@ -2279,7 +2279,7 @@ cfg80211_update_notlisted_nontrans(struc
 	size_t new_ie_len;
 	struct cfg80211_bss_ies *new_ies;
 	const struct cfg80211_bss_ies *old;
-	u8 cpy_len;
+	size_t cpy_len;
 
 	lockdep_assert_held(&wiphy_to_rdev(wiphy)->bss_lock);
 


