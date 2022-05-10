Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CEA52172D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiEJNXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbiEJNVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C8B2C3354;
        Tue, 10 May 2022 06:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C4CCB81DA5;
        Tue, 10 May 2022 13:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01974C385CE;
        Tue, 10 May 2022 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188522;
        bh=nbW0eEsimMVjlHNbmfDsIhmqa2VhhW8vzws7CUyZMzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+fwc+glpETUpm8GfsVDak4lWMdKQB24A0FIvN+Nj+Er5pR9CZB4QUSB1JVDWV8fj
         SfQzPYaszqRYylwHE41pto19gDrRYfgdgDFu6G1aTsifKPN5Vq21eHKMLiIFy2ZL09
         WFelJzMTXoJzbMepQZouetuDxvkwGMwDAoNs1/Lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 06/78] lightnvm: disable the subsystem
Date:   Tue, 10 May 2022 15:06:52 +0200
Message-Id: <20220510130732.716003625@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
-	depends on BLOCK && HAS_DMA
+	depends on BLOCK && HAS_DMA && BROKEN
 	help
 	  Say Y here to get to enable Open-channel SSDs.
 


