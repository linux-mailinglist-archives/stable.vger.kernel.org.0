Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90D2E4329
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407042AbgL1Pdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407318AbgL1Nxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D51B2064B;
        Mon, 28 Dec 2020 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163575;
        bh=ycu+JE1DE1QEQDhy6MtUTnnqk2x6wQmu47w4i+VT+l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNwWiarWCBE49cLMVikQ3GGrKWNYyi8YI+ln9EWd9nNSHdmIufx/Gy39GV30wdoY+
         jeVbwrwGkA4wp0mPOCm4u9oAp+KVD/STBCSt1ro9AFPU7gScb8CdIVs9zNp/N069Lo
         yDLV21mfP0uMhLS1Wvg8m8tHPFJSXNERJo8lHeoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 332/453] Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"
Date:   Mon, 28 Dec 2020 13:49:28 +0100
Message-Id: <20201228124953.201572727@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <djrscally@gmail.com>

commit 12fc4dad94dfac25599f31257aac181c691ca96f upstream.

This reverts commit 8a66790b7850a6669129af078768a1d42076a0ef.

Switching this function to AE_CTRL_TERMINATE broke the documented
behaviour of acpi_dev_get_resources() - AE_CTRL_TERMINATE does not, in
fact, terminate the resource walk because acpi_walk_resource_buffer()
ignores it (specifically converting it to AE_OK), referring to that
value as "an OK termination by the user function". This means that
acpi_dev_get_resources() does not abort processing when the preproc
function returns a negative value.

Signed-off-by: Daniel Scally <djrscally@gmail.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -541,7 +541,7 @@ static acpi_status acpi_dev_process_reso
 		ret = c->preproc(ares, c->preproc_data);
 		if (ret < 0) {
 			c->error = ret;
-			return AE_CTRL_TERMINATE;
+			return AE_ABORT_METHOD;
 		} else if (ret > 0) {
 			return AE_OK;
 		}


