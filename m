Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E391DD03D
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgEUOlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgEUOlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85411C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r18so5508889ybg.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=vlIJDldd4visG940M3hor2ICwbAxYfNa5BHUUV43nIc=;
        b=VRq/sliifhKDP6gvs8C7hmbzapP+zNSil+RqslP37o0t15WSh7ub2XMeyyQ0mdG7e2
         8Ex2saPFyeePGVyHnJ1BmIhF3FN07izh2Q98KaB+9Sa8y/Les/crDuyPlEd9WUGAoLig
         IBhe5hFal0o1UeAPTU3Bc7183VpFRdq5rL1k3unq4BRUWHrr3V7ZG0hI0gHlcqbQ4Zvm
         C4KlkAbunfwqwJFBt3p8KhOeXgwPm6amKz0ndwWhLwShQM1EHCwgRWsfr9GvghDEz9Th
         pxpTUXC7HSE3IdMmvlk2K7BJBXTH6QVOuoIl4v/sNwZTWFqwnORDFTxGqjYxHsOJEQRf
         dDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=vlIJDldd4visG940M3hor2ICwbAxYfNa5BHUUV43nIc=;
        b=dJpDp8uy1lh3xKpmrGVKm9air1uXujLYhnUOo+xS4but2vcB3GsCHT1AjIqSpT136G
         GuhcrcZPtwvf+tGE1RUeNQwGjiR5u9FW9vt9DWyhNxNG8YfXBAH/aYRielQT6phBnJdq
         /k/hFCraCGkMqJ1oNit2Fn34jSk2F+4GXSwlOVwt+BwhAS7XLUoIK5rkbAcOzia9VMfg
         c/9wIRIir1xmxUPTcDgTAdMdZZKmdu5/lbIfqCBK08r4nZtTJ2TfnGX3Fuk6hcZS2on/
         Pz4fTZOnoy3AtK+yH0kqcHNwcaAKRKkcFOctIwbIn4oEuHGASUGPQ1YxTiDmfkhiaxkQ
         B62w==
X-Gm-Message-State: AOAM531HMHVPVevoNWMaZCUvfica7udvwIdReW+AUyV5AvRJcms5yc0o
        Onnpq3Ei6pzeoI/V8o8xCpjgU3xXzMqvvg==
X-Google-Smtp-Source: ABdhPJzw0UkJ+EyHoLggGCuiyli+oN5zeZzd5V/N2uCgcCM0k791zVlw3L83/MZZkn7o43BnNG0QqJ2Pz8qX4g==
X-Received: by 2002:a25:f206:: with SMTP id i6mr16195095ybe.415.1590072071794;
 Thu, 21 May 2020 07:41:11 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:39 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-2-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 01/22] net: l2tp: export debug flags to UAPI
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
2.26.2.761.g0e0b3e54be-goog

