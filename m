Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D54047FFAB
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhL0Pko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41372 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbhL0PiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C727CE10DA;
        Mon, 27 Dec 2021 15:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0EAC36AEA;
        Mon, 27 Dec 2021 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619485;
        bh=H0HHYpbenK6uheiZGZ04BgxBP4iVEriNtRL4NINrOvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXGEbfM6qyjEM60Kg3Y7yzZu2G5U5kaad94kyGEdAxXdBIwvI9RpaGV9aszWI7R+4
         bja6nHg3vK9FDhiTJdrmEfIhpaFGEm/cSAXsGw8ZS9/jdHV+aV7V6vf4SFf5/SxYpv
         yBuuRVjpIE6qURo1m459+BR5Yr0RrnyDs/UokBt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.10 08/76] HID: potential dereference of null pointer
Date:   Mon, 27 Dec 2021 16:30:23 +0100
Message-Id: <20211227151324.999963838@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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


