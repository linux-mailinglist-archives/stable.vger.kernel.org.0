Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00563DB334
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhG3GIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:08:24 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:60188 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhG3GIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 02:08:24 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 16U68FXn017196; Fri, 30 Jul 2021 15:08:15 +0900
X-Iguazu-Qid: 2wHHCQcilvuEpakr59
X-Iguazu-QSIG: v=2; s=0; t=1627625294; q=2wHHCQcilvuEpakr59; m=wfz9UidvXaim7PZZ1tFte9a+k0PW0w9H//5NWrIGmoA=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1113) id 16U68EMH024718
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 15:08:14 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 4746E100115;
        Fri, 30 Jul 2021 15:08:14 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 16U68DT2029281;
        Fri, 30 Jul 2021 15:08:14 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9
Date:   Fri, 30 Jul 2021 15:08:03 +0900
X-TSB-HOP: ON
Message-Id: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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


