Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369B35AB010
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiIBMsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbiIBMsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:48:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91B0F2430;
        Fri,  2 Sep 2022 05:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A24C9621AF;
        Fri,  2 Sep 2022 12:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5320C433D6;
        Fri,  2 Sep 2022 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121950;
        bh=qoyw/ywdNO6sZyo1tUQ3AoaTQwR0eePql9n0oiR6GcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjSCePsB+G6UUZ6fv8prV0bPPcJpCqB2jZNwSmcn7/HNEWhYHxXUUNTK898jDrfD9
         BHnTJGBYx6tnQlKNw3npqk6TUKmTAG1vSbTAs5KjeqhW/4TEMkChxPFw9s1s5Pe2nR
         rFjFRQ0GUmsqNduEax5d0H7HKfIS6Odwihzq2FW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Kilmer <srjek2@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 39/73] HID: asus: ROG NKey: Ignore portion of 0x5a report
Date:   Fri,  2 Sep 2022 14:19:03 +0200
Message-Id: <20220902121405.718984071@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: Josh Kilmer <srjek2@gmail.com>

commit 1c0cc9d11c665020cbeb80e660fb8929164407f4 upstream.

On an Asus G513QY, of the 5 bytes in a 0x5a report, only the first byte
is a meaningful keycode. The other bytes are zeroed out or hold garbage
from the last packet sent to the keyboard.

This patch fixes up the report descriptor for this event so that the
general hid code will only process 1 byte for keycodes, avoiding
spurious key events and unmapped Asus vendor usagepage code warnings.

Signed-off-by: Josh Kilmer <srjek2@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1212,6 +1212,13 @@ static __u8 *asus_report_fixup(struct hi
 		rdesc = new_rdesc;
 	}
 
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD &&
+			*rsize == 331 && rdesc[190] == 0x85 && rdesc[191] == 0x5a &&
+			rdesc[204] == 0x95 && rdesc[205] == 0x05) {
+		hid_info(hdev, "Fixing up Asus N-KEY keyb report descriptor\n");
+		rdesc[205] = 0x01;
+	}
+
 	return rdesc;
 }
 


