Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB5055130E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiFTImr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239977AbiFTImi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:42:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E23E12AF1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655714556; x=1687250556;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-id;
  bh=NBDsmTcjDugeOdw78byBBXLFfzh3XmasPDeyDPQGp2o=;
  b=Xj+do997qC8pHg8vH62277w3e1qVrrngQ82h8jIzqf+5QaQcipVRhhRe
   O2mCb95xbfyt0f/uIIZ6XapiJ4uXEYKCJtT6nG5HlecXjm5bSJiijYy4G
   go/Wh92rCL+N3Oefk3A/dOZKIZkGkJ7MnDRcdJbVCTSCrNCQ97qKhI3HT
   rar9q2kQx+D03wUlop3tXXP6yWwzwWMi7sRjYkWLCnAKNvSc/theKaM9k
   RFecbl5af+qPz68hO/tAJEIXTtf7mrwbZK9KK26xTliaYlkDeYdl6cdoZ
   uB8dWhqEZYISFEdyq6P6qeaANEB91861KoX5bVUdOgQe0Vxk44hW0/SiQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343832566"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343832566"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:42:35 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="643013743"
Received: from lspinell-mobl1.ger.corp.intel.com ([10.251.215.169])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:42:33 -0700
Date:   Mon, 20 Jun 2022 11:42:31 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     stable@kernel.org
cc:     u.kleine-koenig@pengutronix.de, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable-5.18 (and below)] serial: 8250: Store to lsr_save_flags
 after lsr read
Message-ID: <c41374bb-b114-ef16-aa15-f01d96f351cc@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-841741294-1655714122=:2433"
Content-ID: <5128313-ff47-2673-3d7-87f2ed327de@linux.intel.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-841741294-1655714122=:2433
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <4f9dd1a0-6968-122a-57cc-466c948a71a@linux.intel.com>

[ Upstream commit be03b0651ffd8bab69dfd574c6818b446c0753ce ]

Not all LSR register flags are preserved across reads. Therefore, LSR
readers must store the non-preserved bits into lsr_save_flags.

This fix was initially mixed into feature commit f6f586102add ("serial:
8250: Handle UART without interrupt on TEMT using em485"). However,
that feature change had a flaw and it was reverted to make room for
simpler approach providing the same feature. The embedded fix got
reverted with the feature change.

Re-add the lsr_save_flags fix and properly mark it's a fix.

Link: https://lore.kernel.org/all/1d6c31d-d194-9e6a-ddf9-5f29af829f3@linux.intel.com/T/#m1737eef986bd20cf19593e344cebd7b0244945fc
Fixes: e490c9144cfa ("tty: Add software emulated RS485 support for 8250")
Cc: stable <stable@kernel.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/f4d774be-1437-a550-8334-19d8722ab98c@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Here's the backport for 5.18. I think it applies fine to older kernel 
versions too.

 drivers/tty/serial/8250/8250_port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 1fbd5bf264be..7e295d2701b2 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1535,6 +1535,8 @@ static inline void __stop_tx(struct uart_8250_port *p)
 
 	if (em485) {
 		unsigned char lsr = serial_in(p, UART_LSR);
+		p->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
 		/*
 		 * To provide required timeing and allow FIFO transfer,
 		 * __stop_tx_rs485() must be called only when both FIFO and
-- 
2.30.2
--8323329-841741294-1655714122=:2433--
