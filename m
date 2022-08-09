Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A8058DED6
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245734AbiHISYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343519AbiHISWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:22:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225D52872F;
        Tue,  9 Aug 2022 11:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77DB2B818AF;
        Tue,  9 Aug 2022 18:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD804C43470;
        Tue,  9 Aug 2022 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068449;
        bh=+vJskcDitlf+1EjDn+hcxj0rA5Uriic/6Rh7abIhVGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcjxM2kdhGzmGU0HrLOpyZVHn0n87U+7dyBxtWzApnbevO7FapOb7A78NdRRVeCoS
         j0JwRcVh+Q5/vryHQ8oEFPTH1OgERfTBnBPWeXLQxf6LeF7cmKmI4MS6huWCARmdPK
         YJ8Di90m3+4nzmNh4DlquJY0l+UXesXymxKZhptk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Teja Aluvala <quic_saluvala@quicinc.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.18 23/35] Bluetooth: hci_qca: Return wakeup for qca_wakeup
Date:   Tue,  9 Aug 2022 20:00:52 +0200
Message-Id: <20220809175515.907662332@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
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

From: Sai Teja Aluvala <quic_saluvala@quicinc.com>

commit bde63e9effd3a6ba384707c62abe46c32d22f665 upstream.

This fixes the return value of qca_wakeup(), since
.wakeup work inversely with original .prevent_wake.

Fixes: 4539ca67fe8ed (Bluetooth: Rename driver .prevent_wake to .wakeup)
Signed-off-by: Sai Teja Aluvala <quic_saluvala@quicinc.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index eab34e24d944..8df11016fd51 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1588,7 +1588,7 @@ static bool qca_wakeup(struct hci_dev *hdev)
 	wakeup = device_may_wakeup(hu->serdev->ctrl->dev.parent);
 	bt_dev_dbg(hu->hdev, "wakeup status : %d", wakeup);
 
-	return !wakeup;
+	return wakeup;
 }
 
 static int qca_regulator_init(struct hci_uart *hu)
-- 
2.37.1



