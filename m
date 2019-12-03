Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685EB111D22
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfLCWuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbfLCWub (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5AD2084B;
        Tue,  3 Dec 2019 22:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413431;
        bh=9mvyKiStdqWHIi9NvCE4eDL7Uh0tn5Xgra9f21+o9Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikTEjOwBTv1O0FMwOEvq/I962W0wRcnxicmnPotWj7SsA5PGHVSx+96DxMlQur9P2
         j/2+vF3oAjvmViFcb4GhDnhf/9repUhAbxEc3y2uaB4MG/oqep36VMRSg04KeL2cqR
         mGjpOmeXx5bH5nC3yDyMZaIp5rEAJNB9u/VlLEwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/321] HID: intel-ish-hid: fixes incorrect error handling
Date:   Tue,  3 Dec 2019 23:33:09 +0100
Message-Id: <20191203223433.553853504@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 6e0856d317440a950b17c00a9283114f025e5699 ]

The memory chunk allocated by hid_allocate_device() should be released
by hid_destroy_device(), not kfree().

Fixes: 0b28cb4bcb1("HID: intel-ish-hid: ISH HID client driver")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.c b/drivers/hid/intel-ish-hid/ishtp-hid.c
index cd23903ddcf19..e918d78e541c0 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.c
@@ -222,7 +222,7 @@ int ishtp_hid_probe(unsigned int cur_hid_dev,
 err_hid_device:
 	kfree(hid_data);
 err_hid_data:
-	kfree(hid);
+	hid_destroy_device(hid);
 	return rv;
 }
 
-- 
2.20.1



