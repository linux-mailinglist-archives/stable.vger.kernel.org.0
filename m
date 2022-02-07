Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA24AB6B7
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbiBGIWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348047AbiBGITC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:19:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DE6C0401DA
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EA7BCE0EDF
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA51C004E1;
        Mon,  7 Feb 2022 08:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644221934;
        bh=EJiw6S7Rm4AIzjEOopmpGFi66MgqlD7IXTizBtwaeYw=;
        h=Subject:To:Cc:From:Date:From;
        b=KIrzCH7o5O8GIl89uebi9R9ootkYtIAvI2tk4QqSmYD0V6VP8AJsllumkmNksIAci
         /2PYvpPw5wCXQamrjIAACHg8VhFnKLNnQ4972JZGmCAFksD8YpjfQ5eKBdo8I5hBFD
         LMDTVmg2SJQSjKn6JXsibqVx+Sn5KZXWR4j3PpXQ=
Subject: FAILED: patch "[PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY" failed to apply to 5.4-stable tree
To:     arinc.unal@arinc9.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 09:18:43 +0100
Message-ID: <1644221923225143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4223f86512877b04c932e7203648b37eec931731 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Date: Sat, 29 Jan 2022 09:27:04 +0300
Subject: [PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
properly control MT7530 and MT7531 switch PHYs.

A noticeable change is that the behaviour of switchport interfaces going
up-down-up-down is no longer there.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220129062703.595-1-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 7b1457a6e327..c0c91440340a 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -36,6 +36,7 @@ config NET_DSA_LANTIQ_GSWIP
 config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	select NET_DSA_TAG_MTK
+	select MEDIATEK_GE_PHY
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
 	  Ethernet switch chips.

