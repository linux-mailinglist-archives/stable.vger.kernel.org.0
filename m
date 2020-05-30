Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8321E9017
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgE3JeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 05:34:07 -0400
Received: from mout.gmx.net ([212.227.15.19]:38913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgE3JeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 May 2020 05:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1590831244;
        bh=nmZ8wkLoKwrn889PzgUKFgpfk8JKq94zC3+5w10DyPo=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=VuE1LC9LuYDaAjn6Hkg/4O3oFH6RmPCeHcUf1Ymo0e/ewHACZpWQ5B9tuSkjSFCWQ
         eRGblZ4itdnvP0pOw5Mcta28K5Lt3YBAb65zXczMfELKCi0LuRaUikyqFx0dTgRQwy
         L3wB2OXDu/sB8MJ2kjwUBAuEfs3rIQv3I1d3YzNQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530.fritz.box ([92.116.167.47]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdvqW-1j6Sba1d82-00b7JZ; Sat, 30
 May 2020 11:34:04 +0200
Date:   Sat, 30 May 2020 11:34:02 +0200
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] parisc: Fix kernel panic in mem_init()
Message-ID: <20200530093402.GA8212@ls3530.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:wpvVp/ztE8xTtgijtDm7JeaOsyV9Sjx5bk0+X5AkXiTRkyVHyMd
 ipHicRR/QbL60km4FwzuWQbo1JBnUU433PQjkuN0LRwwglbXtLnrjJT7ZFeX4Ygqa0JLk74
 AU8jwES6LrBAZ1JRmN/fetVFCNfRGEFLAJuLc0aORBaWagrsFTq933F+JBvm5rRpPJjL0fj
 BTyvKBtxwNZmMP37MKLQg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UdntIY/rLoY=:TbwlcGpmRtqMtaPHRFQIHe
 H2E6UqVt8+/Qp/+Zl2LsIk6OgYUIs5JushhZAWP0S0yI2b6EAzMDVeG0jI+xgfWRbV9hicafr
 KYeD79heg64vn3wdkM+XxIg1+KJVaUrtfTh0uUCc45romglm+Qo/dL5CXfvvP5gz53BIFxRwG
 +E1tC7ct7IvS1RWE0vgG8SNUX+egr1W8D6+Vqy5Qoizj3uGQ1NXgusWeBIz9CnWx9KGT06tT1
 ttM+xq/GOkCWRHtQkttfHBu1GWE/GUEj+X1ZnZ/KNgSVKQ7n4c1IIeRW4/4WC5KTAf035uROF
 I1iMPG42slvUgoLZx3NEgzQzEqhEwMZtp615w25AabXNhDLEgpbngoWpRTZTGnhl3QeP7DNLg
 pWcMQMEMTU+twf7v3WX45p74835s/RhUEypJH4SQkUj5+/HywA//cYuoGObL7UPP6fLEIQ0xt
 7wOWpo/YVWKmwZlvBZRIKasK9fU0jplFBWWfa+2/Vzu22JRkypQ9Vv7HR6iaDKPovvFTy/sz7
 sK2mBXAy0izgFt1g0HFvhdwtLBY2ick7qp5x+NfHZ2v0/9fbmMTeBfj7fQs6JqbBwlTWnDAwJ
 KSQxB0qcoLXlwvXsVpDsZNe8AOjoP+1CpaxQtG+kYL1oTVKfH3olYCQdltcz9UYC8ATZYRvQx
 SZoBHw8rcjRVsXWQDIOb3a6zPJNGOEsCGGT3O8Dvu0QtrqXSe13mlK7Tq0zACESUAbMUtPrUi
 ql7qRkHa++INzgAMkz9Sj4TaCGCHuHUnn/Bp44ZKBZAtU5pUb5DKAFsMTyVwDT0FeXbrvf0Zo
 GL1JCH0lrvd+cfx/2XsVgm9R3qF9CsGz6Ex6G0oIaQq85xrhSl2wCVgCWP82gouP831utABa+
 puea7+tCsq+dPZxg7JX63TSYChkpadmbA+/53CVu+Rq5cC60+5QXfgIud0DW/oU56Jn7lezuv
 pl1KqmG28C8YRKALL6N3ctNAzfJUjaHnPrfQOIprLcZIBoKZ6/s6lvHRv2m7xR06b7W3qQstH
 +gMNgb8/tSWGyX4YxdJW++TtRwths6mNTdApyPLCT+1kcRNpB1iQoYeX1tOs3h886S34ZtsQj
 WNvoWYeqpUZ0tIg0cokNivoPc0CODrIwIyPIexzUyITIfuQV84yQoBm+MT8CZt7giRmkZEvgB
 i8GUh/XPhAsvvZ1aI/55nzitOe3SKeHfMX4RFvy1PvAFJMtNDyslu89v2sKHZbgIAMZLJwCT6
 lZltlw36XEn3Oq3hv
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,
can you please apply this patch to all 3.x and 4.x stable kernels?
Based on upstream commit bf71bc16e02162388808949b179d59d0b571b965
which doesn't apply out of the box on older kernels.
=2D----------

The Debian kernel v5.6 triggers this kernel panic:

 Kernel panic - not syncing: Bad Address (null pointer deref?)
 Bad Address (null pointer deref?): Code=3D26 (Data memory access rights t=
rap) at addr 0000000000000000
 CPU: 0 PID: 0 Comm: swapper Not tainted 5.6.0-2-parisc64 #1 Debian 5.6.14=
-1
  IAOQ[0]: mem_init+0xb0/0x150
  IAOQ[1]: mem_init+0xb4/0x150
  RP(r2): start_kernel+0x6c8/0x1190
 Backtrace:
  [<0000000040101ab4>] start_kernel+0x6c8/0x1190
  [<0000000040108574>] start_parisc+0x158/0x1b8

on a HP-PARISC rp3440 machine with this memory layout:
 Memory Ranges:
  0) Start 0x0000000000000000 End 0x000000003fffffff Size   1024 MB
  1) Start 0x0000004040000000 End 0x00000040ffdfffff Size   3070 MB

Fix the crash by avoiding virt_to_page() and similar functions in
mem_init() until the memory zones have been fully set up.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index aae9b0d71c1e..10a52664e29f 100644
=2D-- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -607,7 +607,7 @@ void __init mem_init(void)
 			> BITS_PER_LONG);

 	high_memory =3D __va((max_pfn << PAGE_SHIFT));
-	set_max_mapnr(page_to_pfn(virt_to_page(high_memory - 1)) + 1);
+	set_max_mapnr(max_low_pfn);
 	free_all_bootmem();

 #ifdef CONFIG_PA11
