Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E94459DB7B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbiHWLcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbiHWL3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D275C57B6;
        Tue, 23 Aug 2022 02:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 111EE6130E;
        Tue, 23 Aug 2022 09:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0676BC433C1;
        Tue, 23 Aug 2022 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246725;
        bh=2qWzSu005KhCZKCiQj4XzI9joxbuxc5CFtp+2bHxyh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE5e+eG6VSpiteHh8OLxhwMNvreO/WOfInn856r+16KkPLimFsv8amXsq9Ku2ZRlw
         yKU1Cqv6G4v4UO1/ihoOfgDUsjHpq/CJwNbgyFj7Ag9QiSWYCrntu4lPhqjuhJv9+u
         vw8YRzpz1zuTdUz/6u+Ay2FL0WIqFanPTXLPEvm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/389] usb: host: xhci: use snprintf() in xhci_decode_trb()
Date:   Tue, 23 Aug 2022 10:24:07 +0200
Message-Id: <20220823080122.685453474@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index a9031f494984..5a6ad776858e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2376,7 +2376,7 @@ static inline const char *xhci_decode_trb(char *str, size_t size,
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



