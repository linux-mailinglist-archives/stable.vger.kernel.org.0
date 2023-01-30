Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEB2680FE6
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbjA3N54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbjA3N5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:57:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F6F39CF8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:57:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 130F761026
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEC7C433D2;
        Mon, 30 Jan 2023 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087061;
        bh=5Ql//xyiGJLl8Ga0Js8lkb5AZkXI24aaadvwxvQXQwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dtx39kb/9XWTG4ns/uWT4sR0QAbxyldHdLwi2KdHPthWKh9rW5jc1/Nlyr/gxIkMy
         Qc3t91UZ3vkqVhyy8GG2joAiXmj1ZORGq7mWVa6Yz2PQ3ZWIfLZWyljTgvAT9V/DXp
         6WEtpwJ8xpBns01oJc4prTvLF62PlaXMAAYZXzSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/313] HID: check empty report_list in bigben_probe()
Date:   Mon, 30 Jan 2023 14:48:40 +0100
Message-Id: <20230130134340.602428828@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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



