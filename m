Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB5C6D46D2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjDCOO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjDCOO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7624ECB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52DE1B81B38
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA3C433D2;
        Mon,  3 Apr 2023 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531263;
        bh=N9CUN0PygrK7ljgrPQ4Jem6IAB6ahT7pNwV1E4Mzm3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcYPBj5YThJUF60s3iToUWfJNGDr6ijpKaEi4TU9tIFm6d49QzQIoldBvWihw4MTx
         K/1WsabclYhFZN+VVc/TvJBKg6KASpj1O9ecqdDi4oRp+yzPieef3E4snpSIZL4qA8
         YSF1wOgyEljPs5zXMfcWZZ4pEeqH9qoxke7yWVFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 63/66] usb: host: ohci-pxa27x: Fix and & vs | typo
Date:   Mon,  3 Apr 2023 16:09:11 +0200
Message-Id: <20230403140353.973996550@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0709831a50d31b3caf2237e8d7fe89e15b0d919d upstream.

The code is supposed to clear the RH_A_NPS and RH_A_PSM bits, but it's
a no-op because of the & vs | typo.  This bug predates git and it was
only discovered using static analysis so it must not affect too many
people in real life.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20190817065520.GA29951@mwanda
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-pxa27x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -147,7 +147,7 @@ static int pxa27x_ohci_select_pmm(struct
 		uhcrhda |= RH_A_NPS;
 		break;
 	case PMM_GLOBAL_MODE:
-		uhcrhda &= ~(RH_A_NPS & RH_A_PSM);
+		uhcrhda &= ~(RH_A_NPS | RH_A_PSM);
 		break;
 	case PMM_PERPORT_MODE:
 		uhcrhda &= ~(RH_A_NPS);


