Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF66A4831CA
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiACOV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiACOVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:21:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89A9C06179E;
        Mon,  3 Jan 2022 06:21:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 774986111D;
        Mon,  3 Jan 2022 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC7FC36AEB;
        Mon,  3 Jan 2022 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219708;
        bh=Nm5zNV5nzs2S0sWDBFqt41qcKNKeJuleJ5hkANXoOxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rirq8QsBLD3mw8cGipoc3xifsOm5Ojil3+HBbpM1GnJUTu1z0zaqTXM0f0lYADnCM
         hMnsNitdDQsQuFBHuzrqZblYIcaS2KTvEfpvOS6/GM1A7v4dEnUQxyY+yGyhp6D3r6
         mPVcY3Z3XI8sfxcZ9sOuuqoXc/jqSTdFp9dte00w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 05/11] uapi: fix linux/nfc.h userspace compilation errors
Date:   Mon,  3 Jan 2022 15:21:16 +0100
Message-Id: <20220103142050.952302604@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
References: <20220103142050.763904028@linuxfoundation.org>
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
@@ -261,7 +261,7 @@ enum nfc_sdp_attr {
 #define NFC_SE_ENABLED  0x1
 
 struct sockaddr_nfc {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;
@@ -269,7 +269,7 @@ struct sockaddr_nfc {
 
 #define NFC_LLCP_MAX_SERVICE_NAME 63
 struct sockaddr_nfc_llcp {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;


