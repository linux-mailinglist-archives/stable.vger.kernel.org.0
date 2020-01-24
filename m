Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7757147CC2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgAXJy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731584AbgAXJy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:54:28 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157512075D;
        Fri, 24 Jan 2020 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859667;
        bh=X92FrQQdcFrf/SaNRGaHJNaRL+FGFKOytOntdtpAkqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpbCHiJ7uA3uRGL9kzkDtIOzuFKYwYFlzZEPHffe9ICNcoRWadiO7WskXRiqJf3hS
         E42dem9FUiZ/a99Xu2zbQDiFpgTnP7z/1YtOSKq57EeJOcDan8h83MC+5/qqjTJq2/
         m8jGztM6Lvi8ysUzTnLV3/QmqSc1HYVux0m2dglM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Darren Hart (VMware)" <dvhart@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 169/343] platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer
Date:   Fri, 24 Jan 2020 10:29:47 +0100
Message-Id: <20200124092942.237621910@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 98e2630284ab741804bd0713e932e725466f2f84 ]

Currently the kfree of output.pointer can be potentially freeing
an uninitalized pointer in the case where out_data is NULL. Fix this
by reworking the case where out_data is not-null to perform the
ACPI status check and also the kfree of outpoint.pointer in one block
and hence ensuring the pointer is only freed when it has been used.

Also replace the if (ptr != NULL) idiom with just if (ptr).

Fixes: ff0e9f26288d ("platform/x86: alienware-wmi: Correct a memory leak")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/alienware-wmi.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/alienware-wmi.c b/drivers/platform/x86/alienware-wmi.c
index e335b18da20fc..cbd84e2e3bd47 100644
--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -505,23 +505,22 @@ static acpi_status alienware_wmax_command(struct wmax_basic_args *in_args,
 
 	input.length = (acpi_size) sizeof(*in_args);
 	input.pointer = in_args;
-	if (out_data != NULL) {
+	if (out_data) {
 		output.length = ACPI_ALLOCATE_BUFFER;
 		output.pointer = NULL;
 		status = wmi_evaluate_method(WMAX_CONTROL_GUID, 0,
 					     command, &input, &output);
-	} else
+		if (ACPI_SUCCESS(status)) {
+			obj = (union acpi_object *)output.pointer;
+			if (obj && obj->type == ACPI_TYPE_INTEGER)
+				*out_data = (u32)obj->integer.value;
+		}
+		kfree(output.pointer);
+	} else {
 		status = wmi_evaluate_method(WMAX_CONTROL_GUID, 0,
 					     command, &input, NULL);
-
-	if (ACPI_SUCCESS(status) && out_data != NULL) {
-		obj = (union acpi_object *)output.pointer;
-		if (obj && obj->type == ACPI_TYPE_INTEGER)
-			*out_data = (u32) obj->integer.value;
 	}
-	kfree(output.pointer);
 	return status;
-
 }
 
 /*
-- 
2.20.1



