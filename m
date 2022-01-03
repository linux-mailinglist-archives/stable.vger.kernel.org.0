Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8609F483228
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiACOZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:31 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47046 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiACOZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AF75CE10AB;
        Mon,  3 Jan 2022 14:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA565C36AEB;
        Mon,  3 Jan 2022 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219922;
        bh=81FEi5KOVRIXz2dOtAN0oZn0JSOlVOsOo5u44K4BUO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7DDI/Vo1FZpvc9C7Xv1shou01VGoKp3EkxFdm/XsUMbfjkEJJ0Hi84LcSiO/JOAJ
         ZMEKRwjg4KQ+s2FDyfoTyKU7Lm+Ww+JQwd7gk4pWb6tlHkeLK13DXKKJzGcudrmJdS
         2y6OmRgl2C+pw74hY4W6QDxe6wpwzfaBLdxBwbx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 19/27] uapi: fix linux/nfc.h userspace compilation errors
Date:   Mon,  3 Jan 2022 15:23:59 +0100
Message-Id: <20220103142052.791879422@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry V. Levin <ldv@altlinux.org>

commit 7175f02c4e5f5a9430113ab9ca0fd0ce98b28a51 upstream.

Replace sa_family_t with __kernel_sa_family_t to fix the following
linux/nfc.h userspace compilation errors:

/usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
  sa_family_t sa_family;
/usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
  sa_family_t sa_family;

Fixes: 23b7869c0fd0 ("NFC: add the NFC socket raw protocol")
Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/nfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -263,7 +263,7 @@ enum nfc_sdp_attr {
 #define NFC_SE_ENABLED  0x1
 
 struct sockaddr_nfc {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;
@@ -271,7 +271,7 @@ struct sockaddr_nfc {
 
 #define NFC_LLCP_MAX_SERVICE_NAME 63
 struct sockaddr_nfc_llcp {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;


