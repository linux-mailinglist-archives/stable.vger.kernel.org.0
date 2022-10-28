Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB07611AAF
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 21:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJ1TM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 15:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJ1TMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 15:12:52 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BAC23641C
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666984371; x=1698520371;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tZ1M/g+GmQrOmOI1UPADhv5UQsDktn/EpESn99mZsbg=;
  b=Bv85fGQOAe/NMHzNRrlOO53oEWjLISJ+EMH/lF9+YvTsHFmuNJ6cLpaZ
   rMdIIdbRZL+FbDxrTqQTmVv9DYeDNRyZluRH0KCg5V6R+/lO6KVZ1sKlq
   YtmES1JJ/SiKmMVJeJ13812lOyPBUcPePEPQT0PsYeuZtzTmBbvFKjnSm
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,222,1661817600"; 
   d="scan'208";a="1068845579"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 19:12:50 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 2173D82590;
        Fri, 28 Oct 2022 19:12:47 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 28 Oct 2022 19:12:47 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.43.160.223) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.15; Fri, 28 Oct
 2022 19:12:46 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <lcapitulino@gmail.com>, <chenzhou10@huawei.com>,
        <lizefan.x@bytedance.com>, <mkoutny@suse.com>, <tj@kernel.org>
Subject: [PATCH stable 5.4] cgroup-v1: add disabled controller check in cgroup1_parse_param()
Date:   Fri, 28 Oct 2022 19:11:13 +0000
Message-ID: <20221028191113.14053-1-luizcap@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D43UWA001.ant.amazon.com (10.43.160.44) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

Commit 61e960b07b637f0295308ad91268501d744c21b5 upstream.

[ This backport uses invalf() instead of invalfc() since the latter is
  only available starting with v5.6 ]

When mounting a cgroup hierarchy with disabled controller in cgroup v1,
all available controllers will be attached.
For example, boot with cgroup_no_v1=cpu or cgroup_disable=cpu, and then
mount with "mount -t cgroup -ocpu cpu /sys/fs/cgroup/cpu", then all
enabled controllers will be attached except cpu.

Fix this by adding disabled controller check in cgroup1_parse_param().
If the specified controller is disabled, just return error with information
"Disabled controller xx" rather than attaching all the other enabled
controllers.

Fixes: f5dfb5315d34 ("cgroup: take options parsing into ->parse_monolithic()")
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Zefan Li <lizefan.x@bytedance.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
---
 kernel/cgroup/cgroup-v1.c | 3 +++
 1 file changed, 3 insertions(+)

Reviewers,

Only 5.4-stable is affected. The issue was introduced in 5.1 and fixed
by Chen in 5.11 and 5.10-stable.

I tested the same reproducer on Amazon Linux 2 as described in the
commit message (well, except that I used the cpuset controller).

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 9e847e71cedd..759a931f278b 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -944,6 +944,9 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		for_each_subsys(ss, i) {
 			if (strcmp(param->key, ss->legacy_name))
 				continue;
+			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
+				return invalf(fc, "Disabled controller '%s'",
+					       param->key);
 			ctx->subsys_mask |= (1 << i);
 			return 0;
 		}
-- 
2.24.4.AMZN

