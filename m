Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF13D689672
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjBCK3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjBCK2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE412D7E
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75FD761E42
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E40AC433D2;
        Fri,  3 Feb 2023 10:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420046;
        bh=8Z+/H/jfAMpjZtXvvjZQ7vLgoTAnpHyHMhT1kzXVJcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ3JbYBa+T1gyYEr8ebqqxVOVrSi5AiXzDcVGr85nLop0rzd6UMDT1imB1I2WwNEH
         uyRRLbw7KltybA0GcyNV7BPwkD1slsnJiqFkka3sy1SLwWvwNRtDsUk0Kh4uGvneav
         AezfA4qQoRPNlpfVX4O37wlA+dR7elUl3Iqojiaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/134] HID: check empty report_list in hid_validate_values()
Date:   Fri,  3 Feb 2023 11:12:17 +0100
Message-Id: <20230203101025.311756022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index eda96c92977b..2888bd5502f3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -981,8 +981,8 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
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



