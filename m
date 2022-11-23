Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2564635755
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiKWJlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiKWJlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE34128E32
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:38:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 698B361B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DC3C433D6;
        Wed, 23 Nov 2022 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196303;
        bh=sA41tFFKBDDhAGEMirpc2D2Fcw/aIZdFOBNHE5PNnGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI54zCp+vOWAfwfEu8yNEaM4J+b5xlX1QkU09W4Dte2K67IKnag0kWCH2++oIaj1F
         4izffI1ihSn/e85xq9/kpPMGh3t8cryEhFPzag0/725F0tpR3yIEYw6fcm5hMkJNMf
         aLEn92wFdr8Xgp+kr9AVmJdy+sz8UzyNJ5++z4bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        Hawkins Jiawei <yin31149@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
Subject: [PATCH 5.15 176/181] wifi: wext: use flex array destination for memcpy()
Date:   Wed, 23 Nov 2022 09:52:19 +0100
Message-Id: <20221123084609.949318027@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Hawkins Jiawei <yin31149@gmail.com>

commit e3e6e1d16a4cf7b63159ec71774e822194071954 upstream.

Syzkaller reports buffer overflow false positive as follows:
------------[ cut here ]------------
memcpy: detected field-spanning write (size 8) of single field
	"&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623
	wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
Modules linked in:
CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted
	6.0.0-rc6-next-20220921-syzkaller #0
[...]
Call Trace:
 <TASK>
 ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
 wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
 sock_ioctl+0x285/0x640 net/socket.c:1220
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>

Wireless events will be sent on the appropriate channels in
wireless_send_event(). Different wireless events may have different
payload structure and size, so kernel uses **len** and **cmd** field
in struct __compat_iw_event as wireless event common LCP part, uses
**pointer** as a label to mark the position of remaining different part.

Yet the problem is that, **pointer** is a compat_caddr_t type, which may
be smaller than the relative structure at the same position. So during
wireless_send_event() tries to parse the wireless events payload, it may
trigger the memcpy() run-time destination buffer bounds checking when the
relative structure's data is copied to the position marked by **pointer**.

This patch solves it by introducing flexible-array field **ptr_bytes**,
to mark the position of the wireless events remaining part next to
LCP part. What's more, this patch also adds **ptr_len** variable in
wireless_send_event() to improve its maintainability.

Reported-and-tested-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/00000000000070db2005e95a5984@google.com/
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/wireless.h |   10 +++++++++-
 net/wireless/wext-core.c |   17 ++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -26,7 +26,15 @@ struct compat_iw_point {
 struct __compat_iw_event {
 	__u16		len;			/* Real length of this stuff */
 	__u16		cmd;			/* Wireless IOCTL */
-	compat_caddr_t	pointer;
+
+	union {
+		compat_caddr_t	pointer;
+
+		/* we need ptr_bytes to make memcpy() run-time destination
+		 * buffer bounds checking happy, nothing special
+		 */
+		DECLARE_FLEX_ARRAY(__u8, ptr_bytes);
+	};
 };
 #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
 #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -468,6 +468,7 @@ void wireless_send_event(struct net_devi
 	struct __compat_iw_event *compat_event;
 	struct compat_iw_point compat_wrqu;
 	struct sk_buff *compskb;
+	int ptr_len;
 #endif
 
 	/*
@@ -582,6 +583,9 @@ void wireless_send_event(struct net_devi
 	nlmsg_end(skb, nlh);
 #ifdef CONFIG_COMPAT
 	hdr_len = compat_event_type_size[descr->header_type];
+
+	/* ptr_len is remaining size in event header apart from LCP */
+	ptr_len = hdr_len - IW_EV_COMPAT_LCP_LEN;
 	event_len = hdr_len + extra_len;
 
 	compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
@@ -612,16 +616,15 @@ void wireless_send_event(struct net_devi
 	if (descr->header_type == IW_HEADER_TYPE_POINT) {
 		compat_wrqu.length = wrqu->data.length;
 		compat_wrqu.flags = wrqu->data.flags;
-		memcpy(&compat_event->pointer,
-			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes,
+		       ((char *)&compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
+			ptr_len);
 		if (extra_len)
-			memcpy(((char *) compat_event) + hdr_len,
-				extra, extra_len);
+			memcpy(&compat_event->ptr_bytes[ptr_len],
+			       extra, extra_len);
 	} else {
 		/* extra_len must be zero, so no if (extra) needed */
-		memcpy(&compat_event->pointer, wrqu,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
 	}
 
 	nlmsg_end(compskb, nlh);


