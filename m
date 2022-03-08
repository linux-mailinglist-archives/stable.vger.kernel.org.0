Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745A24D1BF2
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347857AbiCHPmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344551AbiCHPml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:42:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F74ECE7;
        Tue,  8 Mar 2022 07:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646754105; x=1678290105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Svmpa5a1Mig8SFByV7N48trL4Ve70J5aZwb03ZhVga0=;
  b=Sc8ogQyqxZLE5JOeoHTCNw4rFa0E8bXasPDNCSHjmaeRo5boAKHoelbI
   IRotkW+xxX7PavfJtd0gigQUtg41FnUjV6AwZkGQbBgpQIMJXTW6jRstu
   9lpBVf1INWKQM9UVxFnJefcllvpX2goDPeFebavRbARFRUouNkAry8wqY
   5zeZcaFSBgQFOVPpO/+i3495zjt6x3NprYZ0cX032g3sF1hwbhLacC6zc
   uS4rbEYu/uFjK9t1sqgFWnPihUO5ekIk5xpRXzgVgTmzT8V8SgWo9NAux
   2eIp1/0rKM8uxXrzX0IPcq8eZxj+H471RVhEEH9rTkXsQoEo2WDRP50FU
   A==;
X-IronPort-AV: E=Sophos;i="5.90,165,1643698800"; 
   d="scan'208";a="164948817"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 08:41:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 08:41:44 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 8 Mar 2022 08:41:42 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>, <p.yadav@ti.com>,
        <michael@walle.cc>
CC:     <linux-mtd@lists.infradead.org>, <stable@vger.kernel.org>,
        <nicolas.ferre@microchip.com>, <richard@nod.at>,
        <linux-kernel@vger.kernel.org>, <vigneshr@ti.com>,
        <miquel.raynal@bootlin.com>
Subject: Re: [PATCH] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set
Date:   Tue, 8 Mar 2022 17:41:39 +0200
Message-ID: <164675405078.4788.10976712851332781674.b4-ty@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228163334.277730-1-tudor.ambarus@microchip.com>
References: <20220228163334.277730-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:33:34 +0200, Tudor Ambarus wrote:
> Even if SPI_NOR_NO_ERASE was set, one could still send erase opcodes
> to the flash. It is not recommended to send unsupported opcodes to
> flashes. Fix the logic and do not set mtd->_erase when SPI_NOR_NO_ERASE
> is specified. With this users will not be able to issue erase opcodes to
> flashes and instead they will recive an -ENOTSUPP error.

Applied to spi-nor/next, thanks!

[1/1] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set
      https://git.kernel.org/mtd/c/151c6b49d679

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@microchip.com>
