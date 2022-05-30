Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E373A537D3B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbiE3Ngq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbiE3Neq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A93792D1B;
        Mon, 30 May 2022 06:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E4860F17;
        Mon, 30 May 2022 13:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6639BC36AE3;
        Mon, 30 May 2022 13:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917293;
        bh=7jqS2tTlnNZbrQ98eK9OJ7pRMtBHKuwDuhlgk5Xc4Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pY5SOlyv1mA4vc/SuYQAWLivWZH5SI3mGcjgBH6lURkmEuH6Q7AoiAjYYoNG4PLJs
         nkWVufmaS33cSq1y+uoyBV3SgkRQmQC6f1KgZpqbeBS/YEBmtzJiKhvqvc2C6oN1Lm
         PNoTCbIRq13c35phbViyK7drSUFQjVRgGoZd+EKlgPgfCZdU1fR+GBQ9bnBdxByiBE
         SwUSPc6RbogcJSVxdVhB5EKuXvAZinkCoFJaA6edT8Pv72oDuhUb6GZlRIQGUDJtdd
         sytYgM4TwrovYe7fHqw74cp3oW+aZtaqjAHwzq5ko5l3hFVbFTnyBkV7S73a0k+X32
         qdZtYvvlQodIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 086/159] HID: bigben: fix slab-out-of-bounds Write in bigben_probe
Date:   Mon, 30 May 2022 09:23:11 -0400
Message-Id: <20220530132425.1929512-86-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit fc4ef9d5724973193bfa5ebed181dba6de3a56db ]

There is a slab-out-of-bounds Write bug in hid-bigbenff driver.
The problem is the driver assumes the device must have an input but
some malicious devices violate this assumption.

Fix this by checking hid_device's input is non-empty before its usage.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index 74ad8bf98bfd..e8c5e3ac9fff 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -347,6 +347,12 @@ static int bigben_probe(struct hid_device *hid,
 	bigben->report = list_entry(report_list->next,
 		struct hid_report, list);
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		error = -ENODEV;
+		goto error_hw_stop;
+	}
+
 	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
 	set_bit(FF_RUMBLE, hidinput->input->ffbit);
 
-- 
2.35.1

