Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2738113C19A
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAOMs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:48:26 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:35701 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgAOMsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 07:48:25 -0500
Received: from cobaltpc1.rd.cisco.com
 ([IPv6:2001:420:44c1:2577:18d8:d5d6:4408:6200])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ri5riEH6BT6sRri5viaE9e; Wed, 15 Jan 2020 13:48:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1579092504; bh=RF7wGAN7RmpsusYQfekowyAxbMRJ8ThHX/8E8ptL6/M=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:From:Subject;
        b=ECE/4WireVxHYnMTkZo1emdcXmL8SDlPQA3rHNW3ASMt2JJBLkYIvcAiYod//Z1D2
         bqMoDGCIZpENKZMc7U5ffilb+WDRYDER0ekYHiKb5wZEL1t/bTauGUrl0BshbousC3
         1KptR4MBPDfADNyy84ZryMP5OlZYbm9NH+l9kpfjXrYrlB4hOdfkCE6cawtFje050P
         ad2fwEUn7SNQgOWvIOZk0U1b8XszQTRqxW0AFqjvWlSaqO5eqGTMNdTJ0GMgleNBwZ
         L6gq+mL8z271X/azz1vcBZv23iAfrQv1Szuj//wGZF/dnZcSQQEYnxkcPBua1Vzbcj
         fE6+dqjSxThXg==
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Timo Kaufmann <timokau@zoho.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Subject: [PATCH for v5.5 1/2] Revert "Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers"
Date:   Wed, 15 Jan 2020 13:48:18 +0100
Message-Id: <20200115124819.3191024-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200115124819.3191024-1-hverkuil-cisco@xs4all.nl>
References: <20200115124819.3191024-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCrwfkwhmKthDssy6WLiJ5HPIAldwwLU4BHSNjMRxnK9CCQEWscB0QLHf0bk+1tXNv/a1JENJ2ggRjBDlrHMXnfbd44jibhtgIPXr4cQufBuHALzgnTj
 1I8AGYBkSf/JPJ9lrSx6Cf39xY5+SqUcsWvFAj0Jz785E9g5tnoUqOVAdTxc+4jGSBPaFZhjWW+RSZv0ClAvZ90nJH2AoTlAHId11SZev1oeE4/Q9yGySH/K
 5bQh/4pnUzDA+md66dE8MklYl9p44P+SeD16Sy+UC9Zc2rdDRNXPPfedrTHwNlMe805waKOY+4+8UYvszqHISfwA3JTPxSyyXP3O6KTWCHK2wubTAllXdnbl
 0R/Q+x1wGQj0Q8+Ed1o//nnqIM3dHvY1MzbQwaXpGGeXVdXw0Q6sEXEfja1S5GDpYw0l871n37vaWiDlynB1fvDc1yN0dQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit a284e11c371e446371675668d8c8120a27227339.

This causes problems (drifting cursor) with at least the F11 function that
reads more than 32 bytes.

The real issue is in the F54 driver, and so this should be fixed there, and
not in rmi_smbus.c.

So first revert this bad commit, then fix the real problem in F54 in another
patch.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Timo Kaufmann <timokau@zoho.com>
Fixes: a284e11c371e ("Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers")
Cc: stable@vger.kernel.org
---
 drivers/input/rmi4/rmi_smbus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/rmi4/rmi_smbus.c b/drivers/input/rmi4/rmi_smbus.c
index b313c579914f..2407ea43de59 100644
--- a/drivers/input/rmi4/rmi_smbus.c
+++ b/drivers/input/rmi4/rmi_smbus.c
@@ -163,6 +163,7 @@ static int rmi_smb_write_block(struct rmi_transport_dev *xport, u16 rmiaddr,
 		/* prepare to write next block of bytes */
 		cur_len -= SMB_MAX_COUNT;
 		databuff += SMB_MAX_COUNT;
+		rmiaddr += SMB_MAX_COUNT;
 	}
 exit:
 	mutex_unlock(&rmi_smb->page_mutex);
@@ -214,6 +215,7 @@ static int rmi_smb_read_block(struct rmi_transport_dev *xport, u16 rmiaddr,
 		/* prepare to read next block of bytes */
 		cur_len -= SMB_MAX_COUNT;
 		databuff += SMB_MAX_COUNT;
+		rmiaddr += SMB_MAX_COUNT;
 	}
 
 	retval = 0;
-- 
2.24.0

