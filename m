Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECEF14BBC4
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgA1OtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727506AbgA1OBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A8324688;
        Tue, 28 Jan 2020 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220107;
        bh=+0D6euA8CE4WjqA7DLQwotiII8Xa0lgFqvviyeObp8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQFbVbRtNgYnR2iJo5xwz4s+SvjuKyrWC59O/k+/pC+SN2OivQP4LYdnQmeqO5NpM
         j+pYVYznf89If2ikI2Hf44U1iLPY0byj3g0h7Y82hBG7AJyEOY4kVvRG+VqDAC1rOP
         9gWFA2lIRaxZ5r/ZpIzjX382xnJLs4IMzg8w3/8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 020/104] airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE
Date:   Tue, 28 Jan 2020 14:59:41 +0100
Message-Id: <20200128135820.041283682@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 78f7a7566f5eb59321e99b55a6fdb16ea05b37d1 ]

The driver for Cisco Aironet 4500 and 4800 series cards (airo.c),
implements AIROOLDIOCTL/SIOCDEVPRIVATE in airo_ioctl().

The ioctl handler copies an aironet_ioctl struct from userspace, which
includes a command. Some of the commands are handled in readrids(),
where the user controlled command is converted into a driver-internal
value called "ridcode".

There are two command values, AIROGWEPKTMP and AIROGWEPKNV, which
correspond to ridcode values of RID_WEP_TEMP and RID_WEP_PERM
respectively. These commands both have checks that the user has
CAP_NET_ADMIN, with the comment that "Only super-user can read WEP
keys", otherwise they return -EPERM.

However there is another command value, AIRORRID, that lets the user
specify the ridcode value directly, with no other checks. This means
the user can bypass the CAP_NET_ADMIN check on AIROGWEPKTMP and
AIROGWEPKNV.

Fix it by moving the CAP_NET_ADMIN check out of the command handling
and instead do it later based on the ridcode. That way regardless of
whether the ridcode is set via AIROGWEPKTMP or AIROGWEPKNV, or passed
in using AIRORID, we always do the CAP_NET_ADMIN check.

Found by Ilja by code inspection, not tested as I don't have the
required hardware.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/cisco/airo.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7790,16 +7790,8 @@ static int readrids(struct net_device *d
 	case AIROGVLIST:    ridcode = RID_APLIST;       break;
 	case AIROGDRVNAM:   ridcode = RID_DRVNAME;      break;
 	case AIROGEHTENC:   ridcode = RID_ETHERENCAP;   break;
-	case AIROGWEPKTMP:  ridcode = RID_WEP_TEMP;
-		/* Only super-user can read WEP keys */
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-		break;
-	case AIROGWEPKNV:   ridcode = RID_WEP_PERM;
-		/* Only super-user can read WEP keys */
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-		break;
+	case AIROGWEPKTMP:  ridcode = RID_WEP_TEMP;	break;
+	case AIROGWEPKNV:   ridcode = RID_WEP_PERM;	break;
 	case AIROGSTAT:     ridcode = RID_STATUS;       break;
 	case AIROGSTATSD32: ridcode = RID_STATSDELTA;   break;
 	case AIROGSTATSC32: ridcode = RID_STATS;        break;
@@ -7813,6 +7805,12 @@ static int readrids(struct net_device *d
 		return -EINVAL;
 	}
 
+	if (ridcode == RID_WEP_TEMP || ridcode == RID_WEP_PERM) {
+		/* Only super-user can read WEP keys */
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+	}
+
 	if ((iobuf = kzalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 


