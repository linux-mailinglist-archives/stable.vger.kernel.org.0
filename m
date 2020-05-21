Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A001DDB6A
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgEUX6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:07 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F066C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:06 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id a14so9697489qto.6
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=v0p5GMXDmPiGkCVrY6DBppPjiKqeNNXvxIVNJw0fSqk=;
        b=WGltLF/y9bqaSwrejn9AfP1lWgzIkDnGFxa+fwWsR6vAFu0Bm4is4uJz+Rc/PwvXTc
         BegSno12Y+mb41/WVENl0wT3d3Dr5stGGY91J0Zrmm+PHS9xauXtcXFmk50ygWkgC/ZY
         kEx8f7OapnEBdBzqFEgVrfDvWJxuwTuBPHPQ7f0M1OwDqKjCcucgFd8WFkkeEwPx/tA9
         WpGCACpKB0Cc1ZY/oOwNBEKSGYN22AGayFFvOk1JUKj997OcLPn9i4Cw9zJ/bLGfLWqH
         zAJWqzxh6rEvVWTFOkAYA8K8AZBH4/BP9q9KT0aM/S7A9Kza0bjUTvCap4qbzeIT7OXo
         FIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=v0p5GMXDmPiGkCVrY6DBppPjiKqeNNXvxIVNJw0fSqk=;
        b=Xzsjrf2Kg5d5VDo+WXncODIiroxY9zBzL8lPP4MxsxhWcgZDs6tBbSDF1l1Noin9bX
         06OlZ10Htx516iiAJyQrzwchzk+914dyO8ea1cqTh3rWzdPE6JakfLfCBcykjmAMaaUo
         Q8uP8j+JQrPkVYGjudWcu0MXVvGKRD/JFDdA9an7rT4E1Vxhw9RjCm6X6LfDY+IC/TLn
         lVZ8WI3LR2S5N/SdUu+AqDasHRCTSXp0LJTpQfLH2LNPtAr8DbdVjylbRHEqch9dlENR
         Oeb3dGvLOgrTj3sYP2q20weP7L+WyFVJkynlq39vOmNkHWQwtWRmjF6Vu4OqW3wBMX66
         eOMw==
X-Gm-Message-State: AOAM530D70bkHOWy6ZUslBsx0eJK8wr4NM8Tl8eDpAkUUG6TOzbL4aKM
        oD/Py6sX36dnYHSFBjXYj9NRpe5OvwAzhQ==
X-Google-Smtp-Source: ABdhPJx5IUdIm8TZsVdfiYLo4rP5os52DxNxEiVzDtIFms069/HkE/XLLOOWeMvAs2JmHKL9PV6r7AwGM+cgMA==
X-Received: by 2002:a05:6214:526:: with SMTP id x6mr1267635qvw.15.1590105485470;
 Thu, 21 May 2020 16:58:05 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:19 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-7-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 06/27] net: l2tp: export debug flags to UAPI
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
index 347ef22a964e..dedfb2b1832a 100644
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
@@ -173,6 +173,21 @@ enum l2tp_seqmode {
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
index ee59d9961d1f..2469f63649bb 100644
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

