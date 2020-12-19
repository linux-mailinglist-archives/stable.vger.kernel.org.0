Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F472DEF5F
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLSM6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgLSM6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:50 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9d39fa49d4df294aab93@syzkaller.appspotmail.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 22/49] ethtool: fix stack overflow in ethnl_parse_bitset()
Date:   Sat, 19 Dec 2020 13:58:26 +0100
Message-Id: <20201219125345.771146133@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit a770bf515613c6e12ae904c3593e26016de99448 ]

Syzbot reported a stack overflow in bitmap_from_arr32() called from
ethnl_parse_bitset() when bitset from netlink message is longer than
target bitmap length. While ethnl_compact_sanity_checks() makes sure that
trailing part is all zeros (i.e. the request does not try to touch bits
kernel does not recognize), we also need to cap change_bits to nbits so
that we don't try to write past the prepared bitmaps.

Fixes: 88db6d1e4f62 ("ethtool: add ethnl_parse_bitset() helper")
Reported-by: syzbot+9d39fa49d4df294aab93@syzkaller.appspotmail.com
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/r/3487ee3a98e14cd526f55b6caaa959d2dcbcad9f.1607465316.git.mkubecek@suse.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/bitset.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -630,6 +630,8 @@ int ethnl_parse_bitset(unsigned long *va
 			return ret;
 
 		change_bits = nla_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
+		if (change_bits > nbits)
+			change_bits = nbits;
 		bitmap_from_arr32(val, nla_data(tb[ETHTOOL_A_BITSET_VALUE]),
 				  change_bits);
 		if (change_bits < nbits)


