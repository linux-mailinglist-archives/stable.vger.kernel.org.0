Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8472A3DB331
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhG3GGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:06:44 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:52506 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbhG3GGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 02:06:40 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 16U66UkG011333; Fri, 30 Jul 2021 15:06:30 +0900
X-Iguazu-Qid: 2wHHmJkRoP8m4JISIP
X-Iguazu-QSIG: v=2; s=0; t=1627625190; q=2wHHmJkRoP8m4JISIP; m=OGvLr/zqdVWnsH+m5pvpE5p/iSmla6SSZRNdFMByGis=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1112) id 16U66T6l000545
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 15:06:29 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 92BA7100137;
        Fri, 30 Jul 2021 15:06:29 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 16U66ThW001190;
        Fri, 30 Jul 2021 15:06:29 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9
Date:   Fri, 30 Jul 2021 15:06:25 +0900
X-TSB-HOP: ON
Message-Id: <20210730060625.342450-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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


