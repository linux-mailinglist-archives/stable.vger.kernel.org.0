Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0020252646B
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380739AbiEMObp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381249AbiEMObM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262481A491F;
        Fri, 13 May 2022 07:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FEA1621C6;
        Fri, 13 May 2022 14:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7531CC34100;
        Fri, 13 May 2022 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452139;
        bh=0AS3WTNh5PqABpO2Yux3JZXorugd5NxI7pJpglgrU9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7z+KLxKXDisfxVhgLjzAxzp2liY7B57Ghf/9A+Q8rD6xaGoMJX7uPDzHzcOglpHd
         jsCKTcxFln3hlJUqaMhM76RokX3Cp84+gkP0GshhoBfmKGFwu6pocCxr7uLtjDOCGd
         Q5ObmdeRNk1k/dqU3cNm/9cMWdtbDMfjohmoEWEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Itay Iellin <ieitayie@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 12/21] Bluetooth: Fix the creation of hdev->name
Date:   Fri, 13 May 2022 16:23:54 +0200
Message-Id: <20220513142230.233660570@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Itay Iellin <ieitayie@gmail.com>

commit 103a2f3255a95991252f8f13375c3a96a75011cd upstream.

Set a size limit of 8 bytes of the written buffer to "hdev->name"
including the terminating null byte, as the size of "hdev->name" is 8
bytes. If an id value which is greater than 9999 is allocated,
then the "snprintf(hdev->name, sizeof(hdev->name), "hci%d", id)"
function call would lead to a truncation of the id value in decimal
notation.

Set an explicit maximum id parameter in the id allocation function call.
The id allocation function defines the maximum allocated id value as the
maximum id parameter value minus one. Therefore, HCI_MAX_ID is defined
as 10000.

Signed-off-by: Itay Iellin <ieitayie@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    3 +++
 net/bluetooth/hci_core.c         |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -35,6 +35,9 @@
 /* HCI priority */
 #define HCI_PRIO_MAX	7
 
+/* HCI maximum id value */
+#define HCI_MAX_ID 10000
+
 /* HCI Core structures */
 struct inquiry_data {
 	bdaddr_t	bdaddr;
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3907,10 +3907,10 @@ int hci_register_dev(struct hci_dev *hde
 	 */
 	switch (hdev->dev_type) {
 	case HCI_PRIMARY:
-		id = ida_simple_get(&hci_index_ida, 0, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 0, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	case HCI_AMP:
-		id = ida_simple_get(&hci_index_ida, 1, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 1, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	default:
 		return -EINVAL;
@@ -3919,7 +3919,7 @@ int hci_register_dev(struct hci_dev *hde
 	if (id < 0)
 		return id;
 
-	sprintf(hdev->name, "hci%d", id);
+	snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
 	hdev->id = id;
 
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);


