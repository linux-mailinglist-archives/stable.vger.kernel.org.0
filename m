Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2288DE684D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbfJ0VWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731496AbfJ0VWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:32 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3F45205C9;
        Sun, 27 Oct 2019 21:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211352;
        bh=E2dLrKShCGptKM9yTrlBFPaj+LfW1k7X97ub5bP3gr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTFkLkUaddmIGpRH9gUBYw1BrocNKfQRHnstC4lfkUGTZjoksjTISaRNEvHmPlZHu
         MHw+sGMphzosXIfFYqc3oPvT1sUyyXpuR0W3+KQeV5SSPDyzO2plVq0vpJrW2QhfTx
         NCgFl6hAyZLJGQ+w4pygNrDl5rmYasDCaJuPg1tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.3 120/197] ACPI: NFIT: Fix unlock on error in scrub_show()
Date:   Sun, 27 Oct 2019 22:00:38 +0100
Message-Id: <20191027203358.213846715@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit edffc70f505abdab885f4b4212438b4298dec78f upstream.

We change the locking in this function and forgot to update this error
path so we are accidentally still holding the "dev->lockdep_mutex".

Fixes: 87a30e1f05d7 ("driver-core, libnvdimm: Let device subsystems add local lockdep coverage")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/nfit/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1322,7 +1322,7 @@ static ssize_t scrub_show(struct device
 	nfit_device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
 	if (!nd_desc) {
-		device_unlock(dev);
+		nfit_device_unlock(dev);
 		return rc;
 	}
 	acpi_desc = to_acpi_desc(nd_desc);


