Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9047292A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243857AbhLMKSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39450 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhLMJsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:48:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8ACBDCE0E82;
        Mon, 13 Dec 2021 09:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3637BC341CA;
        Mon, 13 Dec 2021 09:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388912;
        bh=ZYIkG1OlBl5wTCUBGTtuVxJfRXCMzdkwZphnncVVmV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn/a2YQBoPuDG2b+TkjWxwBmr1hTYFQznlASlC7MV5808fl2XVvMI3mdVDzDPnS55
         cRO7MspkCDzw3xd0GobE7bhU5iGt9pcoKdge6BJl44DnZtUqVdenXQNJg/I40cQ/UC
         3+BuT7cZCnYKMp3AeoNAvs4Er4pUO1h4gY3s8Wto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.10 010/132] HID: bigbenff: prevent null pointer dereference
Date:   Mon, 13 Dec 2021 10:29:11 +0100
Message-Id: <20211213092939.429343245@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 918aa1ef104d286d16b9e7ef139a463ac7a296f0 upstream.

When emulating the device through uhid, there is a chance we don't have
output reports and so report_field is null.

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20211202095334.14399-3-benjamin.tissoires@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-bigbenff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -191,7 +191,7 @@ static void bigben_worker(struct work_st
 		struct bigben_device, worker);
 	struct hid_field *report_field = bigben->report->field[0];
 
-	if (bigben->removed)
+	if (bigben->removed || !report_field)
 		return;
 
 	if (bigben->work_led) {


