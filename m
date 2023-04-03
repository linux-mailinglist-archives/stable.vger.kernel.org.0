Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF53A6D54C7
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 00:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjDCWbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 18:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjDCWbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 18:31:01 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CA440CC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 15:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680561060; x=1712097060;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YZx+uFNx1aN9y6Ue9sLi1IqPHGygQA8xye5gNDDnr/Q=;
  b=f1+qOJeXJZ4ZAF90MOSC2Iw0aUUNvipKKs5pqogKQgcMLNClS3B+4bIq
   jJzEgH6fZon/eOjUQnGJ7J672Wz5SNbCCMBqFBKu6uFDpbA7UDrT+9kxQ
   P2RRvFEvIYJDIGRyyw5KWyi6VbspDvUEoV+xdK95OSbbd2V1Bf8ZC/IZg
   8=;
X-IronPort-AV: E=Sophos;i="5.98,315,1673913600"; 
   d="scan'208";a="200592081"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 22:30:57 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id A2A3BE15D4;
        Mon,  3 Apr 2023 22:30:53 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 3 Apr 2023 22:30:45 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.12) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Mon, 3 Apr 2023 22:30:40 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        "Takahiro Itazuri" <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH stable 4.14 4.19 0/2] Backport "KVM: arm64: Filter out"
Date:   Mon, 3 Apr 2023 23:30:26 +0100
Message-ID: <20230403223028.45131-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.12]
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-9.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable maintainers,

This is a backport patch for commit df205b5c6328 ("KVM: arm64: Filter
out invalid core register IDs in KVM_GET_REG_LIST") to 4.14 and 4.19.
This commit was not applied to the 4.14-stable tree due to merge
conflict [1]. To backport this, commit be25bbb392fa ("KVM: arm64: Factor
out core register ID enumeration") that has no functional changes is
cherry-picked.

I'd appreciate if if you could consider backporting this to 4.14 and
4.19.

Best regards,
Takahiro

[1] https://lore.kernel.org/all/1560343489-22906-1-git-send-email-Dave.Martin@arm.com/

Dave Martin (2):
  KVM: arm64: Factor out core register ID enumeration
  KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST

 arch/arm64/kvm/guest.c | 79 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 14 deletions(-)

-- 
2.39.2

