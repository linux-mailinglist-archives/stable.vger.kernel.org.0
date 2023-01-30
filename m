Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF716681157
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbjA3OM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbjA3OMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04323BD8D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85B64B811CC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F3DC433EF;
        Mon, 30 Jan 2023 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087933;
        bh=8p/xeOIoapy+wEU9yglndDAsvBh0eaGTdbj5+Yohxgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVECyNbSYJzOilwKsttMR8/tVCtao67LO85zLJ4z5v/dAQ3hfApW8LfNzjSlxsCc1
         4GBLV0e4clP/soEIWBB/v0hAq9S3HcYjIxcpUHrHQGfOy+xjcT/TeFvO/D/T4nJYxf
         stH9k4MxhdBfd4sH4IKwkRGf8OxuSpv5kzab/HjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/204] HID: check empty report_list in hid_validate_values()
Date:   Mon, 30 Jan 2023 14:50:23 +0100
Message-Id: <20230130134318.867399178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

[ Upstream commit b12fece4c64857e5fab4290bf01b2e0317a88456 ]

Add a check for empty report_list in hid_validate_values().
The missing check causes a type confusion when issuing a list_entry()
on an empty report_list.
The problem is caused by the assumption that the device must
have valid report_list. While this will be true for all normal HID
devices, a suitably malicious device can violate the assumption.

Fixes: 1b15d2e5b807 ("HID: core: fix validation of report id 0")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index ef9c799fa371..2e475bd426b8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -988,8 +988,8 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
 		 * Validating on id 0 means we should examine the first
 		 * report in the list.
 		 */
-		report = list_entry(
-				hid->report_enum[type].report_list.next,
+		report = list_first_entry_or_null(
+				&hid->report_enum[type].report_list,
 				struct hid_report, list);
 	} else {
 		report = hid->report_enum[type].report_id_hash[id];
-- 
2.39.0



