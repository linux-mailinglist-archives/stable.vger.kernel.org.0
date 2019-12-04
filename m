Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB7111337B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbfLDSMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbfLDSMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:10 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D38F1214AF;
        Wed,  4 Dec 2019 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483130;
        bh=72si8NNBzDHWEy6P8LB/sxnbv3JGkev8Astuf7ElLT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xixNRhSpQEyVu6Tp6ZGGa7Jg4ZQC7XiAn1QvfmjkETTai5El1xuGCbtGCMqTRLVoU
         q33IwUR6qVRDgg2uG2M0qinMOM8hEjz5wtTmfifskjWSCdC5ysttv617fTh0vsEihu
         0tqm1SzFoatU3jtIFu4W8sf1O20ONS2joy/M8SVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 037/125] HID: intel-ish-hid: fixes incorrect error handling
Date:   Wed,  4 Dec 2019 18:55:42 +0100
Message-Id: <20191204175321.235489390@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
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
index 277983aa1d90a..d0b902285fc3a 100644
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



