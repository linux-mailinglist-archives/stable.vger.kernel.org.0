Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831D1461DDD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhK2S36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60850 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378709AbhK2S15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DADF2B815C9;
        Mon, 29 Nov 2021 18:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B20C53FC7;
        Mon, 29 Nov 2021 18:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210277;
        bh=M2x2xTghd3P1I7w96dfCHfLQWa9qGidy1rj0fbxp2ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iROyrAG5s9xc5wUL/zAGxnZ2BJi4JnR07bECTxlbzOH9pQNGfh5rg5Ob9ITLj0jlQ
         8uyGGomisWBONbIzFvLPH8Gv3fGTsuOWU5I16CU4TWkkrLUq9kRRyxVuvCsO7PPfl0
         CMMDhkdzhIcY7pDyZwkaCrwWGADkqHdLeuzapIUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 31/92] PCI: aardvark: Fix compilation on s390
Date:   Mon, 29 Nov 2021 19:18:00 +0100
Message-Id: <20211129181708.446803446@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b32c012e4b98f0126aa327be2d1f409963057643 upstream.

Include linux/gpio/consumer.h instead of linux/gpio.h, as is said in the
latter file.

This was reported by kernel test bot when compiling for s390.

  drivers/pci/controller/pci-aardvark.c:350:2: error: implicit declaration of function 'gpiod_set_value_cansleep' [-Werror,-Wimplicit-function-declaration]
  drivers/pci/controller/pci-aardvark.c:1074:21: error: implicit declaration of function 'devm_gpiod_get_from_of_node' [-Werror,-Wimplicit-function-declaration]
  drivers/pci/controller/pci-aardvark.c:1076:14: error: use of undeclared identifier 'GPIOD_OUT_LOW'

Link: https://lore.kernel.org/r/202006211118.LxtENQfl%25lkp@intel.com
Link: https://lore.kernel.org/r/20200907111038.5811-2-pali@kernel.org
Fixes: 5169a9851daa ("PCI: aardvark: Issue PERST via GPIO")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/delay.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>


