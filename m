Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC9E6B49B9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjCJPPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjCJPOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9332813B29F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:06:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36C5BB822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B1CC433D2;
        Fri, 10 Mar 2023 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460764;
        bh=u8BGxXeNeMfTLDftDVe1tr5HTuXiSx3ka5bkHanXLEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/fSRVZty9PbboTWEUgNVDc989KT+2zjimoLCgz6RarfB6Aq+Esun/HkJsfTDjXwL
         kwA4PFVufyu/0ZzBAGsaIYcPHx775I+cS14MI/ipZuB0H4o6uwVMIbJtaIXxR5bqdf
         oiMxCScKo+oG0X1jVyAxJH4ojrbJoOB/52v3VIlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 414/529] scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
Date:   Fri, 10 Mar 2023 14:39:17 +0100
Message-Id: <20230310133824.170657155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

commit 9b4f5028e493cb353a5c8f5c45073eeea0303abd upstream.

A fix for:

BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_process+0x949/0xe30 [ses]
Read of size 1 at addr ffff88a1b043a451 by task systemd-udevd/3271

Checking after (and before in next loop) addl_desc_ptr[1] is sufficient, we
expect the size to be sanitized before first access to addl_desc_ptr[1].
Make sure we don't walk beyond end of page.

Link: https://lore.kernel.org/r/20230202162451.15346-2-thenzl@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -603,9 +603,11 @@ static void ses_enclosure_data_process(s
 			     /* these elements are optional */
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
-			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
+			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)) {
 				addl_desc_ptr += addl_desc_ptr[1] + 2;
-
+				if (addl_desc_ptr + 1 >= ses_dev->page10 + ses_dev->page10_len)
+					addl_desc_ptr = NULL;
+			}
 		}
 	}
 	kfree(buf);


