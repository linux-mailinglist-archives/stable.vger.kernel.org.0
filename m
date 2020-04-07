Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3621A0B10
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgDGKXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgDGKX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E2120801;
        Tue,  7 Apr 2020 10:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255008;
        bh=qAtiFLtErp5CaagbFlv5bSjeLFAc3rfDFA84TXWxh3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RluvpUbkORqlBjLYiPDpzlT6r0V5jWeqGc963ymX38TkwXjbro6GLYSnkp5K35qdR
         tbpizReATy0AE0AvD79SMV8C4Uge9fCS8ZrJVREOXwX5cdHo2Ud4Uj2A+VZKib5svw
         Ue1NqXC0CmFDNiQaraGRw7Ryf39hvMFZRPfmbqFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 29/36] iwlwifi: yoyo: dont add TLV offset when reading FIFOs
Date:   Tue,  7 Apr 2020 12:22:02 +0200
Message-Id: <20200407101458.020363607@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

commit a5688e600e78f9fc68102bf0fe5c797fc2826abe upstream.

The TLV offset is only used to read registers, while the offset used for
the FIFO addresses are hard coded in the driver and not given by the
TLV.

If we try to apply the TLV offset when reading the FIFOs, we'll read
from invalid addresses, causing the driver to hang.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: 8d7dea25ada7 ("iwlwifi: dbg_ini: implement Rx fifos dump")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151129.fbab869c26fa.I4ddac20d02f9bce41855a816aa6855c89bc3874e@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1373,11 +1373,7 @@ static int iwl_dump_ini_rxf_iter(struct
 		goto out;
 	}
 
-	/*
-	 * region register have absolute value so apply rxf offset after
-	 * reading the registers
-	 */
-	offs += rxf_data.offset;
+	offs = rxf_data.offset;
 
 	/* Lock fence */
 	iwl_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offs, 0x1);


