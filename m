Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8144859427A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350113AbiHOVuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349789AbiHOVsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:48:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A452B2AE14;
        Mon, 15 Aug 2022 12:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9735CE12C4;
        Mon, 15 Aug 2022 19:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C2DC433C1;
        Mon, 15 Aug 2022 19:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591920;
        bh=rlc+TygH3/TDpI6G8/9xUMPvuJv/ForyaE2lXM7vA8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wawT3C1aSwX6ayJs/hfOobHUdS6EMEUnRXd7ilLG8QzEwAuIWplEQrpuPNpQcXG9
         G2se+gsKZ7xF7yXYauLKd6MZ6hMK8786a/8iDuPIQ89ReUOkdae9Ds4iBNsaxxXXWv
         fNRYFb7Lse+8SCgtLrIgW5aZVUULxfnk8AZDJOUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0704/1095] usb: host: xhci: use snprintf() in xhci_decode_trb()
Date:   Mon, 15 Aug 2022 20:01:43 +0200
Message-Id: <20220815180458.494210801@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 1ce69c35b86038dd11d3a6115a04501c5b89a940 ]

Commit cbf286e8ef83 ("xhci: fix unsafe memory usage in xhci tracing")
apparently missed one sprintf() call in xhci_decode_trb() -- replace
it with the snprintf() call as well...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: cbf286e8ef83 ("xhci: fix unsafe memory usage in xhci tracing")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220630124645.1805902-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1f3f311d9951..1d60e62752f3 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2393,7 +2393,7 @@ static inline const char *xhci_decode_trb(char *str, size_t size,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_STOP_RING:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: slot %d sp %d ep %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_SLOT_ID(field3),
-- 
2.35.1



