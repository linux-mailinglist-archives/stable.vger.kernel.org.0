Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6286AFC68
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 02:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCHBa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 20:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCHBaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 20:30:25 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3728ABB34
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678238994; x=1709774994;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/ovoS6OO76LP2WO1dS8f/1zLrhQeMfInUmKu/YQX3I0=;
  b=k8NYVFqRrrTOMwyClC8VGtomSHbBY69VWLOfFsBiHzlJmP8vU40IArXp
   Jl1hn7SAcI4PcaU47xZmqHAKGDM6kllzNfzjTrpiJTcAmjwp5L6zatZwM
   IJ4jUC5/BQb1UtMp3eLOAWG6+O69QhN/annggHKuahYKsPDiaMC9ox6NR
   A=;
X-IronPort-AV: E=Sophos;i="5.98,242,1673913600"; 
   d="scan'208";a="315961813"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:29:17 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 6FE4F40E6C;
        Wed,  8 Mar 2023 01:29:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 8 Mar 2023 01:29:15 +0000
Received: from 88665a182662.ant.amazon.com (10.135.222.163) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 8 Mar 2023 01:29:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     liujian <liujian56@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>
Subject: [4.19/5.4/5.10] Please backport fdaf88531cfd.
Date:   Tue, 7 Mar 2023 17:29:05 -0800
Message-ID: <20230308012905.10857-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.135.222.163]
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4.14, 4.19, 5.4, and 5.10, listen() does not return -EADDRINUSE when
it fails to reserve a port.

The same issue happend on 5.15.88 and fdaf88531cfd ("tcp: Fix listen()
regression in 5.15.88.") in the 5.15.y branch fixed it.

The commit can be applied cleanly to 4.19, 5.4, and 5.10.
Could you backport the commit to these branch ?

For 4.14.y, I'll post another patch.

Thanks,
Kuniyuki
