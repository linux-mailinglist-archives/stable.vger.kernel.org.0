Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF08F541E3C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379207AbiFGW12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383192AbiFGWZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:25:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDFF26EEB6;
        Tue,  7 Jun 2022 12:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 337FDB823D6;
        Tue,  7 Jun 2022 19:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883B5C385A2;
        Tue,  7 Jun 2022 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629763;
        bh=b4XcJOUUruZ4QMXHty+HkTdu2vurMQ51l8/uCb2gwtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJCXFyXSThyhkAfIONI5waJtg+QARfAd9NcpU9oesMGDIXaj4vZaLNz23rYGigZ6V
         TI+oDmt2HVGhG3P7j9kWOaws7LhllNp/PEH7068yXPszzWS6XEPubk/8KKyXL+WPlO
         y763xCWexzoe2NmMr+u0fbGuOjcW7swtGKVYNDM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.18 768/879] scsi: dc395x: Fix a missing check on list iterator
Date:   Tue,  7 Jun 2022 19:04:46 +0200
Message-Id: <20220607165025.155491835@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 036a45aa587a10fa2abbd50fbd0f6c4cfc44f69f upstream.

The bug is here:

	p->target_id, p->target_lun);

The list iterator 'p' will point to a bogus position containing HEAD if the
list is empty or no element is found. This case must be checked before any
use of the iterator, otherwise it will lead to an invalid memory access.

To fix this bug, add a check. Use a new variable 'iter' as the list
iterator, and use the original variable 'p' as a dedicated pointer to point
to the found element.

Link: https://lore.kernel.org/r/20220414040231.2662-1-xiam0nd.tong@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/dc395x.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3585,10 +3585,19 @@ static struct DeviceCtlBlk *device_alloc
 #endif
 	if (dcb->target_lun != 0) {
 		/* Copy settings */
-		struct DeviceCtlBlk *p;
-		list_for_each_entry(p, &acb->dcb_list, list)
-			if (p->target_id == dcb->target_id)
+		struct DeviceCtlBlk *p = NULL, *iter;
+
+		list_for_each_entry(iter, &acb->dcb_list, list)
+			if (iter->target_id == dcb->target_id) {
+				p = iter;
 				break;
+			}
+
+		if (!p) {
+			kfree(dcb);
+			return NULL;
+		}
+
 		dprintkdbg(DBG_1, 
 		       "device_alloc: <%02i-%i> copy from <%02i-%i>\n",
 		       dcb->target_id, dcb->target_lun,


