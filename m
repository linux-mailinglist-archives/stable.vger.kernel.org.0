Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440C16D472F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjDCOR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbjDCOR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E947EDC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9704BB81B94
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5B3C433D2;
        Mon,  3 Apr 2023 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531473;
        bh=Z5GpQM+QAhsfF597PZFvl/e2AmL7v7i5JiSZtIY63Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3t2noc6LN+NaYdeCKaoNIWD7vbiFz98KqD7F+guMtyCVPAHOMpjHNamM5UV+WALE
         RiQWl0Frr0n+ryqHBzYI62r/Bqv1lVTTni+Eyl7HhCpKLu/K9kkjsomlFg+BsQpP0r
         7C5QMq+hn3bDAXy3H5JX7YH7T9tWGydsVjSEa0v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 77/84] usb: host: ohci-pxa27x: Fix and & vs | typo
Date:   Mon,  3 Apr 2023 16:09:18 +0200
Message-Id: <20230403140356.065882986@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
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
@@ -148,7 +148,7 @@ static int pxa27x_ohci_select_pmm(struct
 		uhcrhda |= RH_A_NPS;
 		break;
 	case PMM_GLOBAL_MODE:
-		uhcrhda &= ~(RH_A_NPS & RH_A_PSM);
+		uhcrhda &= ~(RH_A_NPS | RH_A_PSM);
 		break;
 	case PMM_PERPORT_MODE:
 		uhcrhda &= ~(RH_A_NPS);


