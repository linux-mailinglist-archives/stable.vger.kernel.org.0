Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4CB47FFFE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbhL0PmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40076 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhL0Pkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4CD161047;
        Mon, 27 Dec 2021 15:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EC5C36AEA;
        Mon, 27 Dec 2021 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619642;
        bh=H0HHYpbenK6uheiZGZ04BgxBP4iVEriNtRL4NINrOvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6DPLBUJjnSDvqNUpVDEPNSXXyinGeWQ5rVlyZ/8UTQ8VuEb67q6Sc42f9lj6eN9z
         hC8OBBlzvzfT/PAisFgs3aUrAQS/+GPUKYz/CIoKL3gV8ZhxP1X1ER1meznpr/xSb+
         e70aSDog+nMyvinCB3G9G7Kt95oXuP2iofBQPtFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 008/128] HID: potential dereference of null pointer
Date:   Mon, 27 Dec 2021 16:29:43 +0100
Message-Id: <20211227151331.778935576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit 13251ce1dd9bb525da2becb9b26fdfb94ca58659 upstream.

The return value of devm_kzalloc() needs to be checked.
To avoid hdev->dev->driver_data to be null in case of the failure of
alloc.

Fixes: 14c9c014babe ("HID: add vivaldi HID driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211215083605.117638-1-jiasheng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-vivaldi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-vivaldi.c
+++ b/drivers/hid/hid-vivaldi.c
@@ -57,6 +57,9 @@ static int vivaldi_probe(struct hid_devi
 	int ret;
 
 	drvdata = devm_kzalloc(&hdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
 	hid_set_drvdata(hdev, drvdata);
 
 	ret = hid_parse(hdev);


