Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D700448B0FF
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiAKPhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:37:18 -0500
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:7458 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbiAKPhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:37:18 -0500
IronPort-SDR: AhMWm9Exg9BPpK2io4UC1ukUC4Y0TR9NyhaosHoYj4E8FjmgBP2WhYihRUFMa9FpXBJBFRuNL0
 y0+lkdgRuvpfX4DJ+L7BcZUHLTJaVo2KuyXfeL7uH5GaoT5ydbbejtGAbx42v1N/P+Wmt/OxSu
 bTB3fEFXWu79Qi9AjmaXERbpec4PN4OwsyVpISmOBJPt5nJRqN2OEs4RQCf/C6bwyhYRjg9QaO
 tnAcw6FP7WXx0qOP8dLFKndSDukhgFBGwRXB9JTYecLlDk0g//4WnSpaAQE2njNz5Hwen9c6Ks
 bPS6iQiITrj4xLsb75eG4DZ5
X-IronPort-AV: E=Sophos;i="5.88,279,1635235200"; 
   d="scan'208";a="70494869"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 11 Jan 2022 07:37:18 -0800
IronPort-SDR: torNaI12recoyAGK9sfDRoWL5VYA17CxE2Yoe1lRpYar+Y2V1TSW0aVnXBCLA8VDqY8OyRfgCm
 FQV+ItqPP1n21pxeX6yY5ZxVByGxjey8i0ad4ca3MWNlPoOgrMC0SqbWjpUsqpi0g/llopKr++
 4k3p8wWxsdE4+XYRa7idPNh6AJwBV1Mr3/oUF3ICOzOQPNaWIU4cJaUTQCkMK3ufQZPQ5sSDUq
 cCex8uvoTG0+eNpy7tI9g6soKmWkJ+5sQtESB4USkdUl75ukayqaT3GCDlktjbCid7LUqHCTeo
 pKI=
Date:   Tue, 11 Jan 2022 10:37:13 -0500
From:   Amy Fong <Amy_Fong@mentor.com>
To:     <stable@vger.kernel.org>
CC:     <Amy_Fong@mentor.com>, <davem@davemloft.net>
Subject: [PATCH 4.19 stable 0/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: svr-orw-mbx-02.mgc.mentorg.com (147.34.90.202) To
 svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following series backports netfilter: nf_tables: autoload modules from abort path
which fixes the bug mentioned in the following:

   https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb


----

BUG: corrupted list in __nf_tables_abort
Status: fixed on 2020/03/17 22:09
Reported-by: syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com
Fix commit: eb014de4fd41 netfilter: nf_tables: autoload modules from the abort path
First crash: 717d, last: 710d

Cause bisection: introduced by (bisect log) :
commit ec7470b834fe7b5d7eff11b6677f5d7fdf5e9a91
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon Jan 13 17:09:58 2020 +0000

  netfilter: nf_tables: store transaction list locally while requesting module

Crash: KASAN: use-after-free Read in __nf_tables_abort (log)
Repro: C syz .config

Fix bisection: fixed by (bisect log) :
commit 34682110abc50ffea7e002b0c2fd7ea9e0000ccc
Author: Max Chou <max.chou@realtek.com>
Date: Wed Nov 27 03:01:07 2019 +0000

  Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset
'
