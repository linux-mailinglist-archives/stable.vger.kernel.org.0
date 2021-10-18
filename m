Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E09E431C57
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhJRNkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233716AbhJRNij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C04561373;
        Mon, 18 Oct 2021 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563937;
        bh=5dlnK4dzyi2Jw1z3okBIXu8lZDl/jvlRZV3/+8AL1S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FKPYz8v618zD6fs4Qjt3W/5dglgfTYezS0gqVPJ7PtcYXtK4vIforaWsSHGlfnCB
         B2VyiV5VcqXU96TdaOagQgrK365BX+xyr3vNFy6KRxxdoSkYWppTmah3E/5XSKhPlZ
         RT6qsxmoHBh8Y8BnklGVJWttu3PafzJs+s0cMfkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 55/69] NFC: digital: fix possible memory leak in digital_in_send_sdd_req()
Date:   Mon, 18 Oct 2021 15:24:53 +0200
Message-Id: <20211018132331.302290292@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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
@@ -465,8 +465,12 @@ static int digital_in_send_sdd_req(struc
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


