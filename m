Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0AB8D8EA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfHNRDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbfHNRDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1656F214DA;
        Wed, 14 Aug 2019 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802217;
        bh=CoPGPtaIX+GCfu6wF7OH5MxGzuQJ7Y8ZXc/iPospVPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qcf3OPVlCisTP2ilgQmg4eRq9JQkbB+dmtHL2IBtbEiVxNyMbfeiwDn3sRxrl1FX0
         4o3jfhdOV/QE+TQSaRfjvWuNb91g0CKy630WWlKHQQJmu5f4FdSXD9Bz1Mj3+MAflA
         QabmDGdeheijwWKH0NtgZC0QLywonqWwPkczt+dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.2 040/144] usb: typec: ucsi: ccg: Fix uninitilized symbol error
Date:   Wed, 14 Aug 2019 18:59:56 +0200
Message-Id: <20190814165801.510168506@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit a29d56c2ed24ad33062bfdafdec9e34149715320 upstream.

Fix smatch error:
drivers/usb/typec/ucsi/ucsi_ccg.c:975 ccg_fw_update() error: uninitialized symbol 'err'.

Fixes: 5c9ae5a87573 ("usb: typec: ucsi: ccg: add firmware flashing support")
Cc: stable@vger.kernel.org
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20190801075512.24354-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -963,7 +963,7 @@ release_fw:
  ******************************************************************************/
 static int ccg_fw_update(struct ucsi_ccg *uc, enum enum_flash_mode flash_mode)
 {
-	int err;
+	int err = 0;
 
 	while (flash_mode != FLASH_NOT_NEEDED) {
 		err = do_flash(uc, flash_mode);


