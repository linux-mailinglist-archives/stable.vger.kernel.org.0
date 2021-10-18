Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1881F431E77
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJROB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234467AbhJRN7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 981B8613A9;
        Mon, 18 Oct 2021 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564510;
        bh=5dlnK4dzyi2Jw1z3okBIXu8lZDl/jvlRZV3/+8AL1S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkFimG4UmhrAuAlEKmvBS+PFnVjyxxYK4TqttjdO5Jev4Jx7kpCXajKYoKnPJdrL5
         bu++ODugcC9wYGOnyuYn15THEhQajgu/zChyvpAZ1CxFkE2uIuim9M2ZAgETxn1aIl
         aOoCcQRIVy0KX549jb0O7gssU4TvaRYLqAthhMzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 117/151] NFC: digital: fix possible memory leak in digital_in_send_sdd_req()
Date:   Mon, 18 Oct 2021 15:24:56 +0200
Message-Id: <20211018132344.476820148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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


