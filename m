Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F1D643330
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiLETe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiLETec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A523539E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:30:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8DE612D8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9A2C433C1;
        Mon,  5 Dec 2022 19:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268600;
        bh=dWgjHwVtLWfUTHhENSWV7MwI89aTYakMCqRYgn6doXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TA+BlrGojUalIiEalOcFDYZy556vYLTpoJHFtLwBFvI5hRoPOpoxWet6LX2LASwRa
         FFMRkC8m/i5FcfoCU0v6d9c7XOtj7EMaonANOH8a4XxAvknOScPA/TtA8yi0KhelKJ
         ceJgHkkzzRMHeOC6OtoQ2TFrUYFA0x2gpUIzik4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>
Subject: [PATCH 5.10 36/92] wifi: cfg80211: fix buffer overflow in elem comparison
Date:   Mon,  5 Dec 2022 20:09:49 +0100
Message-Id: <20221205190804.657087074@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

[ Upstream commit 9f16b5c82a025cd4c864737409234ddc44fb166a ]

For vendor elements, the code here assumes that 5 octets
are present without checking. Since the element itself is
already checked to fit, we only need to check the length.

Reported-and-tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 15119c49c093..8102ee7b2047 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -330,7 +330,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 			 * determine if they are the same ie.
 			 */
 			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
-				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+				if (tmp_old[1] >= 5 && tmp[1] >= 5 &&
+				    !memcmp(tmp_old + 2, tmp + 2, 5)) {
 					/* same vendor ie, copy from
 					 * subelement
 					 */
-- 
2.35.1



