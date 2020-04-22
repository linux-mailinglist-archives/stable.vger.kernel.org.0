Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBEB1B4102
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgDVKtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgDVKNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C218E2077D;
        Wed, 22 Apr 2020 10:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550381;
        bh=5NMuyZWCmZliclrYSh0KvOo0b4ZlLH5yjLm2O9vAJtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M89UoZFSAw8TUlBcV4WmEXNM006fTbFfdp+jbQGEzUkkoAnj45VIGubgHSzo9xKkN
         +fdtIVl88br9+Gmdm3WFhl8rlxzfzPbJ4UnBbyd1UysPIGb2SPOWqpHf5cBTbjv6VC
         UlDYdXr+ngl9lN2n1LIlC4vN7mqSOHOZzEdGAe1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6693adf1698864d21734@syzkaller.appspotmail.com,
        syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com,
        stable@kernel.org, Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 123/199] mac80211_hwsim: Use kstrndup() in place of kasprintf()
Date:   Wed, 22 Apr 2020 11:57:29 +0200
Message-Id: <20200422095109.817494465@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

commit 7ea862048317aa76d0f22334202779a25530980c upstream.

syzbot reports a warning:

precision 33020 too large
WARNING: CPU: 0 PID: 9618 at lib/vsprintf.c:2471 set_precision+0x150/0x180 lib/vsprintf.c:2471
 vsnprintf+0xa7b/0x19a0 lib/vsprintf.c:2547
 kvasprintf+0xb2/0x170 lib/kasprintf.c:22
 kasprintf+0xbb/0xf0 lib/kasprintf.c:59
 hwsim_del_radio_nl+0x63a/0x7e0 drivers/net/wireless/mac80211_hwsim.c:3625
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 ...
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Thus it seems that kasprintf() with "%.*s" format can not be used for
duplicating a string with arbitrary length. Replace it with kstrndup().

Note that later this string is limited to NL80211_WIPHY_NAME_MAXLEN == 64,
but the code is simpler this way.

Reported-by: syzbot+6693adf1698864d21734@syzkaller.appspotmail.com
Reported-by: syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com
Cc: stable@kernel.org
Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Link: https://lore.kernel.org/r/20200410123257.14559-1-tuomas.tynkkynen@iki.fi
[johannes: add note about length limit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mac80211_hwsim.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3134,9 +3134,9 @@ static int hwsim_new_radio_nl(struct sk_
 		param.no_vif = true;
 
 	if (info->attrs[HWSIM_ATTR_RADIO_NAME]) {
-		hwname = kasprintf(GFP_KERNEL, "%.*s",
-				   nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
-				   (char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]));
+		hwname = kstrndup((char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  GFP_KERNEL);
 		if (!hwname)
 			return -ENOMEM;
 		param.hwname = hwname;
@@ -3175,9 +3175,9 @@ static int hwsim_del_radio_nl(struct sk_
 	if (info->attrs[HWSIM_ATTR_RADIO_ID]) {
 		idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
 	} else if (info->attrs[HWSIM_ATTR_RADIO_NAME]) {
-		hwname = kasprintf(GFP_KERNEL, "%.*s",
-				   nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
-				   (char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]));
+		hwname = kstrndup((char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  GFP_KERNEL);
 		if (!hwname)
 			return -ENOMEM;
 	} else


