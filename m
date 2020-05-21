Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D691DDB20
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgEUXjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:39:47 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98356C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:47 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 19so9680807qtp.8
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=krsDlQ6qx5PkK3NDZqNCeEPpgBEpikLUWKTXMu7x+0w=;
        b=NEvN3AxRTyacDAi0XY+OKuE2ZwgZlqz/V9zcpNC9fdbxJLZnTymD5qnbQs3JaBI+oF
         zwNlyarncg7L/c24XzIIO/T6C+IgwxmZD3KI13piwohVSBmaRkjPw2zGpGmEn4ChWbk7
         Oxj4nCBehGQkVgpe3VNKmhpPnolbcbtije0z7GJNh82MpbKlAzfHafgQm6kjlnSnC3GN
         UcbhA8NqhwgjMTJIAxqc/fI9oAeMd9wzn9NxTzmoCiV2ZawPbodibyDa7ThbjeRnA09I
         q4XM+fHB2hPk9G2X1IKhukv9URCk3Wn8lzHaXGB3KNfRHLLgsmf/wAbfUhooB3m3uPN1
         zMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=krsDlQ6qx5PkK3NDZqNCeEPpgBEpikLUWKTXMu7x+0w=;
        b=UwPk3TnbvS1BJUeZPFvHzJt0M3uZ3TBNRmVU/qyx/5KSypLLnC91YlXLB9iXnTiGN4
         9NYiYvlPKivjfxAQj5KIOHro6ipBhW9/90GV9Z+gmgRm33r8cEELt+6pbwOlY6hPu8TC
         hbfjyKv4AWwbHRQRFNfsa1f/ua65MSY9geFhtWs+4LwXbIlrjtrqVtDkDEPvbz3Mw1t2
         ny5dKUQIim+Ud/4ij74QZyv2amPqwrNJbxBOFeHf2KlSjZECv039+eB3yWnwCssmJFzK
         4rPlOb2Ol4pVFoVpwHse5fXrWfiPjbLPDte7TSe51XEOZmWr14ZdE0YPFF12pULBAwHG
         Ypkg==
X-Gm-Message-State: AOAM530fhtYCWuYhuxn7hD/3KX5b1kT2uLOrEAcPED4C7hrXywYbvFFn
        Izl6CL6+07dkmpFvD8RrVK/J4GxDny+yQQ==
X-Google-Smtp-Source: ABdhPJwIC5kHKRmtwhJM3Y+XC4pu1Z4+Sgv9t9tj/elczDrYv3UHJkkt4GUC4Cthuc7fY+BsM1BrJIa8hgyzug==
X-Received: by 2002:a0c:fde4:: with SMTP id m4mr1163673qvu.207.1590104386699;
 Thu, 21 May 2020 16:39:46 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:16 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-2-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 01/22] net: l2tp: export debug flags to UAPI
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org,
        "=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=" 
        <asbjorn@asbjorn.st>, "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asbj=C3=B8rn Sloth T=C3=B8nnesen <asbjorn@asbjorn.st>

commit 41c43fbee68f4f9a2a9675d83bca91c77862d7f0 upstream.

Move the L2TP_MSG_* definitions to UAPI, as it is part of
the netlink API.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 include/uapi/linux/l2tp.h | 17 ++++++++++++++++-
 net/l2tp/l2tp_core.h      | 10 ----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index 4bd27d0270a2..bb2d62037037 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -108,7 +108,7 @@ enum {
 	L2TP_ATTR_VLAN_ID,		/* u16 */
 	L2TP_ATTR_COOKIE,		/* 0, 4 or 8 bytes */
 	L2TP_ATTR_PEER_COOKIE,		/* 0, 4 or 8 bytes */
-	L2TP_ATTR_DEBUG,		/* u32 */
+	L2TP_ATTR_DEBUG,		/* u32, enum l2tp_debug_flags */
 	L2TP_ATTR_RECV_SEQ,		/* u8 */
 	L2TP_ATTR_SEND_SEQ,		/* u8 */
 	L2TP_ATTR_LNS_MODE,		/* u8 */
@@ -175,6 +175,21 @@ enum l2tp_seqmode {
 	L2TP_SEQ_ALL =3D 2,
 };
=20
+/**
+ * enum l2tp_debug_flags - debug message categories for L2TP tunnels/sessi=
ons
+ *
+ * @L2TP_MSG_DEBUG: verbose debug (if compiled in)
+ * @L2TP_MSG_CONTROL: userspace - kernel interface
+ * @L2TP_MSG_SEQ: sequence numbers
+ * @L2TP_MSG_DATA: data packets
+ */
+enum l2tp_debug_flags {
+	L2TP_MSG_DEBUG		=3D (1 << 0),
+	L2TP_MSG_CONTROL	=3D (1 << 1),
+	L2TP_MSG_SEQ		=3D (1 << 2),
+	L2TP_MSG_DATA		=3D (1 << 3),
+};
+
 /*
  * NETLINK_GENERIC related info
  */
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 7c2037184b6c..092698a8f74b 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -23,16 +23,6 @@
 #define L2TP_HASH_BITS_2	8
 #define L2TP_HASH_SIZE_2	(1 << L2TP_HASH_BITS_2)
=20
-/* Debug message categories for the DEBUG socket option */
-enum {
-	L2TP_MSG_DEBUG		=3D (1 << 0),	/* verbose debug (if
-						 * compiled in) */
-	L2TP_MSG_CONTROL	=3D (1 << 1),	/* userspace - kernel
-						 * interface */
-	L2TP_MSG_SEQ		=3D (1 << 2),	/* sequence numbers */
-	L2TP_MSG_DATA		=3D (1 << 3),	/* data packets */
-};
-
 struct sk_buff;
=20
 struct l2tp_stats {
--=20
2.27.0.rc0.183.gde8f92d652-goog

