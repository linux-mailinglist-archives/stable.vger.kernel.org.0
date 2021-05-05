Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F9E3739D8
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhEEMFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233122AbhEEMFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:05:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEE161157;
        Wed,  5 May 2021 12:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216293;
        bh=rRcdNMM8mOvN5I91DERnVpqyAWq288pXYvyauRmrLws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZCUBc+3d87tE6ip49EEjke1g9y9XZlRQYGXgeRrHJo5tjMfLJPqrIcGt4I+9Fc7N
         yxZGOXsS+L/IN7QhhlInSCSObXmZUbe8h5i+HGzZH9x0KharszzS4YQyuNZLGHB9ES
         BENkZhve0539LiKWgkumxCNBZCNYc8m+12f2lAzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Lowe <nick.lowe@gmail.com>,
        David Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 05/21] igb: Enable RSS for Intel I211 Ethernet Controller
Date:   Wed,  5 May 2021 14:04:19 +0200
Message-Id: <20210505112324.906083933@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Lowe <nick.lowe@gmail.com>

commit 6e6026f2dd2005844fb35c3911e8083c09952c6c upstream.

The Intel I211 Ethernet Controller supports 2 Receive Side Scaling (RSS)
queues. It should not be excluded from having this feature enabled.

Via commit c883de9fd787 ("igb: rename igb define to be more generic")
E1000_MRQC_ENABLE_RSS_4Q was renamed to E1000_MRQC_ENABLE_RSS_MQ to
indicate that this is a generic bit flag to enable queues and not
a flag that is specific to devices that support 4 queues

The bit flag enables 2, 4 or 8 queues appropriately depending on the part.

Tested with a multicore CPU and frames were then distributed as expected.

This issue appears to have been introduced because of confusion caused
by the prior name.

Signed-off-by: Nick Lowe <nick.lowe@gmail.com>
Tested-by: David Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4326,8 +4326,7 @@ static void igb_setup_mrqc(struct igb_ad
 		else
 			mrqc |= E1000_MRQC_ENABLE_VMDQ;
 	} else {
-		if (hw->mac.type != e1000_i211)
-			mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
+		mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
 	}
 	igb_vmm_control(adapter);
 


