Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154FA514715
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357581AbiD2KpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357651AbiD2KpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73F2B7C78;
        Fri, 29 Apr 2022 03:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C42662352;
        Fri, 29 Apr 2022 10:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A424C385AD;
        Fri, 29 Apr 2022 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228906;
        bh=NUGlQeqKpspHLOxESNbDq3TkMZdjeyAo1V/shdzLVZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJBKpJU5/Iaq6DP6Wl4QywEVR/1ylNfpvPrj4G6VceCc3wRQ4/O9LrdvTbpHJniZH
         MWT1EWzreCX5Al/9Z2kM4+GvQrPK+grYKiBXp0x3N3nvVseqtgaDYMi12KaZ1BtI7Y
         wd1jpZbeQ7EZQabbjNMPNro8su0gSxTGaeHgfh6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 12/12] lightnvm: disable the subsystem
Date:   Fri, 29 Apr 2022 12:41:29 +0200
Message-Id: <20220429104048.820510483@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 9ea9b9c48387 ("remove the lightnvm subsystem") the lightnvm
subsystem was removed as there is no hardware in the wild for it, and
the code is known to have problems.  This should also be disabled for
older LTS kernels as well to prevent anyone from accidentally using it.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Matias Bjørling <mb@lightnvm.io>
Cc: Javier González <javier@javigon.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/lightnvm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/lightnvm/Kconfig
+++ b/drivers/lightnvm/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig NVM
 	bool "Open-Channel SSD target support"
-	depends on BLOCK && PCI
+	depends on BLOCK && PCI && BROKEN
 	select BLK_DEV_NVME
 	help
 	  Say Y here to get to enable Open-channel SSDs.


