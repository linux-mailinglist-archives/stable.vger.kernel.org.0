Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1C1685D72
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 03:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjBACmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 21:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBACmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 21:42:19 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496D04A208;
        Tue, 31 Jan 2023 18:42:18 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4P65gH07fpzJqsP;
        Wed,  1 Feb 2023 10:37:47 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 10:42:15 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <zohar@linux.ibm.com>,
        <paul@paul-moore.com>, <luhuaxin1@huawei.com>
Subject: [PATCH 4.19 0/3] Backport handling -ESTALE policy update failure to 4.19
Date:   Wed, 1 Feb 2023 10:39:49 +0800
Message-ID: <20230201023952.30247-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports patches in order to resolve the issue discussed here:
https://lore.kernel.org/selinux/389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com/

This required backporting the non-blocking LSM policy update mechanism
prerequisite patches.

Paul Moore has reviewed the non-blocking LSM policy update backport,
saying the SELinux part look good. The patchset was also reviewed by Mimi
Zohar
and everything looks ok.

I've tested the patches against the said issue and can confirm that the
issue is fixed. I've also run the LTP testcases on the fixed IMA and all
tests are passed.

This is a re-send of the original patchset as the original patchset
might have a faulty cover letter. The original patchset could be found
here:
https://patchwork.kernel.org/project/linux-integrity/list/?series=709367

GUO Zihua (1):
  ima: Handle -ESTALE returned by ima_filter_rule_match()

Janne Karhunen (2):
  LSM: switch to blocking policy update notifiers
  ima: use the lsm policy update notifier

 drivers/infiniband/core/device.c    |   4 +-
 include/linux/security.h            |  12 +--
 security/integrity/ima/ima.h        |   2 +
 security/integrity/ima/ima_main.c   |   8 ++
 security/integrity/ima/ima_policy.c | 151 ++++++++++++++++++++++------
 security/security.c                 |  23 +++--
 security/selinux/hooks.c            |   2 +-
 security/selinux/selinuxfs.c        |   2 +-
 8 files changed, 155 insertions(+), 49 deletions(-)

-- 
2.17.1

