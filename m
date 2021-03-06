Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4744132FBD0
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhCFQTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:19:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:39330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhCFQSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 11:18:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615047515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8J1qAdHunz+tmbQ9/r5zGTbgmDsvG9L+i6KEmaXahyU=;
        b=GbHI37Qp2DIWCj2DDCYa8vhoXGGZy59OCOoz24/s+MnE62esSHkcr80s9p6Cyt1yw6+uWJ
        Hy7jV1MpQww0MrpBWSNmxhvJ84UTYK9D2cdLc9uP1Z2hnokvYBtB72NGy0ZOglaGl47lHi
        vO4oNHGV2YZsIAPwuQnpBTR9ldXAJWc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 894A6ACBF;
        Sat,  6 Mar 2021 16:18:35 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v4 0/3] xen/events: bug fixes and some diagnostic aids
Date:   Sat,  6 Mar 2021 17:18:30 +0100
Message-Id: <20210306161833.4552-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Those are fixes for XSA-332.

The rest of the V3 patches have been applied already. There is one
additional fix in patch 2 which addresses network outages when a guest
is doing reboot loops.

Juergen Gross (3):
  xen/events: reset affinity of 2-level event when tearing it down
  xen/events: don't unmask an event channel when an eoi is pending
  xen/events: avoid handling the same event on two cpus at the same time

 drivers/xen/events/events_2l.c       |  22 +++--
 drivers/xen/events/events_base.c     | 130 ++++++++++++++++++++-------
 drivers/xen/events/events_fifo.c     |   7 --
 drivers/xen/events/events_internal.h |  14 +--
 4 files changed, 123 insertions(+), 50 deletions(-)

-- 
2.26.2

