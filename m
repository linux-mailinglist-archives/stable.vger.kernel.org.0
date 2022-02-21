Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2226D4BDCA8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiBUJDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348312AbiBUJCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1862B2C106;
        Mon, 21 Feb 2022 00:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9D061152;
        Mon, 21 Feb 2022 08:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E60C340EB;
        Mon, 21 Feb 2022 08:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433873;
        bh=HKrIBi5m5CFXzZ+6/xBVUfB/8hJp8GunVilEDIKwwTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR0Ia0+XftoxZ2Nev8SPakCUk9LBtiQ2LkYGqgxi+G2dWHO9sIMj18JWG8NZsid41
         4r2j4YnL1SOsGWRRpf4som3kDMZvRVgBNyhHqCir3JCAoVw/ZpNhbq9jJlSyeplN0m
         ibv3Ukrf0sRmFyOkIHScgwc1FxziZg6Y5+OqqDl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 04/80] serial: parisc: GSC: fix build when IOSAPIC is not set
Date:   Mon, 21 Feb 2022 09:48:44 +0100
Message-Id: <20220221084915.714278330@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Randy Dunlap <rdunlap@infradead.org>

commit 6e8793674bb0d1135ca0e5c9f7e16fecbf815926 upstream.

There is a build error when using a kernel .config file from
'kernel test robot' for a different build problem:

hppa64-linux-ld: drivers/tty/serial/8250/8250_gsc.o: in function `.LC3':
(.data.rel.ro+0x18): undefined reference to `iosapic_serial_irq'

when:
  CONFIG_GSC=y
  CONFIG_SERIO_GSCPS2=y
  CONFIG_SERIAL_8250_GSC=y
  CONFIG_PCI is not set
    and hence PCI_LBA is not set.
  IOSAPIC depends on PCI_LBA, so IOSAPIC is not set/enabled.

Make the use of iosapic_serial_irq() conditional to fix the build error.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Suggested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_gsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_gsc.c
+++ b/drivers/tty/serial/8250/8250_gsc.c
@@ -26,7 +26,7 @@ static int __init serial_init_chip(struc
 	unsigned long address;
 	int err;
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && defined(CONFIG_IOSAPIC)
 	if (!dev->irq && (dev->id.sversion == 0xad))
 		dev->irq = iosapic_serial_irq(dev);
 #endif


