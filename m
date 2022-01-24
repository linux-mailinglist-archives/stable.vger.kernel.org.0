Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5D2499F6B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382601AbiAXW6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452034AbiAXWNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:13:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C06C0E03EB;
        Mon, 24 Jan 2022 12:43:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDF93B80FA1;
        Mon, 24 Jan 2022 20:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E49C340E7;
        Mon, 24 Jan 2022 20:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057034;
        bh=96rE6TDrpIIZ1lVQxWZtDllQnUUU4B7R+pVb1uXRYLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULb5B08SWQdAPikeD3CwgusOPgqHQNCTAjEFII3W+ZYfMk99R71yqg6uExru8fotp
         wF70meEU5BLiLP1ukjS69x+8mEjtltipiNga7RL5EXIr1RFN0dcAJTjaCo848+N0CJ
         VXrXn5zhkOUpy6l2kNqF5sHfwyj5Tlx4iZo2HnTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        syzbot+a437546ec71b04dfb5ac@syzkaller.appspotmail.com,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 679/846] HID: magicmouse: Fix an error handling path in magicmouse_probe()
Date:   Mon, 24 Jan 2022 19:43:16 +0100
Message-Id: <20220124184124.495603286@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 33812fc7c8d77a43b7e2bf36a0d5a57c277a4b0c upstream.

If the timer introduced by the commit below is started, then it must be
deleted in the error handling of the probe. Otherwise it would trigger
once the driver is no more.

Fixes: 0b91b4e4dae6 ("HID: magicmouse: Report battery level over USB")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: José Expósito <jose.exposito89@gmail.com>
Reported-by: <syzbot+a437546ec71b04dfb5ac@syzkaller.appspotmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -873,6 +873,7 @@ static int magicmouse_probe(struct hid_d
 
 	return 0;
 err_stop_hw:
+	del_timer_sync(&msc->battery_timer);
 	hid_hw_stop(hdev);
 	return ret;
 }


