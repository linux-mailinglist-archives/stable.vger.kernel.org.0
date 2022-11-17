Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65A862E62E
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 21:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiKQUzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 15:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbiKQUzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 15:55:23 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 12:55:23 PST
Received: from mailfilter05-out40.webhostingserver.nl (mailfilter05-out40.webhostingserver.nl [195.211.74.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4545B5ADDD
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 12:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=jw62oI9VQIF8XDYXE+BEsn+Rf/63tDx8HvpIrdQjyEw=;
        b=fa1RsfUYHTA8bPHM1do9MoO+RXhXBNnuUQaN1wEkBp7is78v60lmIYssFw4ad00EnuA8vNfbLnZe+
         fZoKKRFIYO68+3FmdIFFrp9KkhvAE4DMluboV8l0BRX0uiyPCKl9LyFc2f37yhhNe5nKifhnlJWKff
         GbUS59TYgbIeHTNwEEjktDuEXlYyds4Cn6drhJcEld9UDoqli1P+EKIES7tDxQpaVZYuBfeTy0Rkc4
         71YPl9X8jmfbjRuSw91ZSA2FcJF6we+sUbEAX7C9ysqMlH8w6VgJ1l/ehsELfFx45D3IPVTgUfV0PM
         S5rYfWmOpV0Q3jzsnp4pGEe7rV3f6cg==
X-Halon-ID: ffc03dc5-66b9-11ed-9686-001a4a4cb933
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter05.webhostingserver.nl (Halon) with ESMTPSA
        id ffc03dc5-66b9-11ed-9686-001a4a4cb933;
        Thu, 17 Nov 2022 21:54:16 +0100 (CET)
Received: from 2a02-a466-68ed-1-6f6f-9a68-8ab0-3e9e.fixed6.kpn.net ([2a02:a466:68ed:1:6f6f:9a68:8ab0:3e9e] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1ovlto-0054mk-0i;
        Thu, 17 Nov 2022 21:54:16 +0100
From:   Ferry Toth <ftoth@exalondelft.nl>
To:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH v3 0/2] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date:   Thu, 17 Nov 2022 21:54:09 +0100
Message-Id: <20221117205411.11489-1-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v3:
- Correct commit message (Greg)
- Add fixes (Greg)

v2:
- Split into separate commits (Thinh)
- Only defer probe on -ETIMEDOUT (Thinh)
- Loose curly brackets (Heikki)

Ferry Toth (2):
  usb: ulpi: defer ulpi_register on ulpi_read_id timeout
  usb: dwc3: core: defer probe on ulpi_read_id timeout

 drivers/usb/common/ulpi.c | 2 +-
 drivers/usb/dwc3/core.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.37.2

