Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F42682370
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 05:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjAaEkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 23:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjAaEjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 23:39:13 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D4E3A59D;
        Mon, 30 Jan 2023 20:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675139936; x=1706675936;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CXKI8V8i96SMsRvHYzeufowrTOHGbbWXe38v5Z4Dvh4=;
  b=fyARXLoYZGPATEk5fv1o61j/hn8wqLcTKz0GOZY1kRGe8JMd+lMvHQr7
   nVAGtDygDQ9ri4mJqiUloq66q75opmq3afq4dSts9sQIkLcj83Wn/uLPi
   GGqusXZ28Blr67JMBh7UeV2f0ONFUE9gzXkHGB3aByT4+WbHVKyk+KQO+
   s=;
X-IronPort-AV: E=Sophos;i="5.97,259,1669075200"; 
   d="scan'208";a="293718495"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 04:38:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id A1D3D81A5F;
        Tue, 31 Jan 2023 04:38:53 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 31 Jan 2023 04:38:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 31 Jan 2023 04:38:51 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.45 via Frontend Transport; Tue, 31 Jan 2023 04:38:51
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 429D5271E; Tue, 31 Jan 2023 04:38:50 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <mhocko@suse.co>, Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH stable 4.14 0/1] Fix ext4 xfstests failure
Date:   Tue, 31 Jan 2023 04:38:14 +0000
Message-ID: <20230131043815.14989-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running xfstests on 4.14.304 version we see a warning being
generated in one of ext4 tests with the following stack trace.

WARNING: CPU: 4 PID: 15332 at mm/util.c:414
kvmalloc_node+0x67/0x70
ext4_expand_extra_isize_ea+0x2b4/0x870 [ext4]
__ext4_expand_extra_isize+0xcb/0x120 [ext4]
ext4_mark_inode_dirty+0x1a5/0x1d0 [ext4]
ext4_ext_truncate+0x1f/0x90 [ext4]
ext4_truncate+0x363/0x400 [ext4]
ext4_setattr+0x392/0xa00 [ext4]
notify_change+0x300/0x420
? ext4_xattr_security_set+0x20/0x20 [ext4]
do_truncate+0x75/0xc0
? ext4_release_file+0xa0/0xa0 [ext4]
path_openat+0x737/0x16f0
do_filp_open+0x9b/0x110
? __check_object_size+0xb4/0x190
? do_sys_open+0x1bd/0x250
do_sys_open+0x1bd/0x250
do_syscall_64+0x67/0x110
entry_SYSCALL_64_after_hwframe+0x59/0xbe

It seems rebase to 4.14.304 brings a bunch of ext4 changes.
Commit ext4: allocate extended attribute value in vmalloc area
(73c44f61dab180b5f2dee9f15397aba36a75a882) tries to allocate buffer
using kvmalloc with improper flags that generates this warning.
To fix backport an upstream commit mm: kvmalloc does not
fallback to vmalloc for incompatible gfp flags
(170f26afa0481c72af93aa61b7398b5663451651). This removes the WARN_ON and
fallsback to kmalloc if correct flags are not passed.


Michal Hocko (1):
  mm: kvmalloc does not fallback to vmalloc for incompatible gfp flags

 mm/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.38.1

