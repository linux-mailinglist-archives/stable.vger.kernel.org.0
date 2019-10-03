Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA13CA1AE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbfJCP60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731129AbfJCP6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:58:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CCE321A4C;
        Thu,  3 Oct 2019 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118303;
        bh=wKhq0VlGv+xSfbaRl9RM2mr581f4Gr7wpu/qX6+fz9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/O8snOPOnSwXgWYd/ddGXrx+mjdXkf9B03/ZcfPhQYJjVwVIJoNmOdus/jkMB3yN
         VWsbQ5QRb4rUvakpWCGnsVB6UxqIfefiEKzAuWq+GjHcFttYcaP6Kl/kXxpDqTCev6
         iD54hH+ePsgPfPy2S95mpqQP3IaWcR6mCVNulJNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Stone <ahs3@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 62/99] ACPI / CPPC: do not require the _PSD method
Date:   Thu,  3 Oct 2019 17:53:25 +0200
Message-Id: <20191003154326.977690200@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Stone <ahs3@redhat.com>

[ Upstream commit 4c4cdc4c63853fee48c02e25c8605fb65a6c9924 ]

According to the ACPI 6.3 specification, the _PSD method is optional
when using CPPC.  The underlying assumption is that each CPU can change
frequency independently from all other CPUs; _PSD is provided to tell
the OS that some processors can NOT do that.

However, the acpi_get_psd() function returns ENODEV if there is no _PSD
method present, or an ACPI error status if an error occurs when evaluating
_PSD, if present.  This makes _PSD mandatory when using CPPC, in violation
of the specification, and only on Linux.

This has forced some firmware writers to provide a dummy _PSD, even though
it is irrelevant, but only because Linux requires it; other OSPMs follow
the spec.  We really do not want to have OS specific ACPI tables, though.

So, correct acpi_get_psd() so that it does not return an error if there
is no _PSD method present, but does return a failure when the method can
not be executed properly.  This allows _PSD to be optional as it should
be.

Signed-off-by: Al Stone <ahs3@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 0afd1981e350b..43c27c04c40ae 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -137,8 +137,10 @@ static int acpi_get_psd(struct cpc_desc *cpc_ptr, acpi_handle handle)
 	union acpi_object  *psd = NULL;
 	struct acpi_psd_package *pdomain;
 
-	status = acpi_evaluate_object_typed(handle, "_PSD", NULL, &buffer,
-			ACPI_TYPE_PACKAGE);
+	status = acpi_evaluate_object_typed(handle, "_PSD", NULL,
+					    &buffer, ACPI_TYPE_PACKAGE);
+	if (status == AE_NOT_FOUND)	/* _PSD is optional */
+		return 0;
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-- 
2.20.1



