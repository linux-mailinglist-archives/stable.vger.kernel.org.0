Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C22593505
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiHOSSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbiHOSSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:18:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E622AC72;
        Mon, 15 Aug 2022 11:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73D45B80F99;
        Mon, 15 Aug 2022 18:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33D7C433C1;
        Mon, 15 Aug 2022 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587336;
        bh=Muz+6devd5UaSOJcMQZ9LRIIl260cRIsDAwDtiF54MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEOWEzZL325wHuNsKLTWQ+wJbcFpuwV1RUg3QSBlq1kDbtkLcK5nMXwrvQfHvKZiL
         dLXaglrG1hMcnPM1OVjeM7TFm6bbEZ6zSly3NcddCVC7tA3D7yAIJzgSdUfySfVo6E
         fnYnkc1SN+O8kk/ovYjgr8OcJKJbosOgPDp/rgvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 051/779] parisc: Check the return value of ioremap() in lba_driver_probe()
Date:   Mon, 15 Aug 2022 19:54:55 +0200
Message-Id: <20220815180339.461010784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: William Dean <williamsukatube@gmail.com>

commit cf59f34d7f978d14d6520fd80a78a5ad5cb8abf8 upstream.

The function ioremap() in lba_driver_probe() can fail, so
its return value should be checked.

Fixes: 4bdc0d676a643 ("remove ioremap_nocache and devm_ioremap_nocache")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/lba_pci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1476,9 +1476,13 @@ lba_driver_probe(struct parisc_device *d
 	u32 func_class;
 	void *tmp_obj;
 	char *version;
-	void __iomem *addr = ioremap(dev->hpa.start, 4096);
+	void __iomem *addr;
 	int max;
 
+	addr = ioremap(dev->hpa.start, 4096);
+	if (addr == NULL)
+		return -ENOMEM;
+
 	/* Read HW Rev First */
 	func_class = READ_REG32(addr + LBA_FCLASS);
 


