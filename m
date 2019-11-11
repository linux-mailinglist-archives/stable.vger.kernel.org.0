Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30B2F7B82
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfKKSgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:36:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbfKKSgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:36:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAC3204FD;
        Mon, 11 Nov 2019 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497413;
        bh=LhPWK2V7Segxol/WkLGxQ23Hr9rDFRaY8YxQpfE+9KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISsINZ5NrXUqWzIJP3IK1z4z+h239+GX/Of3JvjdFplniPH+/oJSYhp/n2feeafW1
         1Gg4/rHMQ8Yh8sWt+TvJlPruKYiXMk3qvtvxZbYlMJZynDb6xRVdwIY6oAAgZHCrHL
         lnxnsjP0G5QV2yi1ueXKD+vzTdyCGM8WFWIHky7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 009/105] nfc: netlink: fix double device reference drop
Date:   Mon, 11 Nov 2019 19:27:39 +0100
Message-Id: <20191111181426.141943937@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 025ec40b81d785a98f76b8bdb509ac10773b4f12 ]

The function nfc_put_device(dev) is called twice to drop the reference
to dev when there is no associated local llcp. Remove one of them to fix
the bug.

Fixes: 52feb444a903 ("NFC: Extend netlink interface for LTO, RW, and MIUX parameters support")
Fixes: d9b8d8e19b07 ("NFC: llcp: Service Name Lookup netlink interface")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1100,7 +1100,6 @@ static int nfc_genl_llc_set_params(struc
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}
@@ -1160,7 +1159,6 @@ static int nfc_genl_llc_sdreq(struct sk_
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}


