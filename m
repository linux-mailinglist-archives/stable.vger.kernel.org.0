Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A6423A5D1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgHCMbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbgHCMbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:31:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B9FE2054F;
        Mon,  3 Aug 2020 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457874;
        bh=x4UMX5p252GYrKJ/aCarb85LZB57EhVLYClq7cIfOP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7tQ9/OMrZZc+2C6DnNwudVlWueJdnzsTdaJUJ9t52mjwyHs3roGrePL3xSEp59Em
         xD8g99Bq0VonnGAmnsEKLyGXEzBzt2lj5WwNLKauy94DPeTVzFTLDWhYCov8UU4vaa
         C9bTNNg6cc50lY1D+g5Z4d8/0lfHz9LLaRq8V800=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 14/56] wireless: Use offsetof instead of custom macro.
Date:   Mon,  3 Aug 2020 14:19:29 +0200
Message-Id: <20200803121851.023714217@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

commit 6989310f5d4327e8595664954edd40a7f99ddd0d upstream.

Use offsetof to calculate offset of a field to take advantage of
compiler built-in version when possible, and avoid UBSAN warning when
compiling with Clang:

==================================================================
UBSAN: Undefined behaviour in net/wireless/wext-core.c:525:14
member access within null pointer of type 'struct iw_point'
CPU: 3 PID: 165 Comm: kworker/u16:3 Tainted: G S      W         4.19.23 #43
Workqueue: cfg80211 __cfg80211_scan_done [cfg80211]
Call trace:
 dump_backtrace+0x0/0x194
 show_stack+0x20/0x2c
 __dump_stack+0x20/0x28
 dump_stack+0x70/0x94
 ubsan_epilogue+0x14/0x44
 ubsan_type_mismatch_common+0xf4/0xfc
 __ubsan_handle_type_mismatch_v1+0x34/0x54
 wireless_send_event+0x3cc/0x470
 ___cfg80211_scan_done+0x13c/0x220 [cfg80211]
 __cfg80211_scan_done+0x28/0x34 [cfg80211]
 process_one_work+0x170/0x35c
 worker_thread+0x254/0x380
 kthread+0x13c/0x158
 ret_from_fork+0x10/0x18
===================================================================

Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20191204081307.138765-1-pihsun@chromium.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/wireless.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/wireless.h
+++ b/include/uapi/linux/wireless.h
@@ -74,6 +74,8 @@
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/if.h>			/* for IFNAMSIZ and co... */
 
+#include <stddef.h>                     /* for offsetof */
+
 /***************************** VERSION *****************************/
 /*
  * This constant is used to know the availability of the wireless
@@ -1090,8 +1092,7 @@ struct iw_event {
 /* iw_point events are special. First, the payload (extra data) come at
  * the end of the event, so they are bigger than IW_EV_POINT_LEN. Second,
  * we omit the pointer, so start at an offset. */
-#define IW_EV_POINT_OFF (((char *) &(((struct iw_point *) NULL)->length)) - \
-			  (char *) NULL)
+#define IW_EV_POINT_OFF offsetof(struct iw_point, length)
 #define IW_EV_POINT_LEN	(IW_EV_LCP_LEN + sizeof(struct iw_point) - \
 			 IW_EV_POINT_OFF)
 


