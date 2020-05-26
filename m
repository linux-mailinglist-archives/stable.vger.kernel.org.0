Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7931E2EAF
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390606AbgEZTbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389936AbgEZS72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8427F2086A;
        Tue, 26 May 2020 18:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519568;
        bh=h26EgQmdrkMUUFsfCMuzV6KRqdC7/qLA91Jzl5Vrlt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyOPpGSP56OMFct1SHC6fTIHcyKFyWv2hfyouWKomURFqGqLKtCmZjQvH7uLBxvoG
         Rgw949iE0ldGMBaKFmHsNQTU81vz8/cvtyjYJ0unUtL7QCszk1oHZOBBJ1AHGbyC1H
         aMcq/PFn2f80zb2sNnTAdpRt8UJduM+LwwhdwWQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Darren Hart (VMware)" <dvhart@infradead.org>
Subject: [PATCH 4.9 54/64] platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer
Date:   Tue, 26 May 2020 20:53:23 +0200
Message-Id: <20200526183930.850716036@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 98e2630284ab741804bd0713e932e725466f2f84 upstream.

Currently the kfree of output.pointer can be potentially freeing
an uninitalized pointer in the case where out_data is NULL. Fix this
by reworking the case where out_data is not-null to perform the
ACPI status check and also the kfree of outpoint.pointer in one block
and hence ensuring the pointer is only freed when it has been used.

Also replace the if (ptr != NULL) idiom with just if (ptr).

Fixes: ff0e9f26288d ("platform/x86: alienware-wmi: Correct a memory leak")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/alienware-wmi.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -504,23 +504,22 @@ static acpi_status alienware_wmax_comman
 
 	input.length = (acpi_size) sizeof(*in_args);
 	input.pointer = in_args;
-	if (out_data != NULL) {
+	if (out_data) {
 		output.length = ACPI_ALLOCATE_BUFFER;
 		output.pointer = NULL;
 		status = wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
 					     command, &input, &output);
-	} else
+		if (ACPI_SUCCESS(status)) {
+			obj = (union acpi_object *)output.pointer;
+			if (obj && obj->type == ACPI_TYPE_INTEGER)
+				*out_data = (u32)obj->integer.value;
+		}
+		kfree(output.pointer);
+	} else {
 		status = wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
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


