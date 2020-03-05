Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C921917AD17
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCERNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgCERNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A212166E;
        Thu,  5 Mar 2020 17:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428398;
        bh=Rcpuoua5mmJzEl3RbXML86RqG0/4QTit1QasTIw5ZQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9+YwtiRue9AFpJ5WdxUPL1ooBEzlE/fPSgmer0iNm+Zc0hYOhmePB9s7ijXWxfok
         stoecobb06C+Sw4A6ns6k5rDD27vVvyadoAM23oOKjDTR+VeZxLy4YH87FueLT7IT2
         yo4pQIUHDlEFBzK8McDo+Ulhildac5q7pPtlLpzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 06/67] HID: alps: Fix an error handling path in 'alps_input_configured()'
Date:   Thu,  5 Mar 2020 12:12:07 -0500
Message-Id: <20200305171309.29118-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8d2e77b39b8fecb794e19cd006a12f90b14dd077 ]

They are issues:
   - if 'input_allocate_device()' fails and return NULL, there is no need
     to free anything and 'input_free_device()' call is a no-op. It can
     be axed.
   - 'ret' is known to be 0 at this point, so we must set it to a
     meaningful value before returning

Fixes: 2562756dde55 ("HID: add Alps I2C HID Touchpad-Stick support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index ae79a7c667372..fa704153cb00d 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -730,7 +730,7 @@ static int alps_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	if (data->has_sp) {
 		input2 = input_allocate_device();
 		if (!input2) {
-			input_free_device(input2);
+			ret = -ENOMEM;
 			goto exit;
 		}
 
-- 
2.20.1

