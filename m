Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6F74CE7
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391220AbfGYLUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:20:47 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44430 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389393AbfGYLUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:20:47 -0400
Received: by mail-vs1-f67.google.com with SMTP id v129so33443762vsb.11
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=6DcK30PpTPuCKM9YTLUqEUspcWU/lIpJ1+jFNrMw2cs=;
        b=RgSZWnaSX18zKbwUYuW8pERQCPBn4OYsxSX0SZBkmwIRRT8LWde1MdRN8IVtnCSJCc
         4jzvT1PS/LpRAZkBcwwM7c6v6Lu5MBNRQsFIm4kg+B+wNDfeS8pCJfbA9GyhEHZb9taE
         Wj4XySWrHlhabRDzVnGpdMqsQ951wiTZGzGlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=6DcK30PpTPuCKM9YTLUqEUspcWU/lIpJ1+jFNrMw2cs=;
        b=XsW+gf5wD7BPqjzH/IN7t4VIbKOcrO5byxaDdc6rge8OyeS5MsSfHvvFGzKRL4iEcs
         CyI8DHTcupOwAEOu2n1tNJjsK0rFOWwUuX0YbWEP3e1IW/80DfS4cRIvISQsYptI9p/c
         p5S+O3pWqpup3ZmUKjtXE5gi5AKrIhri/kuWbfNXA6hsUgT9SG9SzrqFvFG7j2Bb9b02
         qowOswB8hZV+YqV7EcIGJgNrLFBoo2SO5znSRVQm2A3977JGRHw1nIe8M+epYjrEjmmW
         qA+VnlWr2orpPssjLqkua6kr53UmOdNqesM8tYqlNEkJ0lQUDqBSqxUfPK/7cXIcmBhn
         GRJw==
X-Gm-Message-State: APjAAAUh+P6YERyzp8MBooCKCM1ocXvy2bMyRU9WseRqeIfrX1EEPNIq
        ITkJsy4yB1TJVNlDPKo264H0LOO8ny2xjSabDyPXNA==
X-Google-Smtp-Source: APXvYqwyJ2zNDuiFBRDZSGXZUVqv3sqiXWqSMXcmc7Jggsu4sMEl69y0B8enPxxd8DOK89gm5IH1lx6N+Gq3f5+XAX8=
X-Received: by 2002:a67:8c84:: with SMTP id o126mr56496062vsd.122.1564053646150;
 Thu, 25 Jul 2019 04:20:46 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
References: <20190725191758.23462-1-sumit.saxena@broadcom.com>
In-Reply-To: <20190725191758.23462-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFu2LZIV1NiQ/rnan7cBe6FQlMYJ6eoBG2A
Date:   Thu, 25 Jul 2019 16:50:44 +0530
Message-ID: <23f7699adcf7046058f8b5a9214313d0@mail.gmail.com>
Subject: RE: [PATCH] PCI: set BAR size bits correctly in Resize BAR control register
To:     saxenasumit87m@gmail.com
Cc:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please ignore this.. it was mistakenly sent.

-----Original Message-----
From: Sumit Saxena <sumit.saxena@broadcom.com>
Sent: Friday, July 26, 2019 12:48 AM
To: saxenasumit87m@gmail.com
Cc: chandrakanth.patil@broadcom.com; stable@vger.kernel.org; Sumit Saxena
<sumit.saxena@broadcom.com>
Subject: [PATCH] PCI: set BAR size bits correctly in Resize BAR control
register

In Resize BAR control register, bits[8:12] represents size of BAR.
As per PCIe specification, below is encoded values in register bits to
actual BAR size table:

Bits  BAR size
0     1 MB
1     2 MB
2     4 MB
3     8 MB
--

For 1 MB BAR size, BAR size bits should be set to 0 but incorrectly these
bits are set to "1f".
Latest megaraid_sas and mpt3sas adapters which support Resizable BAR with
1 MB BAR size fails to initialize during system resume from S3 sleep.

Fix: Correctly set BAR size bits to "0" for 1MB BAR size.

CC: stable@vger.kernel.org # v4.16+
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203939
Fixes: d3252ace0bc652a1a244455556b6a549f969bf99 ("PCI: Restore resized BAR
state on resume")
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/pci/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c index 8abc843..b651f32
100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1417,12 +1417,13 @@ static void pci_restore_rebar_state(struct pci_dev
*pdev)

 	for (i = 0; i < nbars; i++, pos += 8) {
 		struct resource *res;
-		int bar_idx, size;
+		int bar_idx, size, order;

 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pdev->resource + bar_idx;
-		size = order_base_2((resource_size(res) >> 20) | 1) - 1;
+		order = order_base_2((resource_size(res) >> 20) | 1);
+		size = order ? order - 1 : 0;
 		ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
 		ctrl |= size << PCI_REBAR_CTRL_BAR_SHIFT;
 		pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);
--
1.8.3.1
