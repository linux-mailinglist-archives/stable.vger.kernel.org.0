Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1575BAABE
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiIPKZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiIPKXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959786474;
        Fri, 16 Sep 2022 03:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CBBCB82547;
        Fri, 16 Sep 2022 10:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D594BC433D6;
        Fri, 16 Sep 2022 10:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323270;
        bh=m0CCmXn+DRNmptGEaAfo1O1jNqKFsxS0zWNvH9+boSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNU6XRg4Yvin7gXgO6DGWJ/BxZk4/XL0Y4n/a4YsMSty6G/b7/lec0E5FPQu4IRvl
         NJsZAAdkaHG8nns6qbNK0/3d1fKQD3KpkN7GbtqLq99ovBZghcB39CV5LdtCJ2JxeD
         psU2hno+hUvWSq720gk0TgswuECDKNA3kgbBurco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hu Xiaoying <huxiaoying@kylinos.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 31/38] usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS
Date:   Fri, 16 Sep 2022 12:09:05 +0200
Message-Id: <20220916100449.770519891@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hu Xiaoying <huxiaoying@kylinos.cn>

[ Upstream commit c61feaee68b9735be06f162bc046c7f1959efb0c ]

USB external storage device(0x0b05:1932), use gnome-disk-utility tools
to test usb write  < 30MB/s.
if does not to load module of uas for this device, can increase the
write speed from 20MB/s to >40MB/s.

Suggested-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hu Xiaoying <huxiaoying@kylinos.cn>
Link: https://lore.kernel.org/r/20220901045737.3438046-1-huxiaoying@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 4051c8cd0cd8a..23ab3b048d9be 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -62,6 +62,13 @@ UNUSUAL_DEV(0x0984, 0x0301, 0x0128, 0x0128,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
 
+/* Reported-by: Tom Hu <huxiaoying@kylinos.cn> */
+UNUSUAL_DEV(0x0b05, 0x1932, 0x0000, 0x9999,
+		"ASUS",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: David Webb <djw@noc.ac.uk> */
 UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		"Seagate",
-- 
2.35.1



