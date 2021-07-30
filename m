Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F8B3DB328
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhG3GGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:06:14 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:48262 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhG3GGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 02:06:13 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 16U65wPi016588; Fri, 30 Jul 2021 15:05:58 +0900
X-Iguazu-Qid: 2wHI1WtxBs3emqi1J9
X-Iguazu-QSIG: v=2; s=0; t=1627625158; q=2wHI1WtxBs3emqi1J9; m=eZJfxFr76tO++OS5wcPR6gyPkRjdrdoJeFZyrgoajUY=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1110) id 16U65vWB032243
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 15:05:58 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id D3165100137;
        Fri, 30 Jul 2021 15:05:57 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 16U65v8M000740;
        Fri, 30 Jul 2021 15:05:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9
Date:   Fri, 30 Jul 2021 15:05:21 +0900
X-TSB-HOP: ON
Message-Id: <20210730060521.342390-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is a patch series to CVE-2021-21781.
The patch 9c698bff66ab ("RM: ensure the signal page contains defined
contents") depepds on memset32. However, this function is not provided
in 4.4 and 4.9. Therefore, we need the patch 3b3c4babd898 ("lib/string.c:
add multibyte memset functions") to apply this feature.
Another option is to implement only the memset32 function in
arch/arm/kernel/signal.c only or using loop memset, but for simplicity
we have taken the way of applying the original patch 3b3c4babd898
("lib/string.c: add multibyte memset functions") that provides memset32
in mainline kernel.

Best regards,
     Nobuhiro

Matthew Wilcox (1):
  lib/string.c: add multibyte memset functions

Russell King (1):
  ARM: ensure the signal page contains defined contents

 arch/arm/kernel/signal.c | 14 +++++----
 include/linux/string.h   | 30 ++++++++++++++++++
 lib/string.c             | 66 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 6 deletions(-)

-- 
2.32.0

From 97cc3a4817c982954ff69355d2577a92bddbad4a Mon Sep 17 00:00:00 2001
From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Date: Fri, 30 Jul 2021 14:40:55 +0900
Subject: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9

Hi,

This is a patch series to CVE-2021-21781.
The patch 9c698bff66ab ("RM: ensure the signal page contains defined
contents") depepds on memset32. However, this function is not provided
in 4.4 and 4.9. Therefore, we need the patch 3b3c4babd898 ("lib/string.c:
add multibyte memset functions") to apply this feature.
Another option is to implement only the memset32 function in
arch/arm/kernel/signal.c only, but for simplicity we have taken the
way of applying the original patch 3b3c4babd898 ("lib/string.c: add
multibyte memset functions") that provides memset32 in mainline kernel.

Best regards,
     Nobuhiro

Matthew Wilcox (1):
  lib/string.c: add multibyte memset functions

Russell King (1):
  ARM: ensure the signal page contains defined contents

 arch/arm/kernel/signal.c | 23 ++++++++++----
 include/linux/string.h   | 30 ++++++++++++++++++
 lib/string.c             | 66 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 6 deletions(-)

-- 
2.32.0


