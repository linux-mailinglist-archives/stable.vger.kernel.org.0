Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A570A68968C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbjBCK0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjBCK0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:26:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B92DA1444
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07FD61EC9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2A6C4339C;
        Fri,  3 Feb 2023 10:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419956;
        bh=5Ql//xyiGJLl8Ga0Js8lkb5AZkXI24aaadvwxvQXQwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWIZB2ZYMEotAqE1qR27F0moa0xgsXRrimJR9joLTUv4YLlSv8wyDOHeUvhFfbbsA
         BM1wbcoivtui241QAlky4BRtTpIHQMEocpSq0qGmXwUgXphZ28jfYXnrNiFhBzm2gU
         Nrj0KKRQalVRqeUhfPrLWiXQ/17hpIMlDpuJQdtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/134] HID: check empty report_list in bigben_probe()
Date:   Fri,  3 Feb 2023 11:12:18 +0100
Message-Id: <20230203101025.361076553@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit c7bf714f875531f227f2ef1fdcc8f4d44e7c7d9d ]

Add a check for empty report_list in bigben_probe().
The missing check causes a type confusion when issuing a list_entry()
on an empty report_list.
The problem is caused by the assumption that the device must
have valid report_list. While this will be true for all normal HID
devices, a suitably malicious device can violate the assumption.

Fixes: 256a90ed9e46 ("HID: hid-bigbenff: driver for BigBen Interactive PS3OFMINIPAD gamepad")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index e8c5e3ac9fff..e8b16665860d 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -344,6 +344,11 @@ static int bigben_probe(struct hid_device *hid,
 	}
 
 	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	if (list_empty(report_list)) {
+		hid_err(hid, "no output report found\n");
+		error = -ENODEV;
+		goto error_hw_stop;
+	}
 	bigben->report = list_entry(report_list->next,
 		struct hid_report, list);
 
-- 
2.39.0



