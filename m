Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF618259752
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731195AbgIAPfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731182AbgIAPfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEEA20866;
        Tue,  1 Sep 2020 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974521;
        bh=bvWFV2a4Kqn7UBOT2pn4bMdej+uDUFfTkyG2Rh/G8RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0bVnkKBs/gsH08lcKSh2U2do/uqs4Z1c6zcEfK6jwAuW1Y+W+JlVnIuuMrfcUiqY
         TBiszAR8jlEQY0p1dhdaGHaRksBVnk1H1zkX3u4ER/RwvdZDPRFDgI1V6bEHvxKDnf
         PB0NmyNne59vqdvBTu+i3gUNFhJeJhhWwQhsbPIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.4 209/214] kheaders: explain why include/config/autoconf.h is excluded from md5sum
Date:   Tue,  1 Sep 2020 17:11:29 +0200
Message-Id: <20200901151002.938717565@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit f276031b4e2f4c961ed6d8a42f0f0124ccac2e09 upstream.

This comment block explains why include/generated/compile.h is omitted,
but nothing about include/generated/autoconf.h, which might be more
difficult to understand. Add more comments.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/gen_kheaders.sh |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -32,8 +32,15 @@ fi
 all_dirs="$all_dirs $dir_list"
 
 # include/generated/compile.h is ignored because it is touched even when none
-# of the source files changed. This causes pointless regeneration, so let us
-# ignore them for md5 calculation.
+# of the source files changed.
+#
+# When Kconfig regenerates include/generated/autoconf.h, its timestamp is
+# updated, but the contents might be still the same. When any CONFIG option is
+# changed, Kconfig touches the corresponding timestamp file include/config/*.h.
+# Hence, the md5sum detects the configuration change anyway. We do not need to
+# check include/generated/autoconf.h explicitly.
+#
+# Ignore them for md5 calculation to avoid pointless regeneration.
 headers_md5="$(find $all_dirs -name "*.h"			|
 		grep -v "include/generated/compile.h"	|
 		grep -v "include/generated/autoconf.h"	|


