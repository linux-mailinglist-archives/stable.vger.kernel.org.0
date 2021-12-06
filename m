Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDC1469D09
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345604AbhLFP2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40690 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350166AbhLFPW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7371261321;
        Mon,  6 Dec 2021 15:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F4DC341C2;
        Mon,  6 Dec 2021 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803936;
        bh=KTCtJMeFMBN3q2EGNe/+FDI/POUAygWGJoTQBv/la8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9P3UaPOiXWIZfNmpCuJpxGQwijxP1CdnOzdhLH0mdl7YTUQI5ZDx6K7d/Z1x8USq
         3/J/jw7JelGUXRPhFAKnPGDKHv0rYKA8aAYPq1/LDhLr2PskscAhSOoTnv+88lt1J+
         MHS57l4WRnhKvTFduRvYcMD1RIzlC1H4vH8iyTn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Saurabh <ssaurabh@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 098/130] atlantic: Fix to display FW bundle version instead of FW mac version.
Date:   Mon,  6 Dec 2021 15:56:55 +0100
Message-Id: <20211206145603.040300891@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Saurabh <ssaurabh@marvell.com>

commit 2465c802232bc8d2b5bd83b55b08d05c11808704 upstream.

The correct way to reflect firmware version is to use bundle version.
Hence populating the same instead of MAC fw version.

Fixes: c1be0bf092bd2 ("net: atlantic: common functions needed for basic A2 init/deinit hw_ops")
Signed-off-by: Sameer Saurabh <ssaurabh@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -500,9 +500,9 @@ u32 hw_atl2_utils_get_fw_version(struct
 	hw_atl2_shared_buffer_read_safe(self, version, &version);
 
 	/* A2 FW version is stored in reverse order */
-	return version.mac.major << 24 |
-	       version.mac.minor << 16 |
-	       version.mac.build;
+	return version.bundle.major << 24 |
+	       version.bundle.minor << 16 |
+	       version.bundle.build;
 }
 
 int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,


