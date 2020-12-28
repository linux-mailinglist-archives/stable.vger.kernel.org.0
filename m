Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3B2E38E6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733252AbgL1NQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733219AbgL1NQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:16:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 267AF21D94;
        Mon, 28 Dec 2020 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161351;
        bh=uCSZ2S0uiBhH2ima5mqECjLF01VKfsPu/to1MACyatg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7NIHAg+fu5DUeOKsKD2okBe2r99G9HaIklDxH5AHB+78iSQkFrVNAHOSxXSjSxSi
         /XOrX7aVykP2snTltjqNQ2pNi6yNMwr1U0upQteD49dZNYEjyO+cB796JQpCLSe+ej
         ZQWqCg8g93r7FVNeCWsRtHMqY2FsB7L6iTZawVyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 186/242] Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"
Date:   Mon, 28 Dec 2020 13:49:51 +0100
Message-Id: <20201228124913.851374622@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
@@ -548,7 +548,7 @@ static acpi_status acpi_dev_process_reso
 		ret = c->preproc(ares, c->preproc_data);
 		if (ret < 0) {
 			c->error = ret;
-			return AE_CTRL_TERMINATE;
+			return AE_ABORT_METHOD;
 		} else if (ret > 0) {
 			return AE_OK;
 		}


