Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECCF68E0C0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjBGTCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBGTCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:02:03 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0831EBF9
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675796519; x=1707332519;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RAdG2zl9LksNYzqYMifhlBDlBLS2Nqdjxdy3sMKTCrk=;
  b=hrHIQQQkjQe7jH1xLxnVPb7J6644CBIkk/2GaUoAXNTB+l/h7CyrMxmG
   uFdTspvaL8jAFiRbxV6L68g9AIQEN1BwlkPNHQfrMVOtuz0/P7isWBd7f
   vPqsdW/netEZpN+in6SmrSOsXNAXAzsCyO4H5BgyHpOHvuyCRGiIWB4OH
   c=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="294480865"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:01:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 26C4381996;
        Tue,  7 Feb 2023 19:01:56 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:01:55 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.160.120)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:01:55 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 0/7] Remove reader optimistic spinning
Date:   Tue, 7 Feb 2023 19:01:28 +0000
Message-ID: <20230207190135.25258-1-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D30UWB002.ant.amazon.com (10.43.161.110) To
 EX19D046UWB004.ant.amazon.com (10.13.139.164)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is to remove reader optimistic spinning in
kernel 5.10 to improve the MongoDB performance. Performance measurements
(10 times running average of overall throughput ops/sec) are using
MongoDB 5.0.11 and YCSB [1] microbenchmark with workloadA [2] on AWS EC2
m5.4xlarge/m6g.4xlarge (16-vCPU 64GiB-memory) instances with a 512GB EBS
IO1 drive disk with 5000 IOPS and separating MongoDB and YCSB load generator
on 2 instances and setting recordcount=25000000 and operationcount=10000000
to see the impacts of these changes:

  Before - v5.10.165 kernel in OS Amazon Linux 2
  After  - v5.10.165 kernel with reader spinning disabled in OS Amazon Linux 2

  | Arch    | Instance Type | Before  | After   |
  |---------+---------------+---------+---------|
  | x86_64  | m5.4xlarge    | 37365.4 | 42373.9 |
  |---------+---------------+---------+---------|
  | aarch64 | m6g.4xlarge   | 33823.1 | 43113.7 |
  |---------+---------------+---------+---------|

It can be seen that the MongoDB throughput can be improved around 13% in x86_64
and 27% in aarch64 after disabling reader optimistic spinning and these patches 
can be applied to 5.10 with no conflict so we wonder if it's possible to backport 
them to stable 5.10? 

[1] https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
[2] https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloada

Thanks,
Shaoying

Peter Zijlstra (3):
  locking/rwsem: Better collate rwsem_read_trylock()
  locking/rwsem: Introduce rwsem_write_trylock()
  locking/rwsem: Fold __down_{read,write}*()

Waiman Long (4):
  locking/rwsem: Pass the current atomic count to
    rwsem_down_read_slowpath()
  locking/rwsem: Prevent potential lock starvation
  locking/rwsem: Enable reader optimistic lock stealing
  locking/rwsem: Remove reader optimistic spinning

 kernel/locking/lock_events_list.h |   6 +-
 kernel/locking/rwsem.c            | 359 +++++++++---------------------
 2 files changed, 106 insertions(+), 259 deletions(-)

-- 
2.38.1

