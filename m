Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A084A201692
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbgFSQcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389531AbgFSOwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:52:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD89217D8;
        Fri, 19 Jun 2020 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578327;
        bh=5csFN05D8iyGyID9ph1ijouRLxMwIBMQGSsB6XsnKf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrYrIaGgL0/CNGCZbiR8MmSZS7bbr9Sf02ga7u7rF/ScMcux+Tih0m6RUkk4bC5rV
         JvzrC6xUKlZENox84z2fq+6iJawbenEFSeon+36vtQWuxs5e0yav24ObawX7EPjFKq
         chNkgDmRkZsBBUAsF33LphSbW4vOAc2DxNVE7gLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.14 171/190] igb: Report speed and duplex as unknown when device is runtime suspended
Date:   Fri, 19 Jun 2020 16:33:36 +0200
Message-Id: <20200619141642.321424724@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 165ae7a8feb53dc47fb041357e4b253bfc927cf9 upstream.

igb device gets runtime suspended when there's no link partner. We can't
get correct speed under that state:
$ cat /sys/class/net/enp3s0/speed
1000

In addition to that, an error can also be spotted in dmesg:
[  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost

Since device can only be runtime suspended when there's no link partner,
we can skip reading register and let the following logic set speed and
duplex with correct status.

The more generic approach will be wrap get_link_ksettings() with begin()
and complete() callbacks. However, for this particular issue, begin()
calls igb_runtime_resume() , which tries to rtnl_lock() while the lock
is already hold by upper ethtool layer.

So let's take this approach until the igb_runtime_resume() no longer
needs to hold rtnl_lock.

CC: stable <stable@vger.kernel.org>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igb/igb_ethtool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -163,7 +163,8 @@ static int igb_get_link_ksettings(struct
 	u32 speed;
 	u32 supported, advertising;
 
-	status = rd32(E1000_STATUS);
+	status = pm_runtime_suspended(&adapter->pdev->dev) ?
+		 0 : rd32(E1000_STATUS);
 	if (hw->phy.media_type == e1000_media_type_copper) {
 
 		supported = (SUPPORTED_10baseT_Half |


