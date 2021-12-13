Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5047263F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhLMJtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbhLMJrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411C4C07E5F0;
        Mon, 13 Dec 2021 01:42:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E2D6B80E12;
        Mon, 13 Dec 2021 09:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827DDC00446;
        Mon, 13 Dec 2021 09:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388570;
        bh=ZYIkG1OlBl5wTCUBGTtuVxJfRXCMzdkwZphnncVVmV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPTyVhzdcyGrJqdXNiVEeVKmQYhRdvtSHwTil8siqiEFvMqvN4HG+jOSUqdwoJ80n
         hYVqlgUwEueBsHTLzd4wXgeGQqxnx+YKh4m6hQEr9bJFL1NQkMYoJiO/wl2FuhK1tp
         PDs/7HVqrm0GbuECUNbUXA9yH4tCfCAyc2aOdxGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.4 09/88] HID: bigbenff: prevent null pointer dereference
Date:   Mon, 13 Dec 2021 10:29:39 +0100
Message-Id: <20211213092933.551227122@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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


