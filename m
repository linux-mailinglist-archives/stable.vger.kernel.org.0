Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D34549056
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358304AbiFMMGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358940AbiFMMFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:05:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851E650E00;
        Mon, 13 Jun 2022 03:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B8EAB80E92;
        Mon, 13 Jun 2022 10:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB3BC34114;
        Mon, 13 Jun 2022 10:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117898;
        bh=cpccPS9+uKZ8VJa9FHRnqiUYeEqykP6CLz8cBZeaY80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KchB3ZaOMSLeH/8QseAgMVHJZRZt3JL074hDXXEMvhVmXvCOp65haF0uOdzQzt0u
         p2FMEx6/jFpOh1hGqJTRdzcx5OGHclpvHaqtoX7bhdYXYqcMcfi3JJgJOdwugbSbuA
         QXED0nnJV2PlF0Fkb4DsRJPcRy8LPpFU6vSLKSMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 158/287] scsi: dc395x: Fix a missing check on list iterator
Date:   Mon, 13 Jun 2022 12:09:42 +0200
Message-Id: <20220613094928.671557257@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
@@ -3771,10 +3771,19 @@ static struct DeviceCtlBlk *device_alloc
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


