Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8065FE07C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiJMSKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiJMSKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393B15625F;
        Thu, 13 Oct 2022 11:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EABC86192E;
        Thu, 13 Oct 2022 18:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03451C433D7;
        Thu, 13 Oct 2022 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684104;
        bh=SsMZnV5IRg+VfGQh81XQuLjXEJU1N9vepNOsf1+r8VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLTonID16sFXFtCymOfbq00eVFbCSXG9GqGBc8P0DmoqgYo0qPc8kFVgNUse+LTrb
         bEEqmEYPzLBDkYL7yGCvQs3GwrkVYETh2AFH2bOZKdFywcfDlDeeIMV80w/ymgHHlb
         S3uaz0CEhaBKJ26gc6PplqiINoic819laNuMvu/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.0 26/34] wifi: cfg80211: avoid nontransmitted BSS list corruption
Date:   Thu, 13 Oct 2022 19:53:04 +0200
Message-Id: <20221013175147.193301522@linuxfoundation.org>
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

commit bcca852027e5878aec911a347407ecc88d6fff7f upstream.

If a non-transmitted BSS shares enough information (both
SSID and BSSID!) with another non-transmitted BSS of a
different AP, then we can find and update it, and then
try to add it to the non-transmitted BSS list. We do a
search for it on the transmitted BSS, but if it's not
there (but belongs to another transmitted BSS), the list
gets corrupted.

Since this is an erroneous situation, simply fail the
list insertion in this case and free the non-transmitted
BSS.

This fixes CVE-2022-42721.

Reported-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -423,6 +423,15 @@ cfg80211_add_nontrans_list(struct cfg802
 
 	rcu_read_unlock();
 
+	/*
+	 * This is a bit weird - it's not on the list, but already on another
+	 * one! The only way that could happen is if there's some BSSID/SSID
+	 * shared by multiple APs in their multi-BSSID profiles, potentially
+	 * with hidden SSID mixed in ... ignore it.
+	 */
+	if (!list_empty(&nontrans_bss->nontrans_list))
+		return -EINVAL;
+
 	/* add to the list */
 	list_add_tail(&nontrans_bss->nontrans_list, &trans_bss->nontrans_list);
 	return 0;


