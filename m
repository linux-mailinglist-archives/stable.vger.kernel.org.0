Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2E7BA47
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 09:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfGaHN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 03:13:56 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:41341 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfGaHNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 03:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564557235; x=1596093235;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=bi/HCpO7TMpU5w8LUcn3Bgtipfbuk3DlWN0oIM4iJaw=;
  b=ATQSNOSuMrlgH5TLLj4HEkjygmU5ET2CVirkz1r3YseqWM/HOcY/F0ya
   cwsE7iP3nWfu4ZIj9rvZoyciS14WP9yyJz/7Cm2Ih2Ps6Njdso4UGygUK
   i6Uali7y+zyJnqPIKIz7zMjd9wLnij5sV8/g3GZ5GNw8DRUDb4Fl8Ibos
   w=;
X-IronPort-AV: E=Sophos;i="5.64,329,1559520000"; 
   d="scan'208";a="689491174"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 31 Jul 2019 07:13:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 24579A2217;
        Wed, 31 Jul 2019 07:13:52 +0000 (UTC)
Received: from EX13D17UWB001.ant.amazon.com (10.43.161.252) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:13:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D17UWB001.ant.amazon.com (10.43.161.252) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:13:51 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 31 Jul 2019 07:13:51 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id 6157487441; Wed, 31 Jul 2019 00:13:51 -0700 (PDT)
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <trond.myklebust@hammerspace.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 0/4] Fix NFSv4 lookup revalidation
Date:   Wed, 31 Jul 2019 00:13:23 -0700
Message-ID: <20190731071327.28701-1-luqia@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please consider including the following patches in the stable
linux-4.14.y branch?

The following patch series attempts to address the issues raised by
Stan Hu around NFSv4 lookup revalidation.

The first patch in the series should, in principle suffice to address
the exact issue raised by Stan, however when looking at the
implementation of nfs4_lookup_revalidate(), it becomes clear that we're
not doing enough to revalidate the dentry itself when performing NFSv4.1
opens either.

Trond Myklebust (3):
  NFS: Fix dentry revalidation on NFSv4 lookup
  NFS: Refactor nfs_lookup_revalidate()
  NFSv4: Fix lookup revalidate of regular files

zhangliguang (1):
  NFS: Remove redundant semicolon

 fs/nfs/dir.c      | 295 ++++++++++++++++++++++++++++++------------------------
 fs/nfs/nfs4proc.c |  15 ++-
 2 files changed, 174 insertions(+), 136 deletions(-)

-- 
2.15.3.AMZN

