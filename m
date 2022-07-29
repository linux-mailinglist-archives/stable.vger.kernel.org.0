Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43997584A1C
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 05:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiG2DNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 23:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbiG2DNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 23:13:52 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E8D7C193
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 20:13:50 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LvCHm27Sfz9syf;
        Fri, 29 Jul 2022 11:12:36 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 11:13:48 +0800
Received: from mdc.huawei.com (10.175.112.208) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 11:13:47 +0800
From:   Chen Jun <chenjun102@huawei.com>
To:     <stable@vger.kernel.org>, <deller@gmx.de>, <geert@linux-m68k.org>,
        <b.zolnierkie@samsung.com>, <gregkh@linuxfoundation.org>
CC:     <xuqiang36@huawei.com>, <xiujianfeng@huawei.com>
Subject: [PATCH stable 4.19 4.14 0/2] add fix patch for CVE-2021-3365
Date:   Fri, 29 Jul 2022 03:11:38 +0000
Message-ID: <20220729031140.21806-1-chenjun102@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

refer to https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
3 patches are provided to fix CVE-2021-3365 (When sending malicous data
to kernel by ioctl cmd FBIOPUT_VSCREENINFO,kernel will write memory out
of bounds. https://nvd.nist.gov/vuln/detail/CVE-2021-33655) in mainline.

But only
commit 65a01e601dbb ("fbcon: Disallow setting font bigger than screen size")
was backported to stable (4.19,4.14).

without other two commit
commit e64242caef18 ("fbcon: Prevent that screen size is smaller than font size")
commit 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
The problem still exists.

static long do_fb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
	fb_set_var(info, &var);
		fb_notifier_call_chain(evnt, &event); // evnt = FB_EVENT_MODE_CHANGE

static int fbcon_event_notify(struct notifier_block *self,
			      unsigned long action, void *data)
	fbcon_modechanged(info);
		updatescrollmode(p, info, vc);
			...
			p->vrows = vyres/fh;
			if (yres > (fh * (vc->vc_rows + 1)))
				p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
			if ((yres % fh) && (vyres % fh < yres % fh))
				p->vrows--;	[1]
[1]: p->vrows could be -1, like what CVE-2021-3365 described.

I think, the two commits should be backported to 4.19 and 4.14.

Helge Deller (2):
  fbcon: Prevent that screen size is smaller than font size
  fbmem: Check virtual screen sizes in fb_set_var()

 drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
 drivers/video/fbdev/core/fbmem.c | 20 +++++++++++++++++---
 include/linux/fbcon.h            |  4 ++++
 3 files changed, 49 insertions(+), 3 deletions(-)

-- 
2.17.1

