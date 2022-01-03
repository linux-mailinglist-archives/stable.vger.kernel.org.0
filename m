Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2216C4832B1
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiACOaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58480 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiACO3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7EBB6104D;
        Mon,  3 Jan 2022 14:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B020BC36AEF;
        Mon,  3 Jan 2022 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220172;
        bh=81FEi5KOVRIXz2dOtAN0oZn0JSOlVOsOo5u44K4BUO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIB3Fv1xayHe2MIhb6ZHQTxg3BwG38B5omYhoBK8xJ1ROisoqVBw3eVhiHx7anFGi
         83AFwGClYqu/0z69eFk+rBsnmnCoE4ETcMsh5qaSjmoFPOQTkPvE5PnBrBq0HrpzQH
         1l1ifhCY0gspBAFGYAIK0qA+63foqG8GO0xdDu2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 34/48] uapi: fix linux/nfc.h userspace compilation errors
Date:   Mon,  3 Jan 2022 15:24:11 +0100
Message-Id: <20220103142054.625924517@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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


