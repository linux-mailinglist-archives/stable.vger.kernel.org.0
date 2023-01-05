Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6993865E579
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 07:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjAEGS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 01:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjAEGS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 01:18:56 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808C963FE;
        Wed,  4 Jan 2023 22:18:44 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nnbpy6hdZznV6N;
        Thu,  5 Jan 2023 14:17:14 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 5 Jan
 2023 14:18:42 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <zohar@linux.ibm.com>
CC:     <paul@paul-moore.com>, <linux-integrity@vger.kernel.org>,
        <luhuaxin1@huawei.com>
Subject: [PATCH v5 0/3] ima: Fix IMA mishandling of LSM based rule during
Date:   Thu, 5 Jan 2023 14:16:01 +0800
Message-ID: <20230105061604.61611-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backports the following three patches to fix the issue of IMA mishandling
LSM based rule during LSM policy update, causing a file to match an
unexpected rule.

v5:
  goes back to ima_lsm_free_rule() instead to avoid freeing
rule->fsname.

v4:
  Make use of the exisiting ima_free_rule() instead of backported
ima_lsm_free_rule(). Which resolves additional memory leak issues.

v3:
  Backport "LSM: switch to blocking policy update notifiers" as well, as
the prerequsite of "ima: use the lsm policy update notifier".

v2:
  Re-adjust the bacported logic.

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
 8 files changed, 156 insertions(+), 48 deletions(-)

-- 
2.17.1

