Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2595D994
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfGCAr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:47:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:43173 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGCAr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:47:58 -0400
X-IronPort-AV: E=Sophos;i="5.62,444,1554768000"; 
   d="scan'208";a="809025475"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2019 21:02:22 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 4AB34A2693;
        Tue,  2 Jul 2019 21:02:22 +0000 (UTC)
Received: from EX13D05UWC001.ant.amazon.com (10.43.162.82) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC001.ant.amazon.com (10.43.162.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:21 +0000
Received: from localhost (172.23.204.141) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 21:02:21 +0000
From:   Balbir Singh <sblbir@amzn.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Balbir Singh <sblbir@amzn.com>
Subject: [backport to v4.14 CVE-2019-3900 0/7] Fix CVE-2019-3900 in stable v4.14
Date:   Tue, 2 Jul 2019 21:02:03 +0000
Message-ID: <20190702210210.2375-1-sblbir@amzn.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These series of patches are required to fix the specified CVE in v4.14.
I've tested these patches with a VM running vhost. Jason Wang who originally
wrote the patches, helped identify other patches to backport and also tested
this version and provided feedback on the patches.

Jason Wang (5):
  vhost_net: introduce vhost_exceeds_weight()
  vhost: introduce vhost_exceeds_weight()
  vhost_net: fix possible infinite loop
  vhost: vsock: add weight support
  vhost: scsi: add weight support

Paolo Abeni (1):
  vhost_net: use packet weight for rx handler, too

haibinzhang(张海斌) (1):
  vhost-net: set packet weight of tx polling to 2 * vq size

 drivers/vhost/net.c   | 33 +++++++++++++++++++--------------
 drivers/vhost/scsi.c  | 14 ++++++++++----
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  6 +++++-
 drivers/vhost/vsock.c | 27 ++++++++++++++++++++-------
 5 files changed, 73 insertions(+), 27 deletions(-)

-- 
2.16.5

