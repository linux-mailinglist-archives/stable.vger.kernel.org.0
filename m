Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9FD3968F6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhEaUda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhEaUdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:33:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2997FC061761;
        Mon, 31 May 2021 13:31:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoZX-000FBv-B6; Mon, 31 May 2021 22:31:39 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Subject: [PATCH v4.14 04/10] cfg80211: mitigate A-MSDU aggregation attacks
Date:   Mon, 31 May 2021 22:31:29 +0200
Message-Id: <20210531203135.180427-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531203135.180427-1-johannes@sipsolutions.net>
References: <20210531203135.180427-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

commit 2b8a1fee3488c602aca8bea004a087e60806a5cf upstream.

Mitigate A-MSDU injection attacks (CVE-2020-24588) by detecting if the
destination address of a subframe equals an RFC1042 (i.e., LLC/SNAP)
header, and if so dropping the complete A-MSDU frame. This mitigates
known attacks, although new (unknown) aggregation-based attacks may
remain possible.

This defense works because in A-MSDU aggregation injection attacks, a
normal encrypted Wi-Fi frame is turned into an A-MSDU frame. This means
the first 6 bytes of the first A-MSDU subframe correspond to an RFC1042
header. In other words, the destination MAC address of the first A-MSDU
subframe contains the start of an RFC1042 header during an aggregation
attack. We can detect this and thereby prevent this specific attack.
For details, see Section 7.2 of "Fragment and Forge: Breaking Wi-Fi
Through Frame Aggregation and Fragmentation".

Note that for kernel 4.9 and above this patch depends on "mac80211:
properly handle A-MSDUs that start with a rfc1042 header". Otherwise
this patch has no impact and attacks will remain possible.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20210511200110.25d93176ddaf.I9e265b597f2cd23eb44573f35b625947b386a9de@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2aef1c487be6..b3895a8a48ab 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -768,6 +768,9 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
 			goto purge;
+		/* mitigate A-MSDU aggregation injection attacks */
+		if (ether_addr_equal(eth.h_dest, rfc1042_header))
+			goto purge;
 
 		offset += sizeof(struct ethhdr);
 		last = remaining <= subframe_len + padding;
-- 
2.31.1

