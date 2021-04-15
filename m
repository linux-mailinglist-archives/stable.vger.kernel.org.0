Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF69361322
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhDOTxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 15:53:01 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:38360 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234654AbhDOTxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 15:53:00 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1BAF64138D;
        Thu, 15 Apr 2021 19:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1618516353; x=
        1620330754; bh=ecW59qDEe9JLWaXze5wAXL7EUUKHkaI0hMFFYvuAPrI=; b=J
        rGpug61mWhdZ2+CmXlE0roebZSJ8ZQIgQ6S8s1r7rLEv4icsDO1dzpnh3PNLHUeb
        BPJGlHl4py6Pjf58AzCnUp6FNTmup9uByBELv3iojjMLKOk24hjzmBWs6WzuXxFL
        /yS2ujO9M9sUMT3l37VzSB+k4h3zKcgeOki+IsaUJA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GGw_DXNYKgiv; Thu, 15 Apr 2021 22:52:33 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8E5BF41377;
        Thu, 15 Apr 2021 22:52:32 +0300 (MSK)
Received: from localhost (172.17.204.113) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 15
 Apr 2021 22:52:32 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <kernel-team@lists.ubuntu.com>, <linux@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: [PATCH for-5.4 0/2] scsi: qla2xxx: Fix P2P mode
Date:   Thu, 15 Apr 2021 22:51:42 +0300
Message-ID: <20210415195144.91903-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.17.204.113]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

QLogic FC adapters don’t work in P2P mode on the latest stable 5.4 (at least
QLE2692, and QLE2694, QLE2742 are affected).

We’ve tested and bisected from 5.4 up to 5.4.112 and figured out the
following: 

1. From 5.4 to 5.4.5 inclusively direct mode doesn’t work at all.

   Stable commit a82545b62e07 ("scsi: qla2xxx: Change discovery state before
   PLOGI") fixes the issue in 5.4.6

2. From 5.4.6 to 5.4.68 inclusively direct mode works but FC link cannot be
   recovered after issue_lip and all presented LUNs are lost

   Not working issue_lip is an outcome of a82545b62e07 applied to stable
   without the upstream commit 65e920093805 ("scsi: qla2xxx: Fix device connect
   issues in P2P configuration.").

3. From 5.4.69 up till now (5.4.112) direct mode doesn’t work again

   The issue was introduced by stable commit 74924e407bf7 ("scsi: qla2xxx:
   Retry PLOGI on FC-NVMe PRLI failure").

   Upstream commit 84ed362ac40c ("scsi: qla2xxx: Dual FCP-NVMe target port
   support") fixes the issue.

So, in order to fix both P2P issues we need to apply upstream commits
65e920093805 and 84ed362ac40c.

However, stable commits 0b84591fdd5e ("scsi: qla2xxx: Fix stuck login session
using prli_pend_timer") introduced in 5.4.19 and 74924e407bf7 ("scsi: qla2xxx:
Retry PLOGI on FC-NVMe PRLI failure") in 5.4.69 were applied in the wrong
order, upstream and chronological-wise with regards to required upstream fixes,
and cherry-picking of the fixes is not possible without a merge conflict.

The series provides merge conflict resolution and resolves both P2P discovery
and issue_lip issue. It has been tested over Linux stable 5.4.112 and
Ubuntu 20.04 kernel 5.4.0-71.79 (that's based off stable 5.4.101).

Please apply at your earliest convenience to 5.4 stable.

thanks,
Anastasia

Arun Easi (1):
  scsi: qla2xxx: Fix device connect issues in P2P configuration

Michael Hernandez (1):
  scsi: qla2xxx: Dual FCP-NVMe target port support

 drivers/scsi/qla2xxx/qla_def.h    | 26 +++++++++++-
 drivers/scsi/qla2xxx/qla_fw.h     |  2 +
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     | 42 +++++++++++--------
 drivers/scsi/qla2xxx/qla_init.c   | 70 +++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_inline.h | 12 ++++++
 drivers/scsi/qla2xxx/qla_iocb.c   |  5 +--
 drivers/scsi/qla2xxx/qla_mbx.c    | 11 ++---
 drivers/scsi/qla2xxx/qla_os.c     | 17 ++++----
 9 files changed, 124 insertions(+), 62 deletions(-)

-- 
2.30.2

