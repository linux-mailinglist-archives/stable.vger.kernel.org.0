Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE0F4D7FF
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfFTSVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfFTSLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:11:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C542084E;
        Thu, 20 Jun 2019 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054309;
        bh=XSmt2kupemjqB1GXrcptmo3Q9SLtuR3ACvyPs23UnSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u892Q8TOYUlB1lsCWxn2VETyh4bC7ynvvPnyR7nw+jA0qWqKMLqQM4tfpoQG5TlmX
         jgIBl/WYGk8w5HKYDnclLC0If0UubzO/Tp2nQszb9hmaeo9YH5AhDMAKiqA/pAeDZa
         eMTzctmFvCB5IVo3Dl4HRS8x2amDFEHFutQkCPSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/61] nfc: Ensure presence of required attributes in the deactivate_target handler
Date:   Thu, 20 Jun 2019 19:57:04 +0200
Message-Id: <20190620174338.988938201@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>

[ Upstream commit 385097a3675749cbc9e97c085c0e5dfe4269ca51 ]

Check that the NFC_ATTR_TARGET_INDEX attributes (in addition to
NFC_ATTR_DEVICE_INDEX) are provided by the netlink client prior to
accessing them. This prevents potential unhandled NULL pointer dereference
exceptions which can be triggered by malicious user-mode programs,
if they omit one or both of these attributes.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -922,7 +922,8 @@ static int nfc_genl_deactivate_target(st
 	u32 device_idx, target_idx;
 	int rc;
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+	    !info->attrs[NFC_ATTR_TARGET_INDEX])
 		return -EINVAL;
 
 	device_idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);


