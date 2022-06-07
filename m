Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371AD541224
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357054AbiFGToL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357573AbiFGTmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1931B5857;
        Tue,  7 Jun 2022 11:15:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15F90B80B66;
        Tue,  7 Jun 2022 18:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B462C385A2;
        Tue,  7 Jun 2022 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625722;
        bh=7jqS2tTlnNZbrQ98eK9OJ7pRMtBHKuwDuhlgk5Xc4Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4G+X0rV0IexF8fGiIMUhQJHV1JdJmeMmIV9Oz2RjbYG73FTK94qvE2VZ3LKDoOmN
         REvX+P4y4+x0m+92a4SOCR+KzdqDfRNmZNWle/b77ByAOmyEmmhJ2pJF+AMh0GnOU6
         31ItxMz/HScWCSG0yo2zMdPCSFYquj45PfM/XQpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 118/772] HID: bigben: fix slab-out-of-bounds Write in bigben_probe
Date:   Tue,  7 Jun 2022 18:55:10 +0200
Message-Id: <20220607164952.526140367@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



