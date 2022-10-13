Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6165FDFCE
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiJMR60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiJMR5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:57:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AB0F58E;
        Thu, 13 Oct 2022 10:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4842B82040;
        Thu, 13 Oct 2022 17:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC816C43140;
        Thu, 13 Oct 2022 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683820;
        bh=CK8zW69mYsVe631d9uSwXr4sBV2nDL15Y8aevweb+n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mngPvIZLNidfc/yUF1Qo87PG8nOSaXyIHfXQDP+2DOmwn6rSTtgt0FyUKwlalzCsd
         cBFBtYHUGlK2u9NNXjw6rsox1KE0IgA1slnB42g8xlNBPibdQAlRjl0D1BXz52Ngfz
         4y+4RvDCSA7WsDNEB77FpvvA85mW6zq3cWXoXuHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 47/54] wifi: cfg80211: avoid nontransmitted BSS list corruption
Date:   Thu, 13 Oct 2022 19:52:41 +0200
Message-Id: <20221013175148.476986632@linuxfoundation.org>
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
@@ -425,6 +425,15 @@ cfg80211_add_nontrans_list(struct cfg802
 
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


