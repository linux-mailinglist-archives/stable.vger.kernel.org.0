Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D49229B359
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766390AbgJ0Osd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766354AbgJ0Osc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16C5D20709;
        Tue, 27 Oct 2020 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810111;
        bh=cBMZnvCPaSBSJCeUoP9saVibsvUQ8l6AWk2wJczyEyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or3HoqrOGb+ARe9qEHpS3SxhpZGkRiqRGXajeHC8FT8CSNhdUPr0gLKdQsQ7siA4P
         vcZnhwXoQ4qjNquVF8XRcmUCYm9Xvo8SUJEz+E8zOUvcd71kuFj9XhzU7gul29iW8w
         Z1GG8aaneqcBd89O49lRKqIkYTKzmHPaq04SAbKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.8 025/633] r8169: fix data corruption issue on RTL8402
Date:   Tue, 27 Oct 2020 14:46:08 +0100
Message-Id: <20201027135523.883563313@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ef9da46ddef071e1bbb943afbbe9b38771855554 ]

Petr reported that after resume from suspend RTL8402 partially
truncates incoming packets, and re-initializing register RxConfig
before the actual chip re-initialization sequence is needed to avoid
the issue.

Reported-by: Petr Tesarik <ptesarik@suse.cz>
Proposed-by: Petr Tesarik <ptesarik@suse.cz>
Tested-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4871,6 +4871,10 @@ static int __maybe_unused rtl8169_resume
 	if (netif_running(tp->dev))
 		__rtl8169_resume(tp);
 
+	/* Reportedly at least Asus X453MA truncates packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	return 0;
 }
 


