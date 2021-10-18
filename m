Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DCF431AE5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhJRN3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhJRN3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DC6A60EFE;
        Mon, 18 Oct 2021 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563611;
        bh=MS2Uw1MMjZwdjNW3SLFOaCILxBT4iMo0z9Hy+GL7sD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0//CKFMBMn48yRhCJwm/PMCq+hsT0Ht4g6Jx8506hMNT8lLOSFluxt/oEOgv2gII
         XRh0VXmf+tVcjT65qzBahUCGTWPhQ7a+DyfAFyWnzeiGwKDpWHl5gwqf5tiRCoIW3Y
         kofARNH2/4d0rVQ6dHbGA4KTNc+qhegLkvLkFVWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 33/39] NFC: digital: fix possible memory leak in digital_in_send_sdd_req()
Date:   Mon, 18 Oct 2021 15:24:42 +0200
Message-Id: <20211018132326.503889214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 291c932fc3692e4d211a445ba8aa35663831bac7 upstream.

'skb' is allocated in digital_in_send_sdd_req(), but not free when
digital_in_send_cmd() failed, which will cause memory leak. Fix it
by freeing 'skb' if digital_in_send_cmd() return failed.

Fixes: 2c66daecc409 ("NFC Digital: Add NFC-A technology support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/digital_technology.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -474,8 +474,12 @@ static int digital_in_send_sdd_req(struc
 	skb_put_u8(skb, sel_cmd);
 	skb_put_u8(skb, DIGITAL_SDD_REQ_SEL_PAR);
 
-	return digital_in_send_cmd(ddev, skb, 30, digital_in_recv_sdd_res,
-				   target);
+	rc = digital_in_send_cmd(ddev, skb, 30, digital_in_recv_sdd_res,
+				 target);
+	if (rc)
+		kfree_skb(skb);
+
+	return rc;
 }
 
 static void digital_in_recv_sens_res(struct nfc_digital_dev *ddev, void *arg,


