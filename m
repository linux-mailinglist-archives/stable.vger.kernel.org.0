Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B3647273A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhLMJ7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39862 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbhLMJxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:53:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40899B80E2F;
        Mon, 13 Dec 2021 09:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDCAC34605;
        Mon, 13 Dec 2021 09:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389228;
        bh=ZYIkG1OlBl5wTCUBGTtuVxJfRXCMzdkwZphnncVVmV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ja6Fn1jGjbXd7mtT/7Eimoy0u72glubmprI859DTPMZHPNEcdyAXp6ntYvr4HAeju
         x0tbiiRzyr3DSjpUlAqka8Hq4Gjfs6fzQaZ7R8H64v5jS10ryTZaScTYuBvTH8UD+r
         yf9m4I/X7Tacff2Wyf0WPfy4LLu5gjhF4tKF8BOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 009/171] HID: bigbenff: prevent null pointer dereference
Date:   Mon, 13 Dec 2021 10:28:44 +0100
Message-Id: <20211213092945.400915621@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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


