Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A025F396011
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhEaOWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232171AbhEaOQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D37619AB;
        Mon, 31 May 2021 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468598;
        bh=hqjHEKA1VFp8vfRcd3TJbg14kJYkSHRd9WCLyH65Z3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQ/Zr6Ke1hyIGqnDs0iqPMm5TjqbaOnZrH7SW3GU+Er0dtbg1NG31G5b738dIxV8l
         Py+RaqwYkZZqEX3Rid2v7uKeZd4og8A1Frmn4bmNXLHZkc8M89qwuPTzfC+axmVILo
         DSIIS3T1xGpk4GgM/LjWydoLqEL8aMfIQUmJDX9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 017/177] cfg80211: mitigate A-MSDU aggregation attacks
Date:   Mon, 31 May 2021 15:12:54 +0200
Message-Id: <20210531130648.512596218@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -681,6 +681,9 @@ void ieee80211_amsdu_to_8023s(struct sk_
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
 			goto purge;
+		/* mitigate A-MSDU aggregation injection attacks */
+		if (ether_addr_equal(eth.h_dest, rfc1042_header))
+			goto purge;
 
 		offset += sizeof(struct ethhdr);
 		last = remaining <= subframe_len + padding;


