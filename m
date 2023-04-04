Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5766D6D5746
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 05:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjDDDrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 23:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjDDDrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 23:47:16 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B756B1BFB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 20:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680580035; x=1712116035;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YZx+uFNx1aN9y6Ue9sLi1IqPHGygQA8xye5gNDDnr/Q=;
  b=RPVTdVFXoFCnT6qfgLgzmDagFwYn4hm2qGNVHVr/m5M9lxWX6+vb0ZjA
   kopG5mStp7aqj1bKvIFlk+hIf0XTLxLG0MQKBSbgd7oMguETl6s/lf0OT
   YLqZlqLI2HQbZMt63Gn6SodwYaFmKpTV+38hWOUgr2FsouLa7evnOOdnV
   o=;
X-IronPort-AV: E=Sophos;i="5.98,316,1673913600"; 
   d="scan'208";a="314426549"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:47:12 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id CCB27413AB;
        Tue,  4 Apr 2023 03:47:11 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 4 Apr 2023 03:47:11 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.21) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 4 Apr 2023 03:47:06 +0000
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
Subject: [RESEND PATCH stable 4.14 4.19 0/2] Backport "KVM: arm64: Filter out invalid core registers IDs in KVM_GET_REG_LIST"
Date:   Tue, 4 Apr 2023 04:46:47 +0100
Message-ID: <20230404034649.77915-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.21]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
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

