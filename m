Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8027D5AB14C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiIBNTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiIBNS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:18:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D92D4F64;
        Fri,  2 Sep 2022 05:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77A76CE2E67;
        Fri,  2 Sep 2022 12:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C65C433D7;
        Fri,  2 Sep 2022 12:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122125;
        bh=I0grwLaSN42BWeq13VtFyJ/P4Grxplt0kp3cRmVG1sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNYgyu9v+rtmEMvmehKoa2RMBETerMYR6bpN+kSYEYUZ/Z1ArmDgHdm+1Blt/bDrC
         v7+dB6gWVpnXxlsHYUamlxswHPBg15PwxvFnpUiS1HXckkqDPEKlCaAjSeXqPNK8R/
         /OoAbzaPqZ98n3XXp/QpZmlCAa358itIr38FyQzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hansson <newbie13xd@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 20/72] HID: input: fix uclogic tablets
Date:   Fri,  2 Sep 2022 14:18:56 +0200
Message-Id: <20220902121405.445523018@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 8db8be9cfc89935c97d791c7e6264e710a7e8a56 upstream.

commit 87562fcd1342 ("HID: input: remove the need for HID_QUIRK_INVERT")
made the assumption that it was the only one handling tablets and thus
kept an internal state regarding the tool.

Turns out that the uclogic driver has a timer to release the in range
bit, effectively making hid-input ignoring all in range information
after the very first one.

Fix that by having a more rationale approach which consists in forwarding
every event and let the input stack filter out the duplicates.

Reported-by: Stefan Hansson <newbie13xd@gmail.com>
Fixes: 87562fcd1342 ("HID: input: remove the need for HID_QUIRK_INVERT")
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-input.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1532,7 +1532,10 @@ void hidinput_hid_event(struct hid_devic
 			 * assume ours
 			 */
 			if (!report->tool)
-				hid_report_set_tool(report, input, usage->code);
+				report->tool = usage->code;
+
+			/* drivers may have changed the value behind our back, resend it */
+			hid_report_set_tool(report, input, report->tool);
 		} else {
 			hid_report_release_tool(report, input, usage->code);
 		}


