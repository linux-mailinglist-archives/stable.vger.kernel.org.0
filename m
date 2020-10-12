Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE328B6CC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbgJLNhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730995AbgJLNhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F8A620BED;
        Mon, 12 Oct 2020 13:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509804;
        bh=5VF1aGF0snDD0yIQKYYR3G5Txb5QXIRXjJ5xA2iuFLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIOR4vJgZt/7T/Y+4aMS8DG5ZpeQtkUNYAT1IGLzAuArxIFd2JdehvsOD+23JeKTF
         L+loU2IJB+ZujqGXl35GbXt/Yq4mb82yMcDwQh3WSHCg9eqZlKteGSG4SHd6zoHEFV
         EAOYPimWXbQSA4/vdQoyuDUO+1ETFNzoS1/3fGlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 36/70] net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
Date:   Mon, 12 Oct 2020 15:26:52 +0200
Message-Id: <20201012132631.914396871@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit 3dc289f8f139997f4e9d3cfccf8738f20d23e47b upstream.

In nl80211_parse_key(), key.idx is first initialized as -1.
If this value of key.idx remains unmodified and gets returned, and
nl80211_key_allowed() also returns 0, then rdev_del_key() gets called
with key.idx = -1.
This causes an out-of-bounds array access.

Handle this issue by checking if the value of key.idx after
nl80211_parse_key() is called and return -EINVAL if key.idx < 0.

Cc: stable@vger.kernel.org
Reported-by: syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com
Tested-by: syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201007035401.9522-1-anant.thazhemadam@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3343,6 +3343,9 @@ static int nl80211_del_key(struct sk_buf
 	if (err)
 		return err;
 
+	if (key.idx < 0)
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 


