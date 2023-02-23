Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F156A07CC
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbjBWLyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbjBWLyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:54:10 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D935928D2A
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:54:04 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id eg35-20020a05640228a300b004ad6e399b73so13692034edb.10
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=td1YUBJ9Xy17Ao0yXyrts3oObTRLSjz6Au98Jd+MF6w=;
        b=nqG0bfUFR7NI6wUr5Hd5GxJgRgQD+sGUwKfng3kf5pLU5YCjQ0/ueVwjGkgMB8mUPN
         tEy7o0faFercAF+u2ti0qobJWc5/RvZKQD4Fl2hlSP8Iius9FQO9bqEH0OogDDiRsO+N
         OHX4r3xUJ7wnwhaR5U+3Q5uPomox8pmTrG0f6vl51CMCbzg1c/YsHBtc9pnjCUzgGlUs
         Lp/Y/qTJuY+8UBobVr7cdnzit328B6HifA5p9y86WpdXvt6+SUK8yTcmyoQM8Ns1qHkE
         j3D55T64Am2T/iM6gbvaga/S85svOBQ8uqOtFxRPzZcb1Tg6ytpg4JiioIZ+pCxyNVAb
         wy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=td1YUBJ9Xy17Ao0yXyrts3oObTRLSjz6Au98Jd+MF6w=;
        b=cTQM5dlwHzYtTjPI5vb6hxA+cmufFgRZum49WV7s6JKFMmxGK6TWgOaQ63UFH1EmYl
         m3tFR+zjh5xFqHj3CtbOMiKvD+E8dxt1vsaAiBiOnILHRd+4Nweh4iRoGn5YUwueIfeM
         iX+KUUjkiVw1zmT+Md+i3Bve6+VC1mFVAX+jdrsLfN5MTatskxzz97eW494G9+O+ZotM
         rAylrcCCz66izr+modmqSxPc+r4Sz4v7V/FE+qPeZ+Dq/S8I39RmduIkAASKdX2wcxV/
         /8zM5a3uXTLX3d8qpEuKHOnCI+OVlRaF6aQwWYuJlf/jsxcsJAKSHjs11dT8KbGtkz0N
         qvsA==
X-Gm-Message-State: AO0yUKXC2scDvHJ5BaLzom4bmg9wrjpYXQeLFcuntNTXgXQhdl+G3SRV
        7I/phyaI1y/Xwbhevny2QTQjI98SDTbMgg==
X-Google-Smtp-Source: AK7set+ytwsc4AdAQs+yRSblVc6pkY8uQ6HKqEmqM42lwZWX19F1h5Mb8Hb0LSMBlW4BzARFHZSzRRaAXKe7pQ==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:cf33:dc28:3e98:f5e9])
 (user=maennich job=sendgmr) by 2002:a17:907:2071:b0:8e5:411d:4d09 with SMTP
 id qp17-20020a170907207100b008e5411d4d09mr2855387ejb.15.1677153243389; Thu,
 23 Feb 2023 03:54:03 -0800 (PST)
Date:   Thu, 23 Feb 2023 11:53:50 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230223115351.1241401-4-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH v5.15 v2 3/4] lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 6323c81350b73a4569cf52df85f80273faa64071 ]

Now that CONFIG_PAHOLE_VERSION exists, use it in the definition of
CONFIG_PAHOLE_HAS_SPLIT_BTF and CONFIG_PAHOLE_HAS_BTF_TAG to reduce the
amount of duplication across the tree.

Change-Id: Ie5ba17d96688dbcc385a9804ed96a59bda7a40df
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-5-nathan@kernel.org
[maennich: omitted patching non-existing config PAHOLE_HAS_BTF_TAG]
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f71db0cc3bf1..944fd2ae756b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -328,7 +328,7 @@ config DEBUG_INFO_BTF
 	  DWARF type info into equivalent deduplicated BTF type info.
 
 config PAHOLE_HAS_SPLIT_BTF
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
+	def_bool PAHOLE_VERSION >= 119
 
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
-- 
2.39.2.637.g21b0678d19-goog

