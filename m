Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEBB6D5D88
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbjDDKbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbjDDKbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:31:22 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94205171D
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 03:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680604280; x=1712140280;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fIdGERQo18Ow0Zh/qI/luVDDLiDPtmvfJtxczxsu1Qc=;
  b=SzpuW0E9HQL9SVEJPX+fnjT8LlP7mI7/mC6BrXq3SSAr8R3w+qPQ6xdM
   bSZYmb1KxE5IjqDzxOLVW3s8LhbXWKZIChVETdL7jlC2VGMfoGt84bw1W
   bFWaplfrpm6nSifdB93I6QxrpobTUVF+z+swjnTRHq8Ca5nS3V95uqoxQ
   I=;
X-IronPort-AV: E=Sophos;i="5.98,317,1673913600"; 
   d="scan'208";a="200698544"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:31:16 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 3B979A7E0A;
        Tue,  4 Apr 2023 10:31:12 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 4 Apr 2023 10:31:05 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.136.176) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 4 Apr 2023 10:31:01 +0000
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
Subject: [PATCH v3 stable 4.14 4.19 0/3] Backport "KVM: arm64: Filter out invalid core registers IDs in KVM_GET_REG_LIST"
Date:   Tue, 4 Apr 2023 11:30:47 +0100
Message-ID: <20230404103050.27202-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.136.176]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
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
conflict [1]. To backport this, cherry-picked commit be25bbb392fa
("KVM: arm64: Factor out core register ID enumeration") that has no
functional changes but makes it easy to merge, and commit 5d8d4af24460
("arm64: KVM: Fix system register enumeration") that is a fix patch for
the commit.

I'd appreciate it if you could consider backporting this to 4.14 and
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

v2 -> v3:
* Cherry-pick an additional fix patch.
* Link to v2: https://lore.kernel.org/all/20230404034649.77915-1-itazur@amazon.com/

v1 -> v2:
* Fix a compile error for core_reg_size_from_offset().
* Link to v1: https://lore.kernel.org/all/20230403223028.45131-1-itazur@amazon.com/

