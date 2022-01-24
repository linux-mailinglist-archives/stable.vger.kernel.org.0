Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF6E499BC8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574386AbiAXVzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452445AbiAXVsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:48:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183F4C081197;
        Mon, 24 Jan 2022 12:32:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE1B26153A;
        Mon, 24 Jan 2022 20:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43F5C340E5;
        Mon, 24 Jan 2022 20:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056375;
        bh=bvRgmzztybuxgeiocEHbhGy+hF9oTXJZSdyxIsdtvhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qG3OFeHORoese6DMlw7khWFIT4h5SxVWwhwoSiUtwWJqmK+8eNS5/2aiV9YPXjMzc
         ABNtl4bocVxZS3tWnNtB9JsZUjokS9LJ+BYNakhomNtxLKh8RJ+afWACepNf6SitrA
         yK9Jc6SDYQIKrZRe3eFm7IFXbUOHpnzq0limcy1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/846] Bluetooth: Fix removing adv when processing cmd complete
Date:   Mon, 24 Jan 2022 19:39:39 +0100
Message-Id: <20220124184116.918866562@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 2128939fe2e771645dd88e1938c27fdf96bd1cd0 ]

If we remove one instance of adv using Set Extended Adv Enable, there
is a possibility of issue occurs when processing the Command Complete
event. Especially, the adv_info might not be found since we already
remove it in hci_req_clear_adv_instance() -> hci_remove_adv_instance().
If that's the case, we will mistakenly proceed to remove all adv
instances instead of just one single instance.

This patch fixes the issue by checking the content of the HCI command
instead of checking whether the adv_info is found.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 50d1d62c15ec8..20e36126bbdae 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1325,8 +1325,10 @@ static void hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev,
 					   &conn->le_conn_timeout,
 					   conn->conn_timeout);
 	} else {
-		if (adv) {
-			adv->enabled = false;
+		if (cp->num_of_sets) {
+			if (adv)
+				adv->enabled = false;
+
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
 			 */
-- 
2.34.1



