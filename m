Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353F551A698
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353854AbiEDQ4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353838AbiEDQyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624DA49901;
        Wed,  4 May 2022 09:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D09FDB8279F;
        Wed,  4 May 2022 16:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8F9C385A5;
        Wed,  4 May 2022 16:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682981;
        bh=hMmz/AZitYdKC3CJnrPaB6oZmtXcd0Tr3iu7sFPIod4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5ZnddwARoQAVT3QPNtaKRSmJnttbt/7BZ6ZNUGYbD6F9fro+qGr/SVvHK7wGZbPZ
         9RpsvIq4iBVMwQFX951rhwRxaQP+MQMTqE5fwijUfeQTkfI+qLPZ5570wk8ESMRa7e
         PmON9YdxMNVORMFQVRIYyeGoEkpX31WVMsVnkRdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 002/129] lightnvm: disable the subsystem
Date:   Wed,  4 May 2022 18:43:14 +0200
Message-Id: <20220504153021.546703914@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
@@ -5,7 +5,7 @@
 
 menuconfig NVM
 	bool "Open-Channel SSD target support"
-	depends on BLOCK
+	depends on BLOCK && BROKEN
 	help
 	  Say Y here to get to enable Open-channel SSDs.
 


